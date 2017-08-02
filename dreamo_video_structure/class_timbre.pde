import ddf.minim.analysis.*;

class Timbre extends FeaturesExtractor
{
  
  //**** SPECTRUM DATA
  private float[] FFTcoeffs;
  private int specSize;
  
  //**** AVERAGE SPECTRUM MAGNITUDE
  private float avgMagnitude;
  
  //**** CENTROID VARIABLES
  private float spectralCentroidHz;
  private float spectralCentroidNormalized;
  
  //**** CENTROID STATISTICS
  private Statistics centroidLongTerm; //long term statistics
  private final int W=129  ; // long term statistics window length (43=~1s)
  private Statistics centroidShortTerm; //short term statistics
  
  //**** COMPLEXITY VARIABLES
  private float spectralComplexity;
  private final float COMPLEXITY_THRESHOLD_COEFF=2.6;
  
  //COMPLEXITY STATISTICS
  private Statistics complexityLongTerm;
  
  //ZERO CROSSING RATE
  private float ZCR;
  
  
  //**** CONSTRUCTOR
  public Timbre(int bSize, float sRate)
  {
    
    buffSize=bSize;
    sampleRate=sRate; 
    
    FFTcoeffs=new float[bSize/2+1];
    
    spectralCentroidHz=0;
    spectralComplexity=0;
    
    //initialize statistics data
    centroidLongTerm=new Statistics(W);
    centroidShortTerm=new Statistics(21); //~1 sec   
    
    complexityLongTerm=new Statistics(W);
    
    ZCR=0;
    
  }
  
  //**** SET METHODS
  /**
   * Sets FFT coefficients (used in AudioProcessor)
   */
  public void setFFTCoeffs(float[] coeffs, int size)
  {
    specSize=size;    
    FFTcoeffs=coeffs.clone();
  }
 
  public void setAvgMagnitude(float avgm) { avgMagnitude=avgm; }
  
  
  //**** GET METHODS
  public float getAvgMagnitude() { return avgMagnitude; }  
  
  //CENTROID  
  public float getCentroid() { return spectralCentroidNormalized; } //instantaneous - normalized respect the theoretical maximum
  
  public float getCentroidAvg() { return centroidLongTerm.getAverage(); } //average - normalized respect the theoretical maximum
  
  public float getCentroidStdDev() { return centroidLongTerm.getStdDev(); } //std deviation - normalized respect the theoretical maximum
  
  public float getCentroidHz() { return spectralCentroidHz; } //instantaneous in Hz
  
  public float getCentroidShortTimeAvgHz() { return centroidShortTerm.getAverage(); }
  
  public float getCentroidShortTimeMaxHz() { return centroidShortTerm.getMax(); }
  
  //COMPLEXITY
  public float getComplexity() { return spectralComplexity; }
  
  public float getComplexityAvg() { return complexityLongTerm.getAverage(); }
  
  public float getMagnitudeThreshold() { return COMPLEXITY_THRESHOLD_COEFF;}
  
  //ZCR
  public float getZeroCrossingRate() {return ZCR;}
  
  
  //**** CALC FEATURES METHOD (overrides the inherited method)
  public void calcFeatures()
  {
    calcSpectralCentroid(); //contains also spectral complexity calc
    calcSpectralComplexity();
    calcZeroCrossingRate();
  }
   
 
  //**** PRIVATE METHODS
  /**
   * Spectral centroid computation method
   * see https://en.wikipedia.org/wiki/Spectral_centroid
   */
  private void calcSpectralCentroid()
  {
    
    float num=0;
    float denom=0;
    float SC=0;
    
    for(int i=0;i<specSize-1;i++)
    {
      num+=(centerFreqHz(i)*FFTcoeffs[i]);
      denom+=FFTcoeffs[i];    
    }
       
    if(denom!=0){SC = (float)num/denom;}
    else{SC=0;}
    
    //get the value in Hz before the mapping (with smoothing)
    spectralCentroidHz=expSmooth(SC, spectralCentroidHz, 5);  
    
    //collect data for short time stats
    centroidShortTerm.accumulate(SC); //accumulate values       
    
    //accumulate for long term statistcs
    centroidLongTerm.accumulate(SC);
    
    //smoothing
    spectralCentroidNormalized=expSmooth(SC, spectralCentroidNormalized, 5);
  }
  
  private void calcSpectralComplexity()
  {  
   
   int peaks =0;
    
   for(int i=1;i<specSize-1;i++)
   {
     boolean largerThanPrevious = (FFTcoeffs[i - 1] < FFTcoeffs[i]);
     boolean largerThanNext = (FFTcoeffs[i] > FFTcoeffs[i + 1]);
     boolean largerThanNoiseFloor = (FFTcoeffs[i] > avgMagnitude*COMPLEXITY_THRESHOLD_COEFF); 
    
     if (largerThanPrevious && largerThanNext && largerThanNoiseFloor)
     {
       peaks++;
     }    
   }
          
      spectralComplexity=expSmooth(peaks,spectralComplexity,5);      
      complexityLongTerm.accumulate(spectralComplexity);      
      
  }
   
   
  private void calcZeroCrossingRate()
  {
    float zeroCrossingRate=0;   
    int numberOfZeroCrossings = 0;
    for(int i = 1 ; i < samples.length ; i++){
      if(samples[i] * samples[i-1] < 0){
        numberOfZeroCrossings++;
      }
    }
    
    zeroCrossingRate = numberOfZeroCrossings / (float) (samples.length - 1);
    
    //smoothing
    ZCR=expSmooth(zeroCrossingRate,ZCR,5);    
  }
   
  
  /**
   * Returns the center frequency on Hz of the idx-th bin in the spectrum
   */
  private float centerFreqHz(int idx)
  { 
     return (idx*sampleRate)/buffSize; 
  }
  
}