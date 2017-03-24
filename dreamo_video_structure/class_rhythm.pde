import ddf.minim.analysis.*;

class Rhythm extends FeaturesExtractor {

  private FloatList longWindow;
  private float[] processed;
     
  //temporary for minim onset implementation
  private BeatDetect beat;
  
  private int counter;
  private final int FRAMES_NUMBER=43;
  
  private boolean process_ok;
  
  //default constructor
  public Rhythm (int bSize, float sRate)
  {
    buffSize=bSize;
    sampleRate=sRate;
    beat = new BeatDetect();
    longWindow = new FloatList(bSize*FRAMES_NUMBER);
    //beat.setSensitivity(30); 
    counter=0;
    process_ok=false;
  }
 
  public void setCounter( int c)
  {
    counter=c;
  }
  
 
  public void calcFeatures()
  {
    
    //if the FloatList is full
    if(longWindow.size()>(buffSize*FRAMES_NUMBER))
    {
      //remove the oldest 1024 values from bottom of the list
      for(int i=0; i<1024;i++){longWindow.remove(i);}       
    }
    
    //put the last buffer at the top of the list with append(float[] values)
    longWindow.append(samples);
    
    //when counter is at the end
    if(counter>=FRAMES_NUMBER)
    {
      process();
      
    }
     
  }
  
  public void process()
  {
    //process to extract peaks
    //see http://mziccard.me/2015/05/28/beats-detection-algorithms-1/
    /*
    DSP.HWR(longWindow.values());
    processed=DSP.LowPassSP(longWindow.values(),1000,sampleRate);
    */
    process_ok = true;
    
  }

  public float getLongWindowSamples(int idx)
  {
    //return longWindow.get(idx);
    return processed[idx];
  }  
  
  public int getLongWindowSize()
  {
    //text("RHYTHM WINDOW SIZE: "+global_rhythm.getLongWindowSize(),200,200);
    return longWindow.size();
    
  }
  
  public boolean isProcessed()
  {
    return process_ok;
  }
  
  public boolean getOnset()
  {
   
    beat.detect(samples);
    return beat.isOnset();
  }
  

  
}