import ddf.minim.*;

class AudioFeatures {

 //********* PRIVATE MEMBERS ***********
 private Minim minim;
 private AudioInput in; 
 private float[] buffer;
 private boolean initialized = false;
 
 //********* PROTECTED MEMBERS ***********
 protected int buffSize;
 protected float sampleRate;
 //protected DSP dsp;
 
 //********* CONTRUCTORS ***********
 public AudioFeatures(){}
   /* //<>// //<>//
   * @param fileSystemHandler
   *        The Object that will be used for file operations.
   *        When using Processing, simply pass <strong>this</strong> to AudioFeatures constructor.
   */
 //TODO: monitoring audio input from Raspberry sound card
 //temporary: use pc input  
 public AudioFeatures(Object fileSystemHandler)
 {
   minim = new Minim(fileSystemHandler);
   in = minim.getLineIn();
   setBufferSize();
   setSampleRate();
   //in.enableMonitoring();
   bufferize();
   initialized=true;
   //samples=0; 
 }
 
 //********* PUBLIC METHODS ***********
  public void updateBuffer()
  {       
    if (isInitialized())
    { 
      buffer=in.mix.toArray();
    }
    else{println("AUDIO FEATURE OBJECT NOT INITIALIZED");} 
  }
  
  public float[] getSamples()
  {
  return buffer;
  }
  
  public void stop(){
    in.close();
    minim.stop();
  }
  
  
  //********* PRIVATE METHODS ***********
  private void bufferize()
  {
    buffer = new float[buffSize];    
    buffer=in.mix.toArray();
  }
  
  private boolean isInitialized(){return initialized;}  
  
  private void setBufferSize(){buffSize=in.bufferSize();}
  
  private void setSampleRate(){sampleRate=in.sampleRate();}
  
}