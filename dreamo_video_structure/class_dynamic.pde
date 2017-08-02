 class Dynamic extends FeaturesExtractor
{

  public static final double DEFAULT_SILENCE_THRESHOLD = -60.0;//db
  
  private float RMS;

  //keep track of ~3 seconds of music and average RMS values
  private final int W=129; // 43=~1s
  
  private Statistics RMSstats;
  
  //CONSTRUCTOR
  public Dynamic(int bSize, float sRate)
  {
    buffSize=bSize;
    sampleRate=sRate;
    
    RMSstats=new Statistics(W);
    
  }


  //GET METHODS
  public float getRMS() { return RMS; }
    
  public float getRMSAvg() { return RMSstats.getAverage(); }
  
  public float getRMSStdDev() { return RMSstats.getStdDev(); }
  
  public float getRMSVariance() { return RMSstats.getVariance(); }
  
  public float getSPL() { return soundPressureLevel(RMS); }
 
  public boolean isSilence(final float silenceThreshold) { return soundPressureLevel(RMS) < silenceThreshold; }
  
  public boolean isSilence() { return soundPressureLevel(RMS) < DEFAULT_SILENCE_THRESHOLD; }
  
 
  //OVERRIDE CALC FEATURES METHOD
  public void calcFeatures()
  {
    calcRMS();
  }
  
  //**** PRIVATE METHODS
  /**
   * RMS standard comptation
   */
  private void calcRMS()
  {
    
      float level=0;
      for(int i=0;i<samples.length;i++)
      {
        level += (samples[i]*samples[i]);
       }       
      
      level /= samples.length;
      level = (float) Math.sqrt(level); 
       
      //average      
      RMSstats.accumulate(level);
      
      //smoothing
      RMS=expSmooth(level,RMS,5);
      
  }
  
  
  private float soundPressureLevel(final float RMS) { return linearToDecibel(RMS); }
  

}