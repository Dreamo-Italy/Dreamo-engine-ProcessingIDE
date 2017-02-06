class Dynamic extends AudioFeatures {

  private float[] samples;
  private boolean init=false;
  private float maxRMS;
 
  
  //default constructor
  public Dynamic() {      
  samples=new float[buffSize]; 
  init=true; 
  maxRMS = 0.5;
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
    
    if (level > maxRMS) maxRMS = level;
    
    //normalize level in 0-1 range
    level=map(level,0,maxRMS,0,1);
    
    return level;        
  }  
  
  
  private boolean isInitialized(){
    return init;
  }



}