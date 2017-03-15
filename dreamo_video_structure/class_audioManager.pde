import ddf.minim.*;

class AudioManager

{
 //********* PRIVATE MEMBERS ***********
 private Minim minim;
 private AudioInput in=null; 
 private float[] buffer;
 private boolean initialized = false;
  
 //********* CONTRUCTORS ***********
 public AudioManager(){}
   /* //<>// //<>// //<>//
   * @param fileSystemHandler
   *        The Object that will be used for file operations.
   *        When using Processing, simply pass <strong>this</strong> to AudioFeatures constructor.
   */
 //TODO: monitoring audio input from Raspberry sound card
 //temporary: use pc input  
 public AudioManager(Object fileSystemHandler)
 {
   minim = new Minim(fileSystemHandler);
   in = minim.getLineIn(Minim.STEREO,1024,44100); //stereo stream, 2048 samples of buffer size
   //in.enableMonitoring();
   //bufferize();
   
   if(in!=null)
   {
   initialized=true;
   }
   else {println("AUDIO INPUT NOT AVAILABLE");}
   
 }

 //********* PUBLIC METHODS ***********
 public void addListener(AudioListener l)
 { 
   if (isInitialized())
    { 
       in.addListener(l);
    }
    else{println("AUDIO FEATURE OBJECT NOT INITIALIZED");} 
 }
 
 public void enableMonitoring()
 {
    if (isInitialized())
    { 
      in.enableMonitoring();
    }
    else{println("AUDIO FEATURE OBJECT NOT INITIALIZED");}   
 }
  
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
  
  private boolean isInitialized()
  {
    return initialized;
  }    
  
  private int getBufferSize()
  {
    if(isInitialized()){return in.bufferSize();}
    else return 0;
  }
  
  private float getSampleRate()
  {
    if(isInitialized()){return in.sampleRate();}
    else return 0;
  }
  
}
