class Dynamic extends FeaturesExtractor
{

  //features
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
    
  public float getAvgRMS()
  {
    return RMSstats.getAverage();
  }
  
  //OVERRIDE METHODS
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
  


}