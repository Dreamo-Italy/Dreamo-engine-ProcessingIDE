import ddf.minim.analysis.*;

class Rhythm extends FeaturesExtractor {

  private FloatList longWindow;
  private float[] processed;
  
  public static final float DEFAULT_THRESHOLD = 8;
  
  public static final float DEFAULT_SENSITIVITY = 20;
  
  private float[] currentFFTmagnitudes;  
  private float[] priorFFTmagnitudes;
  private int FFTsize;
  private float dfMinus1, dfMinus2;
  private float threshold;
  private float sensitivity;
  private boolean percOnset;
  
  private float onsets;
  private float onsetRate;
  
  //temporary for minim onset implementation
  private BeatDetect beat;
  
  private int counter; //audio frames counter (passed by AudioProcessor object)
  private static final int FRAMES_NUMBER=43;
  
  private boolean process_ok;
  
  //default constructor
  public Rhythm (int bSize, float sRate)
  {
    buffSize=bSize;
    sampleRate=sRate;
    counter=0; 
    
    //energy onset detector
    longWindow = new FloatList(bSize*FRAMES_NUMBER);
    processed = new float[bSize*FRAMES_NUMBER];
    
    priorFFTmagnitudes=new float[bSize/2+1];
    currentFFTmagnitudes=new float[bSize/2+1];
    
    //percussive onset detector
    this.threshold=DEFAULT_THRESHOLD;
    this.sensitivity=DEFAULT_SENSITIVITY;
    
    percOnset=false;
    onsetRate=0;
    onsets=0;
    
    process_ok=false;
  }
 
  public void setCounter( int c)
  {
    counter=c;
  }
  
  public void setFFTCoeffs(float[] coeffs, int size)
  {
    FFTsize=size;
    currentFFTmagnitudes=coeffs.clone();
  }
 
 public void setThreshold(float th)
 {
   threshold=th;
 }
 
 public void setSensitivity(float sens)
 {
   sensitivity=sens;
 }
 
 public synchronized void calcFeatures()
 {        
   percussiveOnsetDetection();
   //energyOnsetDetection();  
 }
  
  private void percussiveOnsetDetection()
  {
    //debug
    //for(int i=100;i<120;i++){println(priorFFTmagnitudes[i]);}
    
    int binsOverThreshold=0;
    for(int i=0;i<FFTsize;i++)
    {
     if(priorFFTmagnitudes[i]>0)
     {
       float diff = 10*(float)Math.log10(currentFFTmagnitudes[i]/priorFFTmagnitudes[i]);
       if ( diff >= threshold) {binsOverThreshold++;}
     }
     priorFFTmagnitudes[i]=currentFFTmagnitudes[i];   
    }
    
    //println("BINS OVER TH: "+binsOverThreshold);
    
   //check if is onset 
   if(dfMinus2<dfMinus1 && dfMinus1 >= binsOverThreshold && dfMinus1 > ((100 - sensitivity) * buffSize) / 200)
   {
     percOnset=true;
     onsets++;
   }
   else{percOnset=false;}
   
   dfMinus2=dfMinus1;
   dfMinus1=binsOverThreshold;
   
  }
  
  public boolean isPercOnset()
  {
    return percOnset;
  }
  
  private float getOnsetRate()
  {
    if(counter>=FRAMES_NUMBER)
    {
      onsetRate=onsets;
      onsets=0;
      return onsetRate;
    }
    else return onsetRate;    
  }
  
  private void energyOnsetDetection()
  {
    updateLongWindow();
    
    //when counter is at the end
    if(counter>=FRAMES_NUMBER)
    {
      detectEnergyOnsets();     
    }
  }
  
  
  private void updateLongWindow()
  {
    //if the FloatList is full
    if(longWindow.size()>(buffSize*FRAMES_NUMBER))
    {
      //remove the oldest 1024 values from bottom of the list
      for(int i=0; i<1024;i++){longWindow.remove(i);}       
    }
    
    //put the last buffer at the top of the list with append(float[] values)
    longWindow.append(samples);
  
  }
  
  public synchronized void detectEnergyOnsets()
  {
    //process to extract peaks
    //see http://mziccard.me/2015/05/28/beats-detection-algorithms-1/
    processed=longWindow.values().clone();
    DSP.HWR(processed);
    processed=DSP.LowPassSP(processed,1000,sampleRate);
    //processed=DSP.times(processed,10);
    process_ok = true;
    
  }

  public synchronized float getLongWindowSamples(int idx)
  {
    //return longWindow.get(idx);
    return processed[idx];
  }  
  
  public int getLongWindowMaxSize()
  {
    return buffSize*FRAMES_NUMBER;
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