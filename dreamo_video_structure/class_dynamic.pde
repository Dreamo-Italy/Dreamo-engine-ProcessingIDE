class Dynamic extends FeaturesExtractor
{

  //features
  private float RMS;
  private float maxRMS;

  //keep track of ~3 seconds of music and average RMS values
  private final int AVG=129; // 43=~1s

  private float[] averages;
  private float RMSsum;
  private int aidx;
  


  //CONSTRUCTOR
  public Dynamic(int bSize, float sRate)
  {
    buffSize=bSize;
    sampleRate=sRate;
    maxRMS = 0.5;
    averages=new float[AVG];
    RMSsum=0;
    aidx=0;
  }


  //GET METHODS
  public float getRMS()
  {
   return RMS;
  }
  
  public float getAvgRMS()
  {
    return RMSsum/AVG;
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
      RMSsum-=averages[aidx]; //subtract last value
      averages[aidx]=level; //update the value
      RMSsum+=averages[aidx]; //update the total
      aidx++; //next position
      if(aidx>=AVG){aidx=0;} //if at the end go back
      
      //smoothing
      RMS=expSmooth(level,RMS,5);
      
  }
  


}