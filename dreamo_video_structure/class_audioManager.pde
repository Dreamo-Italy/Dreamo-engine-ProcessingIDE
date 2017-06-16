import ddf.minim.*;

class AudioManager

{
 //********* PRIVATE MEMBERS ***********
 private Minim minim;
 private AudioInput in=null; 
 private boolean initialized = false;
  
 //********* CONTRUCTORS ***********
 public AudioManager(){}
 //<>// //<>// //<>// //<>//
 public AudioManager(Object fileSystemHandler)
 {
   minim = new Minim(fileSystemHandler);
   in = minim.getLineIn(Minim.STEREO,1024,44100); //stereo stream, 1024 samples of buffer size
   
   if(in!=null) {initialized=true;}
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
    if (isInitialized()) { in.enableMonitoring(); }
    else{ println("AUDIO FEATURE OBJECT NOT INITIALIZED"); }   
 }
 
 public void disableMonitoring()
 {
    if (isInitialized()) { in.disableMonitoring(); }
    else { println("AUDIO FEATURE OBJECT NOT INITIALIZED"); }   
 }  
 
 public void stop()
 {
    in.close();
    minim.stop();
  }
  
 //********* GETTERS ***********
 public float[] getSamples()
 {
   return in.mix.toArray();
 }   
  
 public int getBufferSize()
 {
   if(isInitialized()){return in.bufferSize();}
   else return 0;
 }
  
 public float getSampleRate()
 {
   if(isInitialized()){return in.sampleRate();}
   else return 0;
 }
 
 public boolean isInitialized()
 {
   return initialized;
 } 
 
}