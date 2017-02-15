class Dynamic extends AudioFeatures {

  private float[] samples;
  private boolean init=false;
  //features
  private float RMS;
  
  
  //averaging window
  private final int N=5;
  //averaging constant
  private float tiny;
  
  //keep track of 0.25 seconds of music and average RMS values
  private final int AVG=11025;
  private float[] averages;
  private float RMSsum;
  private int aidx;
  
  private float s_level;
  //default constructor
  public Dynamic() {      
  samples=new float[buffSize]; 
  init=true;
  tiny=1f-(1f/N);
  s_level=0;
  averages=new float[AVG];
  RMSsum=0;
  aidx=0;
  }
  
  public void setSamples(float[] _samples){
    if (isInitialized())
    {
      samples=_samples.clone();
      calcFeatures();
    }
    else{println("DYNAMIC OBJECT NOT INITIALIZED");}
  }
  
  public void calcFeatures()
  {
    calcRMS();
  }
  
  public float getRMS()
  {
   return RMS; 
  }
  
  public void calcRMS()
  {    
    float level=0;
    for(int i=0;i<samples.length;i++)
     {
      level += (samples[i]*samples[i]);    
     }   
    level /= samples.length;
    level = (float) Math.sqrt(level);
    //normalize level in 0-1 range
    level=map(level,0,0.5,0,1);
    
    //average
    RMSsum-=averages[aidx]; //subtract last value
    averages[aidx]=level; //update the value
    RMSsum+=averages[aidx]; //update the total
    aidx++; //next position
    if(aidx>=AVG){aidx=0;} //if at the end go back
    
    //smoothing
    s_level=tiny*s_level+(1-tiny)*level;
    RMS= s_level;        
  }  
  
  public float getAvgRMS()
  {
    return RMSsum/AVG;
  }
  
  private boolean isInitialized(){
    return init;
  }



}