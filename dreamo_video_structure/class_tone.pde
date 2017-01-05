class Tone extends AudioFeatures {

  private float[] samples;
  private boolean init=false;
  private DSP dsp;

  //default constructor
  public Tone() {      
  samples=new float[buffSize];
  dsp = new DSP();
  init=true; 
  }
  
  public void setSamples(float[] _samples){
    if (isInitialized())
    {
      samples=_samples.clone();
    }
    else{println("TONE OBJECT NOT INITIALIZED");}
  }
  
  
  public float[] detectPitch() {
        
    //temporary
    return dsp.xcorr(samples,samples,samples.length);
    
  }
  
  
  private boolean isInitialized(){
    return init;
  }


}