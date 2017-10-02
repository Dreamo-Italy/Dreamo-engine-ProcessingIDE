  import ddf.minim.analysis.*;

class AudioProcessor implements AudioListener
{
  private float[] left;
  private float[] right;
  private float[] mix;
 
  private float frameEnergy;
  
  private float[] FFTcoeffs;
  
  private float avgMagnitude;
  
  private float level;
    
  private FFT fft;
  
  private Dynamic dyn;
  private Timbre timb;
  private Rhythm rhy;
  
  private Table audioLog;
  private Table statusLog;
  private long bufferCount;
  
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
    
    bufferCount=0;
    avgMagnitude=0;
    level = 0;
    
    if ( bSize == 0 || sRate == 0) { println("ERROR: Impossible to initialize AudioProcessor"); }
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
    audioLog.addColumn("EBF_mean_on_1024");
    audioLog.addColumn("COBE_mean_on_1024"); 
    audioLog.addColumn("SkewnessD");
    audioLog.addColumn("SkewnessE");
    audioLog.addColumn("Roughness");
    audioLog.addColumn("Rhythm Strength");
    audioLog.addColumn("Rhythm Density");
    
    // Dopo aver aggiornato l'audio decisor aggiornare anche la tabella per lo STATUS LOG
    
    statusLog = new Table();   
    statusLog.addColumn("Buffer N.");
    statusLog.addColumn("RMS");
    statusLog.addColumn("Dyn Index");
    statusLog.addColumn("Spectral Centroid");
    statusLog.addColumn("Spectral Complexity");    
    statusLog.addColumn("Rhythm Strength");
    statusLog.addColumn("Rhythm Density"); 
      
  }
  
  //********* SYNCHRONIZED METHODS ***********
  public synchronized void samples(float[] samp)
  {
    //update samples
    left = samp;
    
    //calculate fourier transform
    calcFFT(samp);
    
    calcRMS(samp);
    
    //run features extractors
    extractFeatures(); 
    
    bufferCount++; //log buffer count number
  }
  
  public synchronized void samples(float[] sampL, float[] sampR)
  {
    
    left = sampL;
    right = sampR; 
    
    calcFrameEnergy();
    
    mix(); //check if is to slow
    
    //calculate fourier transform
    calcFFT(mix); 
    
    calcRMS(mix);
    
    //run features extractors
    extractFeatures();
    
    //log features
    bufferCount++;//log buffer count number
    if (bufferCount == Long.MAX_VALUE) { bufferCount = 0; }
    
    logFeatures();

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
  
  public long getBufferCount() {return bufferCount;}
  
  public float[] getLeft() { return left; }
  
  public float[] getRight(){ return right; }
    
  public float[] getMix() { return mix; }
  
  public float getFFTcoeff(int i) { return FFTcoeffs[i]; }
  
  public float getRMS() { return level; }
  
  public float getRMSdB() { return level; }
 
  public int getSpecSize() { return fft.specSize(); }
  
  public void saveLog()
  {   
    saveTable(audioLog, "data/FeaturesLog.csv");  
    saveTable(statusLog, "data/StatusLog.csv");
  }
   
  //********* PRIVATE METHODS ***********
  //synchrodized is necessary?
  
  private void calcFrameEnergy()
  {
    float energy=0;
    for(int i=0;i<left.length;i++)
    {
      energy += FastMath.pow(left[i],2) + FastMath.pow(right[i],2);
    }    
    frameEnergy=(float)energy;   
  }
  
  private void mix()
  {
    mix= DSP.plus(left,right); 
  }
 
  //COMPUTE FFT FOR EVERY FRAME
  private void calcFFT(final float[] samples)
  {
    fft.forward(samples); //compute FFT   
    avgMagnitude=0;
    
    for(int i = 0; i < fft.specSize(); i++)
    {
     FFTcoeffs[i] = fft.getBand(i);
     if(i <= fft.specSize() / 2) { avgMagnitude += fft.getBand(i); }
    }
    avgMagnitude = avgMagnitude / fft.specSize(); 
  }
  
  private void calcRMS(final float[] samples)
  {
   for (int i = 0; i < samples.length; i++) 
   {
    level += (samples[i] * samples[i]);
   }
   level /= samples.length;
   level = (float) FastMath.sqrt(level);
  }
  
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
      rhy.setBufferCount(bufferCount);
      rhy.calcFeatures();  
    }
    else { println("RHYTHM OBJECT HAS TO BE ADDED TO AUDIO PROCESSOR"); } 
  }
  
  private void runDyn()
  { 
    if(dyn!=null)
    {
      dyn.setSamples(mix);
      dyn.setRMS(level);
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
      timb.setRMS(level);
      timb.calcFeatures();
    }
    else{println("TIMBRE OBJECT HAS TO BE ADDED TO AUDIO PROCESSOR");}
  }
  
  private void logFeatures()
  {
    if(dyn.isSilence(-60) || !dyn.isSilence(-50))
    {
      //LOG FEATURES
      TableRow newRow = audioLog.addRow();        
      newRow.setLong("Buffer N.",bufferCount);
      newRow.setFloat("RMS",dyn.getRMS());
      newRow.setFloat("Dyn Index",dyn.getRMSStdDev());
      newRow.setFloat("Spectral Centroid",timb.getCentroidHz());
      newRow.setFloat("Spectral Complexity",timb.getComplexity());
      newRow.setFloat("ZCR",timb.getZeroCrossingRate());
      newRow.setFloat("EBF_mean_on_1024",timb.getEBFsamples());
      newRow.setFloat("COBE_mean_on_1024",timb.getCOBEsamples());
      newRow.setFloat("SkewnessD",timb.getSkewnessD());
      newRow.setFloat("SkewnessE",timb.getSkewnessE());
      newRow.setFloat("Roughness",timb.getRoughness());
      newRow.setFloat("Rhythm Strength",rhy.getRhythmStrength());
      newRow.setFloat("Rhythm Density",rhy.getRhythmDensity());
      
      // Dopo aver aggiornato l'audio decisor aggiornare anche la tabella per lo STATUS LOG
      //LOG STATUS 
      TableRow newRowS = statusLog.addRow();        
      newRowS.setLong("Buffer N.",bufferCount);
      newRowS.setInt("RMS",audio_decisor.getStatusVector()[0]);
      newRowS.setInt("Dyn Index",audio_decisor.getStatusVector()[1]);
      newRowS.setInt("Spectral Centroid",audio_decisor.getStatusVector()[2]);
      newRowS.setInt("Spectral Complexity",audio_decisor.getStatusVector()[3]);
      newRowS.setInt("Rhythm Strength",audio_decisor.getStatusVector()[4]);
      newRowS.setInt("Rhythm Density",audio_decisor.getStatusVector()[5]);     
    } 
  } 
}