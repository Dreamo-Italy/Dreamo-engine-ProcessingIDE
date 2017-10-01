 class Dynamic extends FeaturesExtractor 
 {
   
  public static final double DEFAULT_SILENCE_THRESHOLD = -60.0; //db

  private float RMS;
  private float level;

  //keep track of ~3 seconds of music and average RMS values
  private final int W = 129; // 43=~1s

  private Statistics RMSstats;
  

  //CONSTRUCTOR
  public Dynamic(int bSize, float sRate) 
  {
   buffSize = bSize;
   sampleRate = sRate;
   RMSstats = new Statistics(W);
  }
 
  //OVERRIDE CALC FEATURES METHOD
  public void calcFeatures() 
  {
   calcRMS();
  }

 //RMS standard computation
 
  private void calcRMS() 
  {
   RMSstats.accumulate(level);
   RMS = expSmooth(level, RMS, 5);
  }

  private float soundPressureLevel(final float RMS) { return linearToDecibel(RMS); }
  
  //SET METHOD
  
  public void setRMS(float RMSvalue) {level = RMSvalue ;}  
  
  //GET METHODS
  public float getRMS() { return RMS; } 

  public float getRMSAvg() { return RMSstats.getAverage(); }
  
  public float getRMSStdDev() { return RMSstats.getStdDev();}

  public float getRMSVariance() {return RMSstats.getVariance(); }
  
  public float getSPL() {return soundPressureLevel(RMS);}

  public boolean isSilence(final float silenceThreshold) { return soundPressureLevel(RMS) < silenceThreshold; }

  public boolean isSilence() { return soundPressureLevel(RMS) < DEFAULT_SILENCE_THRESHOLD; }
 }