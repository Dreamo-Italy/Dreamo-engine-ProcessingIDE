class Dynamic extends AudioFeatures {

  private float[] samples;
  private boolean init=false;
 
  
  //default constructor
  public Dynamic() {      
  samples=new float[buffSize]; 
  init=true; 
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
    return level;        
  }  
  
  
  private boolean isInitialized(){
    return init;
  }



}