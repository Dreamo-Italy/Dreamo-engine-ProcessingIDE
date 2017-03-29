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
  private final float CENTROID_THEORETICAL_MAX = 4000; //based on empirical tests
  private final float CENTROID_THEORETICAL_MIN = 500; //based on empirical tests
  
  //**** CENTROID STATISTICS
  private Statistics centroidLongTerm; //long term statistics
  private final int W=129  ; // long term statistics window length (43=~1s)
  private Statistics centroidShortTerm; //short term statistics
  private Statistics centroidMaxStats;  //maximum statistics
  private float centroidMax; //stores the maximum value
  private Hysteresis maxControl;
  
  //**** COMPLEXITY VARIABLES
  private float spectralComplexity;
  private final float COMPLEXITY_THRESHOLD_COEFF=1.5;
  private final float COMPLEXITY_THEORETICAL_MAX=45; //based on empirical tests
  private final float COMPLEXITY_THEORETICAL_MIN=15; //based on empirical tests
  
  //COMPLEXITY STATISTICS
  private Statistics complexityLongTerm;
  
  
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
    centroidShortTerm=new Statistics(21); //~0.5 sec   
    centroidMaxStats=new Statistics(6);  
    centroidMax=1;
    maxControl=new Hysteresis(43);
    
    complexityLongTerm=new Statistics(W);
    
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
  
  //CENTROID
  public float getAvgMagnitude() { return avgMagnitude; }
  
  public float getCentroid() { return spectralCentroidNormalized; } //instantaneous - normalized respect the theoretical maximum
  
  public float getCentroidAvg() { return centroidLongTerm.getAverage(); } //average - normalized respect the theoretical maximum
  
  public float getCentroidStdDev() { return centroidLongTerm.getStdDev(); } //std deviation - normalized respect the theoretical maximum
  
  public float getCentroidHz() { return spectralCentroidHz; } //instantaneous in Hz
  
  public float getCentroidAverageMax() { return centroidMaxStats.getAverage(); } //average maximum in Hz
  
  public float getCentroidRelativeRatio() 
  { 
    if(centroidMaxStats.getAverage()<1) return 0;
    else return centroidShortTerm.getAverage()/centroidMaxStats.getAverage(); 
  } //dymaic ratio
  
  
  public float getCentroidShortTimeAvgHz() { return centroidShortTerm.getAverage(); }
  
  //COMPLEXITY
  public float getComplexity() { return spectralComplexity; }
  
  public float getComplexityAvg() { return complexityLongTerm.getAverage(); }
  
  
  //**** CALC FEATURES METHOD (overrides the inherited method)
  public void calcFeatures()
  {
    calcSpectralCentroid();
    
  }
  
  //**** RESET MAXIMUM
  public void reset()
  {
    centroidMax=0;
    centroidMaxStats.reset();
  }
 
 
  //**** PRIVATE METHODS
  /**
   * Spectral centroid computation method
   * see https://en.wikipedia.org/wiki/Spectral_centroid
   */
  private void calcSpectralCentroid()
  {
    float lowsum=0;
    float num=0;
    float denom=0;
    float SC=0;
    float binsOverAvg=0;
    
    for(int i=0;i<specSize-1;i++)
    {
      //spectral complexity
      if(i<=specSize/2) 
      {
        if(FFTcoeffs[i]>avgMagnitude*COMPLEXITY_THRESHOLD_COEFF){binsOverAvg++;}
      }
      //spectral centroid
      //if(FFTcoeffs[i]<0.2){FFTcoeffs[i]=0;} //clean 
      num+=(centerFreqHz(i)*FFTcoeffs[i]);
      denom+=FFTcoeffs[i];    
    }
    
    calcSpectralComplexity(binsOverAvg);
    
    if(denom!=0){SC = (float)num/denom;}
    else{SC=0;}
    
    //get the value in Hz before the mapping (with smoothing)
    spectralCentroidHz=expSmooth(SC, spectralCentroidHz, 5);  
    
    //collect data for short time stats
    centroidShortTerm.accumulate(SC); //accumulate values   
    
    //update maximum
    if (spectralCentroidHz > centroidMax) 
    {
      centroidMaxStats.accumulate(spectralCentroidHz);
      centroidMax = spectralCentroidHz;
    }
    
    if(maxControl.checkWindow(centroidMax,CENTROID_THEORETICAL_MAX,CENTROID_THEORETICAL_MAX))
    {
      centroidMax=0;
      centroidMaxStats.reset();
      maxControl.restart();
    }
        
    //map respect the theoretical maximum
    SC=map(SC,CENTROID_THEORETICAL_MIN,CENTROID_THEORETICAL_MAX,0,1);
    
    //accumulate for long term statistcs
    centroidLongTerm.accumulate(SC);
    
    //smoothing
    spectralCentroidNormalized=expSmooth(SC, spectralCentroidNormalized, 5);
  }
  
  private void calcSpectralComplexity(float bins)
  {  
    if(avgMagnitude>0.5)
    {
      spectralComplexity=expSmooth(bins,spectralComplexity,5);
      spectralComplexity=map(bins,COMPLEXITY_THEORETICAL_MIN,COMPLEXITY_THEORETICAL_MAX,0,1);
      complexityLongTerm.accumulate(spectralComplexity);      
    }  
  }
   
  
  /**
   * Returns the center frequency on Hz of the idx-th bin in the spectrum
   */
  private float centerFreqHz(int idx)
  { 
     return (idx*sampleRate)/buffSize; 
  }
  
}