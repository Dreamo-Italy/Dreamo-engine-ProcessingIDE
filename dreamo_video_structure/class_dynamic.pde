class Dynamic extends FeaturesExtractor
{

  public static final double DEFAULT_SILENCE_THRESHOLD = -60.0;//db
  
  private float RMS;
  private float maxRMS;

  //keep track of ~3 seconds of music and average RMS values
  private final int W=129; // 43=~1s
  
  private Statistics RMSstats;
  
  //CONSTRUCTOR
  public Dynamic(int bSize, float sRate)
  {
    buffSize=bSize;
    sampleRate=sRate;
    maxRMS = 0.5;
    RMSstats=new Statistics(W);

  }


  //GET METHODS
  public float getRMS()
  {
   return RMS;
  }
    
  public float getRMSAvg()
  {
    return RMSstats.getAverage();
  }
  
  public float getRMSStdDev()
  {
    return RMSstats.getStdDev();
  }
  
  public float getRMSVariance()
  {
    return RMSstats.getVariance();
  }
  
  public float getSPL()
  {
    return soundPressureLevel(RMS);
  }
  
  //OVERRIDE CALC FEATURES METHOD
  public void calcFeatures()
  {
    calcRMS();
  }



  //CALC METHODS
  public void calcRMS()
  {
      float level=0;
      for(int i=0;i<samples.length;i++)
      {
        level += (samples[i]*samples[i]);
       }       
      
      level /= samples.length;
      level = (float) Math.sqrt(level);

      if (level > maxRMS) maxRMS = level;

      //normalize level in 0-1 range
      level=map(level,0,maxRMS,0,1);
      
      //average      
      RMSstats.accumulate(level);
      
      //smoothing
      RMS=expSmooth(level,RMS,5);
      
  }
  
  public boolean isSilence(final float silenceThreshold) 
  {
    return soundPressureLevel(RMS) < silenceThreshold;
  }
  
  public boolean isSilence() 
  {
    return soundPressureLevel(RMS) < DEFAULT_SILENCE_THRESHOLD;
  }

  /******** PRIVATE METHODS ********/
  private float soundPressureLevel(final float RMS)
  {
    return linearToDecibel(RMS);
  }
  


}