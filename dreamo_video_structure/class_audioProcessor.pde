import ddf.minim.analysis.*;

class AudioProcessor implements AudioListener
{
  private float[] left;
  private float[] right;
  private float[] mix;
 
  private float frameEnergy;
  
  private float[] FFTcoeffs;
  
  
  private int frameCounter;
  private final int FRAMES_NUMBER=43;
  private float avgMagnitude;
    
  private FFT fft;
  
  private Dynamic dyn;
  private Timbre timb;
  private Rhythm rhy;
  
  private Table audioLog;
  private int bufferCount;
  
  
  //********* CONSTRUCTOR ***********
  AudioProcessor(int bSize, float sRate)
  {
    
    left = null; 
    right = null;
    
    frameEnergy=0;
    
    dyn=null;
    timb=null;
    rhy=null;
    
    //log=false;    
    frameCounter=0;
    bufferCount=0;
    avgMagnitude=0;
    
    if ( bSize == 0 || sRate == 0) {println("ERROR: Impossible to initialize AudioProcessor");}
    
    else
    { 
      
      fft = new FFT(bSize,sRate);
      fft.noAverages();
      FFTcoeffs = new float[fft.specSize()];
      
      //CONSIDER implementing logarithmic spectrum. 
      //the calculation of the spectroid won't be in Hz -> check it!
      //see http://code.compartmental.net/minim/fft_method_logaverages.html
      //EXAMPLE: //fft.logAverages(  86, 3 );
      
    }
    
    audioLog = new Table();
    
    audioLog.addColumn("Buffer N.");
    audioLog.addColumn("RMS");
    audioLog.addColumn("Dyn Index");
    audioLog.addColumn("Spectral Centroid");
    audioLog.addColumn("Spectral Complexity");
    audioLog.addColumn("ZCR"); 
    audioLog.addColumn("Rhythm Strength");
    audioLog.addColumn("Rhythm Density");
    
  }
  
   
  //********* SYNCHRONIZED METHODS ***********
  public synchronized void samples(float[] samp)
  {
    //update samples
    left = samp;
    
    //calculate fourier transform
    calcFFT(samp);
    
    //run features extractors
    extractFeatures(); 
    
    //frame counter
    frameCounter++;
    if(frameCounter>FRAMES_NUMBER){frameCounter=0;}
    
  }
  
  public synchronized void samples(float[] sampL, float[] sampR)
  {
    
    left = sampL;
    right = sampR; 
    
    calcFrameEnergy();
    
    mix(); //check if mix is to slow
    
    //calculate fourier transform
    calcFFT(mix);  
    
    //run features extractors
    extractFeatures();
    
    //log features
    bufferCount++; //log buffer count number
    logFeatures();
    
    //frame counter
    frameCounter++;
    if(frameCounter>FRAMES_NUMBER){frameCounter=0;}
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
  
  public void addRhythm(Rhythm r)
  {
    rhy=r;
    rhy.setInitialized();
  }
  
  //********* GETTERS ***********
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
  
  public void saveLog()
  {   
    saveTable(audioLog, "data/audioFeaturesLog.csv");    
  }
   
  //********* PRIVATE METHODS ***********
  //synchrodized is necessary?
  
  private void calcFrameEnergy()
  {
    float energy=0;
    for(int i=0;i<left.length;i++)
    {
      energy+=Math.pow(left[i],2)+Math.pow(right[i],2);
    }    
    frameEnergy=(float)energy;   
  }
  
  
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
    return fft.specSize();
  }
  
  //COMPUTE FFT FOR EVERY FRAME
  private void calcFFT(final float[] samples)
  {
    
    fft.forward(samples); //compute FFT   
    avgMagnitude=0;
      
    for(int i = 0; i < fft.specSize(); i++)
    {
     FFTcoeffs[i]=fft.getBand(i);
     if(i<=fft.specSize()/2) {avgMagnitude+=fft.getBand(i);}
    }
    avgMagnitude=avgMagnitude/fft.specSize();
     
  }
  
  //TODO calc autocorr is necessary?
  
  private synchronized void extractFeatures()
  {
    runRhythm();
    runDyn();
    runTimbre(); 
  }
    
  private void runRhythm()
  {
    if(rhy!=null){
      rhy.setSamples(mix);
      rhy.setFFTCoeffs(FFTcoeffs,fft.specSize());
      rhy.setFrameEnergy(frameEnergy);
      rhy.calcFeatures();
    }
    else{println("RHYTHM OBJECT HAS TO BE ADDED TO AUDIO PROCESSOR");}
    
  }
  
  private void runDyn()
  { 
    if(dyn!=null)
    {
      dyn.setSamples(mix);
      dyn.calcFeatures();
    }
    else{println("DYN OBJECT HAS TO BE ADDED TO AUDIO PROCESSOR");}
  }
  
  private void runTimbre()
  { 
    if(timb!=null)
    {   
      timb.setFFTCoeffs(FFTcoeffs,fft.specSize());
      timb.setAvgMagnitude(avgMagnitude);
      timb.setSamples(mix);     
      timb.calcFeatures();
    }
    else{println("TIMBRE OBJECT HAS TO BE ADDED TO AUDIO PROCESSOR");}
  }
  
  
  private void logFeatures()
  {
 
    TableRow newRow = audioLog.addRow();        
    newRow.setInt("Buffer N.",bufferCount);
    newRow.setFloat("RMS",dyn.getRMS());
    newRow.setFloat("Dyn Index",dyn.getDynamicityIndex());
    newRow.setFloat("Spectral Centroid",timb.getCentroidHz());
    newRow.setFloat("Spectral Complexity",timb.getComplexity());
    newRow.setFloat("ZCR",timb.getZeroCrossingRate());
    newRow.setFloat("Rhythm Strength",rhy.getRhythmStrength());
    newRow.setFloat("Rhythm Density",rhy.getRhythmDensity());
      
  }
    
  
}