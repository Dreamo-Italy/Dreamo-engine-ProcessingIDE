//class Tone extends AudioProcessor {

//  private float[] samples;
//  private boolean init=false;

//  //default constructor
//  public Tone() 
//  {      
//    samples=new float[buffSize];
//    init=true; 
//  }
  
//  public void setSamples(float[] _samples){
//    if (isInitialized())
//    {
//      samples=_samples.clone();
//    }
//    else{println("TONE OBJECT NOT INITIALIZED");}
//  }
  
  
//  public float[] detectPitch() {
        
//    //temporary
//    return DSP.xcorr(samples,samples,samples.length);
    
//  }
  
  
//  private boolean isInitialized(){
//    return init;
//  }


//}