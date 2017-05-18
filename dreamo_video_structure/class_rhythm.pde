import ddf.minim.analysis.*;

class Rhythm extends FeaturesExtractor {

  private float  rhythmDensity;
  private float rhythmStrength;
  
  //ENERGY ONSET DETECTION VARIABLES
  private float frameEnergy;
  private Statistics energyStats;
  private boolean energyOnset;
  public int energyOnsets;
  public float energyOnsetStrength;
  
  //PERCUSSIVE ONSET DETECTION VARIABLES
  public static final float DEFAULT_THRESHOLD = 13;
  public static final float DEFAULT_SENSITIVITY = 80;
  private float[] currentFFTmagnitudes;  
  private float[] priorFFTmagnitudes;
  private int FFTsize;
  private float dfMinus1, dfMinus2;
  private float threshold;
  private float sensitivity;
  private boolean percOnset;
  private int percOnsets;
  private float percOnsetRate;
  
  // LOW PASS ONSET DETECTION VARIABLES
  private FloatList longWindow;
  private float[] processed;  

  private float percussivity;
  private Statistics percussivityStats;
  
  //RHYTM DENSITY AND RHYTHM STRENGTH 
  private int counter; //audio frames counter
  private static final int WINDOW_LENGTH=217; //window length in buffers (43 = 1 second)
  private float WINDOW_TIME; //window length in seconds
  
  private boolean process_ok;
  
  //default constructor
  public Rhythm (int bSize, float sRate)
  {
    buffSize=bSize;
    sampleRate=sRate;
    
    WINDOW_TIME=ceil(WINDOW_LENGTH*buffSize/sampleRate);
    
    counter=0; 
    
    frameEnergy=0;
    energyStats=new Statistics(43);
    
    //energy onset detector
    longWindow = new FloatList(bSize*WINDOW_LENGTH);
    processed = new float[bSize*WINDOW_LENGTH];
    
    
    priorFFTmagnitudes=new float[bSize/2+1];
    currentFFTmagnitudes=new float[bSize/2+1];
    
    //percussive onset detector
    this.threshold=DEFAULT_THRESHOLD;
    this.sensitivity=DEFAULT_SENSITIVITY;
    percOnset=false;
    percOnsetRate=0;
    percOnsets=0;
    
    process_ok=false;
    
    percussivityStats=new Statistics(21); 
    
  }
  
  //**** SET METHODS ****
  public void setFFTCoeffs(float[] coeffs, int size)
  {
    FFTsize=size;
    currentFFTmagnitudes=coeffs.clone();
  }
  
 public void setCounter( int c) { counter=c; }
  
 public void setThreshold(float th) { threshold=th; }
 
 public void setSensitivity(float sens) { sensitivity=sens; }
 
 public void setFrameEnergy(float energy)
 {
   frameEnergy=energy;
   energyStats.accumulate(frameEnergy);    
 }
 
 //**** GET METHODS ****
 public float getRhythmStrength() { return rhythmStrength; }
  
 public float getRhythmDensity() { return rhythmDensity; }
 
 public float getPercussivity() { return percussivity; }
  
 public boolean isPercOnset() { return percOnset; }
  
 public boolean isEnergyOnset() { return energyOnset; }
   
 
 //**** FEATURES CALC METHOD ****
  public synchronized void calcFeatures()
  { 
   
   energyOnsetDetection();
   //percussiveOnsetDetection();
   //lowPassEnergyOnsetDetection();
   
   if(counter>WINDOW_LENGTH) { counter=0; }
   counter++;
   
 }
  
 //**** PRIVATE METHODS **** 
 private void calcRhythmFeatures()
 {
    rhythmDensity=(float)energyOnsets/WINDOW_TIME;
    if(energyOnsets==0) rhythmStrength=0;
    else rhythmStrength=(float)energyOnsetStrength/energyOnsets;
 }
  
 
 //ENERGY ONSETS DETECTION ALGORITHM
 private void energyOnsetDetection()
 {    
    if(counter>WINDOW_LENGTH)
    { 
      calcRhythmFeatures();
      energyOnsetStrength=0;
      energyOnsets=0;
    }
    
    float C=-0.0000015*energyStats.getVariance()+2;
    //float C=-0.0000015*energyStats.getVariance()+1.5142857; //zic version
    //float C=(-0.0025714*energyStats.getVariance())+1.5142857; //original paper    
    //if energy in the current frame is bigger than C*avg(E) we detect an onset
    //avg(E) and C are computed on a window that considers the 43 previous frames
    float strength=0;
    if(frameEnergy > 0 && frameEnergy>energyStats.getAverage()*C)
    {
      energyOnsets++;
      strength=frameEnergy-energyStats.getAverage()*C;
      energyOnset=true;
    }
    
    else energyOnset=false;
    
    energyOnsetStrength+=strength;


  }
   
  //PERCUSSIVE ONSETS DETECTION ALGORITHM
  private void percussiveOnsetDetection()
  {
   
    if(counter>=WINDOW_LENGTH)
    { 
      if(percOnsets==0){percussivity=0;} //if no onsets for 5 seconds, assume there is no percussion
      calcRhythmFeatures();;
    }  
    
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
    
    //percussivity=(float)binsOverThreshold;
    
    if(binsOverThreshold>((100-sensitivity)*FFTsize)/100) //if onset
    //if(dfMinus2<dfMinus1 && dfMinus1 >= binsOverThreshold && dfMinus1 > ((100 - sensitivity) * buffSize) / 200)
    {
      
      percOnsets++;
     
      percussivity=(float)binsOverThreshold/FFTsize;
      percussivityStats.accumulate(percussivity);
      
      percOnset=true;
    
    }    
    //dfMinus2=dfMinus1;
    //dfMinus1=binsOverThreshold;  
  
    else{percOnset=false;}

  }
  
  
  
  /*
  *
  *  LOW PASS ENERGY ONSET DETECTION
  *  (TO IMPLEMENT)
  *
  *
  
  private void lowPassEnergyOnsetDetection()
  {
    
    updateLongWindow();    
    //when counter is at the end
    if(counter>=WINDOW_LENGTH)
    {
      detectEnergyOnsets();     
    }
  }
  
  
  private void updateLongWindow()
  {
    //if the FloatList is full
    if(longWindow.size()>(buffSize*WINDOW_LENGTH))
    {
      //remove the oldest 1024 values from bottom of the list
      for(int i=0; i<1024;i++){longWindow.remove(i);}       
    }
    
    //put the last buffer at the top of the list with append(float[] values)
    longWindow.append(samples);  
  }
     
  public void detectLowPassEnergyOnsets()
  {  
    //process to extract peaks
    //see http://mziccard.me/2015/05/28/beats-detection-algorithms-1/
    processed=longWindow.values().clone();
    DSP.HWR(processed);
    processed=DSP.LowPassSP(processed,1000,sampleRate);
    //processed=DSP.times(processed,10);
    process_ok = true;
    
  }
  
  //PUBLIC METHODS
  //PUBLIC GETTER TO VISUALIZE SAMPLES IN THE LONG WINDOW
  public synchronized float getLongWindowSamples(int idx)
  {
    //return longWindow.get(idx);
    return processed[idx];
  }  
  
  public int getLongWindowMaxSize()
  {
    return buffSize*WINDOW_LENGTH;
  }
  
  public boolean isProcessed()
  {
    return process_ok;
  }
  
  
  */


  

  

  
}