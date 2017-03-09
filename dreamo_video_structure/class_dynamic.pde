class Dynamic extends FeaturesExtractor
{

  //features
  private float RMS;
  
  //averaging window
  private final int N=5;
  //averaging constant
  private float tiny;
  private float maxRMS;

  //keep track of ~1 second of music and average RMS values
  //buffer=1024 -> AVG=44 || buffer=2048 -> AVG=22
  private final int AVG=22;
  private float[] averages;
  private float RMSsum;
  private int aidx;

  private float s_level;
  
  
  //CONSTRUCTOR
  public Dynamic(int bSize, float sRate) 
  {
    buffSize=bSize;
    sampleRate=sRate;
    maxRMS = 0.5;
    tiny=1f-(1f/N);
    s_level=0;
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
      s_level=tiny*s_level+(1-tiny)*level;
      RMS=s_level;
      //TODO: try with RMS=expSmooth(level,RMS,5);
      }
  


}