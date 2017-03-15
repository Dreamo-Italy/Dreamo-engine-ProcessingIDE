import ddf.minim.analysis.*;

class AudioProcessor implements AudioListener
{
  private float[] left;
  private float[] right;
  private float[] mix;
 
  private float[] FFTcoeffs;
 
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
    
    //bufferSize=bSize;
    //sampleRate=sRate;
    
    fft = new FFT(bSize,sRate);
    fft.noAverages();
    //TODO: implement logarithmic spectrum. 
    //the calculation of the spectroid won't be in Hz -> check it!
    //see http://code.compartmental.net/minim/fft_method_logaverages.html
    //EXAMPLE: fft.logAverages( 5, 1 ); - 13 band
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
  

  
  //FEATURES CALC METHODS
  //FFT
  private void calcFFT(final float[] samples)
  {
    fft.forward(samples);
    FFTcoeffs = new float[fft.specSize()];
    for(int i = 0; i < fft.specSize(); i++)
    {
      FFTcoeffs[i]=fft.getBand(i);
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
      timb.setSpecSize(fft.specSize());
      timb.setFFTCoeffs(FFTcoeffs);     
    }
    else{println("TIMBRE OBJECT HAS TO BE ADDED TO AUDIO PROCESSOR");}
  }
  
  
}