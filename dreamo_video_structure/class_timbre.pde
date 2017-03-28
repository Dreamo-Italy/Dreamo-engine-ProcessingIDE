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
  private final float CENTROID_THEORETICAL_MAX = 7000; //based on empirical tests
  
  //**** CENTROID STATISTICS
  private Statistics centroidLongTerm; //long term statistics
  private final int W=129  ; // long term statistics window length (43=~1s)
  private Statistics centroidShortTerm; //short term statistics
  private Statistics centroidMaxStats;  //maximum statistics
  private float centroidMax; //stores the maximum value
  private Hysteresis maxUpdate;
  
  //**** CONSTRUCTOR
  public Timbre(int bSize, float sRate)
  {
    
    buffSize=bSize;
    sampleRate=sRate; 
    
    FFTcoeffs=new float[bSize/2+1];
    
    spectralCentroidHz=0;
    
    //initialize statistics data
    centroidLongTerm=new Statistics(W);
    centroidShortTerm=new Statistics(21); //~0.5 sec   
    centroidMaxStats=new Statistics(7);  
    centroidMax=0;
    maxUpdate=new Hysteresis(43);
    
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
  
  public float getCentroid() { return spectralCentroidNormalized; } //instantaneous - normalized respect the theoretical maximum
  
  public float getCentroidAvg() { return centroidLongTerm.getAverage(); } //average - normalized respect the theoretical maximum
  
  public float getCentroidStdDev() { return centroidLongTerm.getStdDev(); } //std deviation - normalized respect the theoretical maximum
  
  public float getCentroidHz() { return spectralCentroidHz; } //instantaneous in Hz
  
  public float getCentroidAverageMax() { return centroidMaxStats.getAverage(); } //average maximum in Hz
  
  public float getCentroidDynamicRatio() { return centroidShortTerm.getAverage()/centroidMaxStats.getAverage(); } //dymaic ratio
  
  public float getCentroidShortTimeAvgHz() { return centroidShortTerm.getAverage(); }
  
  
  //**** CALC FEATURES METHOD (overrides the inherited method)
  
  public void calcFeatures()
  {
    calcSpectralCentroid();
    calcSpectralComplexity();
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
    for(int i=0;i<specSize;i++)
    {
      num+=(centerFreqHz(i)*FFTcoeffs[i]);
      denom+=FFTcoeffs[i];    
    }
    
    if(denom!=0){SC = num/denom;}
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
    
    if(maxUpdate.checkWindow(centroidMax,CENTROID_THEORETICAL_MAX,CENTROID_THEORETICAL_MAX))
    {
      centroidMax=0;
      centroidMaxStats.reset();
      maxUpdate.restart();
    }
        
    //map respect the theoretical maximum
    SC=map(SC,0,CENTROID_THEORETICAL_MAX,0,1);
    
    //accumulate for long term statistcs
    centroidLongTerm.accumulate(SC);
    
    //smoothing
    spectralCentroidNormalized=expSmooth(SC, spectralCentroidNormalized, 5);
  }
  
  private void calcSpectralComplexity()
  {
    
  }
   
  
  /**
   * Returns the center frequency on Hz of the idx-th bin in the spectrum
   */
  private float centerFreqHz(int idx)
  { 
     return (idx*sampleRate)/buffSize; 
  }
  
}