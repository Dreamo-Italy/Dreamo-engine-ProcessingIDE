import ddf.minim.analysis.*;

class AudioProcessor implements AudioListener
{
  private float[] left;
  private float[] right;
  private float[] mix;
 
  private float[] FFTcoeffs;
  
  private boolean log;
 
  //private int bufferSize;
  //private float sampleRate;
  
  private FFT fft;
  
  private Dynamic dyn;
  private Timbre timb;
  
  //********* CONSTRUCTOR ***********
  AudioProcessor(int bSize, float sRate)
  {
    left = null; 
    right = null;
    
    if ( bSize == 0 || sRate == 0)
        println("ERROR: Impossible to initialize AudioProcessor");
    else
    {
    //bufferSize=bSize;
    //sampleRate=sRate;
    log=false;
    
    fft = new FFT(bSize,sRate);
    
    if(!log) {fft.noAverages(); }   
    
    //TODO: implement logarithmic spectrum. 
    //the calculation of the spectroid won't be in Hz -> check it!
    //see http://code.compartmental.net/minim/fft_method_logaverages.html
    //EXAMPLE: 
    else {fft.logAverages(  86, 3 );} //- 13 band
    }
  }
  
   
  //********* SYNCHRONIZED METHODS ***********
  public synchronized void samples(float[] samp)
  {
    left = samp;
    
    calcFFT(samp);
    runDyn();
    runTimbre();
    //process features
  }
  
  public synchronized void samples(float[] sampL, float[] sampR)
  {
    left = sampL;
    right = sampR;
 
    //process features (FFT, autocorr...)
    //this.mix();
    calcFFT(sampL);  
    //run extractors
    runDyn();
    runTimbre();
    
  }
  
  //********* PUBLIC METHODS ***********
  public void addDyn(Dynamic d)
  {
    dyn=d; 
    dyn.setInitialized();
  }
  
  public void addTimbre(Timbre t)
  {
    timb=t;
    timb.setInitialized();
  }
  
  //get methods
  public float[] getLeft()
  {
    return left;
  }
  
  public float[] getRight()
  {
    return right;
  }
  
  public float[] getMix()
  {
    return mix;
  }
  
  //********* PRIVATE METHODS ***********
  //synchrodized is necessary?
  private void mix()
  {
    mix=DSP.plus(left,right); 
  }
  
  public float getFFTcoeff(int i)
  {
    return FFTcoeffs[i];
  }
  
  public int getSpecSize()
  {
    if(!log){return fft.specSize();}
    else{return fft.avgSize();}
  }
  
  //FEATURES CALC METHODS
  //FFT
  private void calcFFT(final float[] samples)
  {
    fft.forward(samples);
    if(!log){
      FFTcoeffs = new float[fft.specSize()];
      for(int i = 0; i < fft.specSize(); i++)
       {
          FFTcoeffs[i]=fft.getBand(i);
       }
    }
    
    else
    {
      FFTcoeffs = new float[fft.avgSize()];
      for(int i = 0; i < fft.avgSize(); i++)
       {
          FFTcoeffs[i]=fft.getAvg(i);
       }
    }   
  }
   
  //autocorr
  //zerocrossing rate?
    
  private void runDyn()
  { 
    if(dyn.isInitialized()){dyn.setSamples(left);}
    else{println("DYN OBJECT HAS TO BE ADDED TO AUDIO PROCESSOR");}
  }
  
  private void runTimbre()
  { 
    if(timb.isInitialized())
    {
      if(!log){timb.setSpecSize(fft.specSize());}
      else{timb.setSpecSize(fft.avgSize());}
      timb.setFFTCoeffs(FFTcoeffs);
    }
    else{println("TIMBRE OBJECT HAS TO BE ADDED TO AUDIO PROCESSOR");}
  }
  
  
}