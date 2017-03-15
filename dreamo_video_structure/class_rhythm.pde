//import ddf.minim.analysis.*;

//class Rhythm extends FeaturesExtractor {

//  private float[] samples;
//  private boolean init=false;
   
//  //temporary for minim onset implementation
//  private BeatDetect beat;
  
//  //default constructor
//  public Rhythm() {     
//  samples=new float[buffSize];
//  beat = new BeatDetect();
//  //beat.setSensitivity(30); 
//  init=true; 
//  }
  
//  public void setSamples(float[] _samples){
//    if (isInitialized())
//    {
//      samples=_samples.clone();
//    }
//    else{println("RHYTHM OBJECT NOT INITIALIZED");}
//  }
  
//  public boolean getOnset()
//  {
   
//    beat.detect(samples);
//    return beat.isOnset();
//  }
  
  
//  private boolean isInitialized(){
//    return init;
//  }
  
//}