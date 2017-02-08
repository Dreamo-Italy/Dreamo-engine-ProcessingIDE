class Dynamic extends AudioFeatures {

  private float[] samples;
  private boolean init=false;
  //averaging window
  private int N=2;
  //averaging constant
  private float tiny;
  
  private float s_level;
  //default constructor
  public Dynamic() {      
  samples=new float[buffSize]; 
  init=true;
  tiny=1f-(1f/N);
  s_level=0;
  }
  
  public void setSamples(float[] _samples){
    if (isInitialized())
    {
      samples=_samples.clone();
    }
    else{println("DYNAMIC OBJECT NOT INITIALIZED");}
  }
  
  
  public float getRMS(){ 
     
    float level=0;
    
    for(int i=0;i<samples.length;i++){
      level += (samples[i]*samples[i]);    
      }   
    level /= samples.length;
    level = (float) Math.sqrt(level);
    //normalize level in 0-1 range
    level=map(level,0,0.5,0,1);
    
    //smoothing
    s_level=tiny*s_level+(1-tiny)*level;
    return s_level;        
  }  
  
  
  private boolean isInitialized(){
    return init;
  }



}