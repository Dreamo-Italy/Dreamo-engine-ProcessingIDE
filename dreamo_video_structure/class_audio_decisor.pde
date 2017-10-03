class AudioDecisor 
{
 private Dynamic dynamic;
 private Rhythm rhythm;
 private Timbre timbre;

 private int endCheck;
 private int changesNumber;
 private boolean checking;

 //**** COLLECT STATS ON FEATURES ****
 //DYNAMIC FEATURES
 private Statistics RMS;
 private Statistics DynIndex;

 //TIMBRIC FEATURES
 private Statistics specCentroid;
 private Statistics specComplexity;
 //private Statistics ZCR;
 
 private Statistics COBE;  //COBE
 private Statistics EBF;   //EBF
 private Statistics SkewnessD; //SkewD
 private Statistics SkewnessE; //SkewE
 private Statistics Roughness; //Rough

 //RHYTHMIC FEATURES
 private Statistics rhythmStr;
 private Statistics rhythmDens;

 //**** HYSTERESIS CONTROLS ****-
 private Hysteresis RMSLowerBound;
 private Hysteresis RMSUpperBound;

 private Hysteresis DynIndexLowerBound;
 private Hysteresis DynIndexUpperBound;

 private Hysteresis specCentroidLowerBound;
 private Hysteresis specCentroidUpperBound;

 private Hysteresis specComplexityLowerBound;
 private Hysteresis specComplexityUpperBound;
 
 /*private Hysteresis COBELowerBound; //COBE
 private Hysteresis COBEUpperBound; //COBE
 
 private Hysteresis EBFLowerBound; //EBF
 private Hysteresis EBFUpperBound; //EBF
 
 private Hysteresis SkewnessDLowerBound; //SkewD
 private Hysteresis SkewnessDUpperBound; //SkewD
 
 private Hysteresis SkewnessELowerBound; //SkewE
 private Hysteresis SkewnessEUpperBound; //SkewE
 
 private Hysteresis RoughnessLowerBound; //Rough
 private Hysteresis RoughnessUpperBound; //Rough */
 
 //private Hysteresis ZCRLowerBound;
 //private Hysteresis ZCRUpperBound;

 private Hysteresis rhythmStrLowerBound;
 private Hysteresis rhythmStrUpperBound;

 private Hysteresis rhythmDensLowerBound;
 private Hysteresis rhythmDensUpperBound;

 //**** STATUS ****
 private int RMSStatus;
 private int DynIndexStatus;
 private int centroidStatus;
 private int complexityStatus; 
 /*private int COBEStatus; //COBE
 private int EBFStatus;  //EBF
 private int SkewnessDStatus; //SkewD
 private int SkewnessEStatus; //SkewE
 private int RoughnessStatus; //Rough*/
 
 //private int ZCRStatus;
 private int rhythmStrStatus;
 private int rhythmDensStatus;

 //***** VECTORS ****
 private float[] instantFeatures;
 private float[] featuresVector;
 private int[] statusVector;
 private int[] prevStatusVector;
 private final int FEATURES_NUMBER = 11;

 //**** SCORES ****
 private float[] paletteIndicator;
 private boolean paletteChange;
 private float elasticityIndicator;
 private float vibrationIndicator;
 private float timbreIndicator;

 //CHANGES
 private int RMSChange;
 private int dynIndexChange;
 private int centroidChange;
 private int complexityChange; 
 /*private int COBEChange; //COBE
 private int EBFChange;  //EBF
 private int SkewnessDChange; //SkewD
 private int SkewnessEChange; //SkewE
 private int RoughnessChange; //Rough*/
 
 private int rhythmStrChange;
 private int rhythmDensChange;

 AudioDecisor(Dynamic d, Rhythm r, Timbre t) 
 {
  dynamic = d;
  rhythm = r;
  timbre = t;

  instantFeatures = new float[FEATURES_NUMBER];
  featuresVector = new float[FEATURES_NUMBER];
  statusVector = new int[FEATURES_NUMBER];
  prevStatusVector = new int[FEATURES_NUMBER];

  changesNumber = 0;
  checking = false;

  paletteIndicator = new float[2];
  paletteChange = false;
  elasticityIndicator = 0;
  vibrationIndicator = 0;
  timbreIndicator = 0;

  //STATS
  RMS = new Statistics(86); //2 seconds
  DynIndex = new Statistics(86);
  
  specComplexity = new Statistics(86);
  specCentroid = new Statistics(86);
  //ZCR=new Statistics(86); 
  COBE = new Statistics(86); //COBE
  EBF = new Statistics(86);  //EBF
  SkewnessD = new Statistics(86); //SkewD
  SkewnessE = new Statistics(86); //SkewE
  Roughness = new Statistics(86); //Rough
  
  rhythmStr = new Statistics(172); //4 seconds
  rhythmDens = new Statistics(172);

  RMSChange = 0;
  dynIndexChange = 0;
  
  centroidChange = 0;
  complexityChange = 0;  
  /*COBEChange = 0; //COBE
  EBFChange = 0;  //EBF
  SkewnessDChange = 0; // SkewD
  SkewnessEChange = 0; // SkewE
  RoughnessChange = 0; // Rough*/
  
  rhythmStrChange = 0;
  rhythmDensChange = 0;

  //HYSTERESIS
  //ricontrollare e validare e soglie facendo dei test su varie tracce e calcolando la media per ogni feature

  RMSLowerBound = new Hysteresis(0.28, 0.32, 11); //check for 0.25 seconds
  RMSUpperBound = new Hysteresis(0.54, 0.58, 11);

  DynIndexLowerBound = new Hysteresis(0.09, 0.11, 11);
  DynIndexUpperBound = new Hysteresis(0.18, 0.20, 11);

  specCentroidLowerBound = new Hysteresis(1900, 2200, 11);
  specCentroidUpperBound = new Hysteresis(2800, 3200, 11);

  specComplexityLowerBound = new Hysteresis(10, 12, 11);
  specComplexityUpperBound = new Hysteresis(17, 19, 11);
  
  /*COBELowerBound = new Hysteresis( 0, 0, 0 ); //COBE   TO BE implemented
  COBEUpperBound = new Hysteresis( 0, 0, 0 ); //COBE
  
  EBFLowerBound = new Hysteresis( 0, 0, 0 ); //EBF  TO BE implemented
  EBFUpperBound = new Hysteresis( 0, 0, 0 ); //EBF
  
  SkewnessDLowerBound = new Hysteresis( 0, 0, 0 ); //SkewD  TO BE implemented
  SkewnessDUpperBound = new Hysteresis( 0, 0, 0 ); //SkewD
  
  SkewnessELowerBound = new Hysteresis( 0, 0, 0 ); //SkewE  TO BE implemented
  SkewnessEUpperBound = new Hysteresis( 0, 0, 0 ); //SkewE
  
  RoughnessLowerBound = new Hysteresis( 0, 0, 0 ); //Rough  TO BE implemented
  RoughnessUpperBound = new Hysteresis( 0, 0, 0 ); //Rough */
  
  rhythmStrLowerBound = new Hysteresis(25, 30, 11);
  rhythmStrUpperBound = new Hysteresis(120, 130, 11);

  rhythmDensLowerBound = new Hysteresis(1, 2, 43);
  rhythmDensUpperBound = new Hysteresis(3.5, 4.5, 43);

  //IDEA: utilizzare la deviazione standard per aggiornare le soglie, in modo che il sistema sia adattivo alla traccia corrente

 }

 public void run() 
 {
  if (dynamic.isSilence(-60) || !dynamic.isSilence(-50)) 
  {
   collectStats();
   checkStatus();
   aggregateStatus();
  } 
  else 
  {
   for (int i = 0; i < FEATURES_NUMBER; i++) 
   {
    statusVector[i] = -1;
   }
  }

  checkChanges();
 }

 private void collectStats() 
 {
  //DYN
  RMS.accumulate(dynamic.getRMS());
  instantFeatures[0] = dynamic.getRMS();

  DynIndex.accumulate(dynamic.getRMSStdDev());
  instantFeatures[1] = dynamic.getRMSStdDev();

  //TIMBRE
  specCentroid.accumulate(timbre.getCentroidHz());
  instantFeatures[2] = timbre.getCentroidHz();

  specComplexity.accumulate(timbre.getComplexity());
  instantFeatures[3] = timbre.getComplexity();

  //RHYTHM
  rhythmStr.accumulate(rhythm.getRhythmStrength());
  instantFeatures[4] = rhythm.getRhythmStrength();

  rhythmDens.accumulate(rhythm.getRhythmDensity());
  instantFeatures[5] = rhythm.getRhythmDensity();
  
  COBE.accumulate(timbre.getCOBEsamples()); //COBE
  instantFeatures[6] = timbre.getCOBEsamples(); //COBE

  EBF.accumulate(timbre.getEBFsamples()); //EBF
  instantFeatures[7] = timbre.getEBFsamples(); //EBF

  SkewnessD.accumulate(timbre.getSkewnessD()); //SkewD
  instantFeatures[8] = timbre.getSkewnessD();  //SkewD

  SkewnessE.accumulate(timbre.getSkewnessE()); //SkewE
  instantFeatures[9] = timbre.getSkewnessE();  //skewE

  Roughness.accumulate(timbre.getRoughness()); //Rough
  instantFeatures[10] = timbre.getRoughness(); //Rough
 }

 private void checkStatus() 
 {
  checkRMSStatus();
  checkDynIndexStatus();
  checkCentroidStatus();
  checkComplexityStatus();
  /*checkCOBEStatus(); //COBE
  checkEBFStatus(); //EBF
  checkSkewnessDStatus(); //SkewD
  checkSkewnessEStatus(); //SkewE
  checkRoughnessStatus(); //Rough*/
  checkRhythmStrStatus();
  checkRhythmDensStatus();
 }

 private void checkRMSStatus() 
 {
  //CHECK RMS STATUS
  if (!RMSLowerBound.checkWindow(RMS.getAverage()) && !RMSUpperBound.checkWindow(RMS.getAverage()))      { RMSStatus = 0; } /*RMS LOW*/
  else if (RMSLowerBound.checkWindow(RMS.getAverage()) && !RMSUpperBound.checkWindow(RMS.getAverage()))  { RMSStatus = 1; } /*RMS MEDIUM*/
  else if (RMSLowerBound.checkWindow(RMS.getAverage()) && RMSUpperBound.checkWindow(RMS.getAverage()))   { RMSStatus = 3; } /*RMS HIGH*/
  
  featuresVector[0] = RMS.getAverage();
  statusVector[0] = RMSStatus;
 }

 private void checkDynIndexStatus() 
 {
  //CHECK RMS STATUS
  if (!DynIndexLowerBound.checkWindow(DynIndex.getAverage()) && !DynIndexUpperBound.checkWindow(DynIndex.getAverage()))     { DynIndexStatus = 0; } /*RMS LOW*/
  else if (DynIndexLowerBound.checkWindow(DynIndex.getAverage()) && !DynIndexUpperBound.checkWindow(DynIndex.getAverage())) { DynIndexStatus = 1; } /* RMS MEDIUM */
  else if (DynIndexLowerBound.checkWindow(DynIndex.getAverage()) && DynIndexUpperBound.checkWindow(DynIndex.getAverage()))  { DynIndexStatus = 3; } /*RMS HIGH*/
  
  featuresVector[1] = DynIndex.getAverage();
  statusVector[1] = DynIndexStatus;
 }

 private void checkCentroidStatus() 
 {
  if (!specCentroidLowerBound.checkWindow(specCentroid.getAverage()) && !specCentroidUpperBound.checkWindow(specCentroid.getAverage()))     { centroidStatus = 0; } /*LOW*/
  else if (specCentroidLowerBound.checkWindow(specCentroid.getAverage()) && !specCentroidUpperBound.checkWindow(specCentroid.getAverage())) { centroidStatus = 1; } /*MEDIUM*/
  else if (specCentroidLowerBound.checkWindow(specCentroid.getAverage()) && specCentroidUpperBound.checkWindow(specCentroid.getAverage()))  { centroidStatus = 3; } /*HOGH*/

  featuresVector[2] = specCentroid.getAverage();
  statusVector[2] = centroidStatus;
 }

 private void checkComplexityStatus() 
 {
  if (!specComplexityLowerBound.checkWindow(specComplexity.getAverage()) && !specComplexityUpperBound.checkWindow(specComplexity.getAverage()))    { complexityStatus = 0; } /*LOW*/
  else if (specComplexityLowerBound.checkWindow(specComplexity.getAverage()) && !specComplexityUpperBound.checkWindow(specComplexity.getAverage())){ complexityStatus = 1; } /*MEDIUM*/
  else if (specComplexityLowerBound.checkWindow(specComplexity.getAverage()) && specComplexityUpperBound.checkWindow(specComplexity.getAverage())) { complexityStatus = 3; } /*HIGH*/
 
  featuresVector[3] = specComplexity.getAverage();
  statusVector[3] = complexityStatus;
 }

 private void checkRhythmStrStatus() 
 {
  if (!rhythmStrLowerBound.checkWindow(rhythmStr.getAverage()) && !rhythmStrUpperBound.checkWindow(rhythmStr.getAverage()))     { rhythmStrStatus = 0; } /*LOW*/
  else if (rhythmStrLowerBound.checkWindow(rhythmStr.getAverage()) && !rhythmStrUpperBound.checkWindow(rhythmStr.getAverage())) { rhythmStrStatus = 1; } /*MEDIUM*/
  else if (rhythmStrLowerBound.checkWindow(rhythmStr.getAverage()) && rhythmStrUpperBound.checkWindow(rhythmStr.getAverage()))  { rhythmStrStatus = 3; } /*HIGH*/
 
  featuresVector[4] = rhythmStr.getAverage();
  statusVector[4] = rhythmStrStatus;
 }

 private void checkRhythmDensStatus() 
 {
  if (!rhythmDensLowerBound.checkWindow(rhythmDens.getAverage()) && !rhythmDensUpperBound.checkWindow(rhythmDens.getAverage()))     { rhythmDensStatus = 0; } /*LOW*/
  else if (rhythmDensLowerBound.checkWindow(rhythmDens.getAverage()) && !rhythmDensUpperBound.checkWindow(rhythmDens.getAverage())) { rhythmDensStatus = 1; } /*MEDIUM*/
  else if (rhythmDensLowerBound.checkWindow(rhythmDens.getAverage()) && rhythmDensUpperBound.checkWindow(rhythmDens.getAverage()))  { rhythmDensStatus = 3; } /*HIGH*/
  
  featuresVector[5] = rhythmDens.getAverage();
  statusVector[5] = rhythmDensStatus;
 }
 
/* private void checkCOBEStatus() //COBE aggiungere if  per stabilire lo stato.
 {
   { COBEStatus = 0; } 
   { COBEStatus = 1; } 
   { COBEStatus = 3; }
   
   featuresVector[6] = COBE.getAverage();
   statusVector[6] = COBEStatus;
 }
 
 private void checkEBFStatus() //EBF aggiungere if  per stabilire lo stato.
 {
   { EBFStatus = 0; } 
   { EBFStatus = 1; } 
   { EBFStatus = 3; }
   
   featuresVector[7] = EBF.getAverage();
   statusVector[7] = EBFStatus;
 }

 private void checkSkewnessDStatus() //SkewD aggiungere if  per stabilire lo stato.
 {
   { SkewnessDStatus = 0; } 
   { SkewnessDStatus = 1; } 
   { SkewnessDStatus = 3; }
   
   featuresVector[8] = SkewnessD.getAverage();
   statusVector[8] = SkewnessDStatus;
 }
 
 private void checkSkewnessEStatus() //SkewE aggiungere if  per stabilire lo stato.
 {
   { SkewnessEStatus = 0; } 
   { SkewnessEStatus = 1; } 
   { SkewnessEStatus = 3; }
   
   featuresVector[9] = SkewnessE.getAverage();
   statusVector[9] = SkewnessEStatus;
 }
 
 private void checkRoughnessStatus() //Rough aggiungere if  per stabilire lo stato.
 {
   { RoughnessStatus = 0; } 
   { RoughnessStatus = 1; } 
   { RoughnessStatus = 3; }
   
   featuresVector[10] = Roughness.getAverage();
   statusVector[10] = RoughnessStatus;
 } */
 
 private void checkChanges() 
 {
  //CHECK STATUS CHANGES IN A 4 SECONDS TEMPORAL WINDOW
  //beginCheck=frameCount;
  if (!checking) 
  {
   endCheck = frameCount + global_fps * 4;
  }
  if (frameCount <= endCheck) 
  {
   checking = true;
   for (int i = 0; i < FEATURES_NUMBER; i++) 
   {
    if (statusVector[i] != prevStatusVector[i]) 
    {
     manageChanges(i, (statusVector[i] - prevStatusVector[i]));
     changesNumber++;
    } 
    else 
    {
     manageChanges(i, 0);
    }
   }
  } 
  else 
  {
   changesNumber = 0;
   checking = false;
  }
  //UPDATE STATUS VECTOR
  prevStatusVector = statusVector.clone();
 }
 
 private void manageChanges(int feature_index, int direction) 
 {
  switch (feature_index) 
  {
   case (0):
    if (direction > 0) { RMSChange = 1; }
    else if (direction < 0) { RMSChange = -1; }
    else { RMSChange = 0; }
    break;

   case (1):
    if (direction > 0) dynIndexChange = 1;
    else if (direction < 0) dynIndexChange = -1;
    else dynIndexChange = 0;
    break;

   case (2):
    if (direction > 0) centroidChange = 1;
    else if (direction < 0) centroidChange = -1;
    else centroidChange = 0;
    break;

   case (3):
    if (direction > 0) complexityChange = 1;
    else if (direction < 0) complexityChange = -1;
    else complexityChange = 0;
    break;

   case (4):
    if (direction > 0) rhythmStrChange = 1;
    else if (direction < 0) rhythmStrChange = -1;
    else rhythmStrChange = 0;
    break;

   case (5):
    if (direction > 0) rhythmDensChange = 1;
    else if (direction < 9) rhythmDensChange = -1;
    else rhythmDensChange = 0;
    break;
    
   /*case (6): //COBE
    //if;
    //else if;
    //else;  
   break;
   
   case (7): //EBF
    //if;
    //else if;
    //else;  
   break;
   
   case (8): //SkewD
    //if;
    //else if;
    //else;  
   break;
   
   case (9): //SkewE
    //if;
    //else if;
    //else;  
   break;
   
   case (10): //Rough
    //if;
    //else if;
    //else;  
   break;*/
  }
 }

 private void aggregateStatus() 
 {
  //aggregate features status 
  paletteIndicator[0] = statusVector[0] + statusVector[2] + statusVector[3];

  if (paletteIndicator[0] > PALETTE_THRESHOLD && paletteIndicator[1] <= PALETTE_THRESHOLD)      { paletteChange = true; } 
  else if (paletteIndicator[0] <= PALETTE_THRESHOLD && paletteIndicator[1] > PALETTE_THRESHOLD) { paletteChange = true; }
  else if ((paletteIndicator[0] > PALETTE_THRESHOLD && paletteIndicator[1] > PALETTE_THRESHOLD) || (paletteIndicator[0] <= PALETTE_THRESHOLD && paletteIndicator[1] <= PALETTE_THRESHOLD)) 
  {
   paletteChange = false;
  }

  paletteIndicator[1] = paletteIndicator[0];

  elasticityIndicator = statusVector[1] + statusVector[4];

  vibrationIndicator = statusVector[0] + statusVector[5];

  timbreIndicator = statusVector[2] + statusVector[3];
 }

 // GETTERS
 public int[] getStatusVector()  { return statusVector; }
 
 public float[] getFeaturesVector() { return featuresVector; }

 public float[] getInstantFeatures() { return instantFeatures; } 
 
 public boolean isSilence()  { return dynamic.isSilence(); }
 
 public boolean isSilence(float t) { return dynamic.isSilence(t); }

 public int getChangesNumber() {  return changesNumber; }
 
 public int getCentroidChangeDir() { return centroidChange; }
 
 public int getComplexityChangeDir() { return complexityChange; }
 
/*public int getCOBEChange() { return COBEChange; } //COBE
 
 public int getEBFChange() { return EBFChange; } //EBF
 
 public int getSkewnessDChange() { return SkewnessDChange; } //SkewD
 
 public int getSkewnessEChange() { return SkewnessEChange; } //SkewE
 
 public int getRoughnessChange() { return RoughnessChange; } //Rough*/
 
 public boolean getPaletteChange() { return paletteChange; }
 
 public float getPaletteIndicator() { return paletteIndicator[0]; }

 public float getElasticityIndicator() { return elasticityIndicator; }

 public float getVibrationIndicator() { return vibrationIndicator; }

 public float getTimbreIndicator()  { return timbreIndicator; }
 
 public float getCentroidStatusLowerBound() 
 {
  if (statusVector[2] == 0) { return 0; }
  else if (statusVector[2] == 1) { return specCentroidLowerBound.getLowerBound(); }
  else if (statusVector[2] == 3) { return specCentroidUpperBound.getLowerBound(); }
  else { return -1; } 
 }

 public float getCentroidStatusUpperBound() 
 {
  if (statusVector[2] == 0) { return specCentroidLowerBound.getUpperBound(); }
  else if (statusVector[2] == 1) { return specCentroidUpperBound.getUpperBound(); }
  else if (statusVector[2] == 3) { return 7000; }
  else { return -1; }
 }

 public float getComplexityStatusLowerBound() 
 {
  if (statusVector[3] == 0) {return 0;}
  else if (statusVector[3] == 1) { return specComplexityLowerBound.getLowerBound(); }
  else if (statusVector[3] == 3) {  return specComplexityUpperBound.getLowerBound(); }
  else { return -1; }
 }

 public float getComplexityStatusUpperBound() 
 {
  if (statusVector[3] == 0) { return specComplexityLowerBound.getUpperBound(); }
  else if (statusVector[3] == 1) { return specComplexityUpperBound.getUpperBound(); }
  else if (statusVector[3] == 3) { return 30; }
  else { return -1; }
 }
 
 /*public float getCOBEStatusLowerBound() { return 0.0; }  // COBE to be implemented
 public float getCOBEStatusUpperBound() { return 0.0; }  // COBE to be implemented
 
 public float getEBFStatusLowerBound() { return 0.0; }  // EBF to be implemented
 public float getEBFStatusUpperBound() { return 0.0; }  // EBF to be implemented
 
 public float getSkewnessDStatusLowerBound() { return 0.0; }  // SkewD to be implemented
 public float getSkewnessDStatusUpperBound() { return 0.0; }  // SkewD to be implemented
 
 public float getSkewnessEStatusLowerBound() { return 0.0; }  // SkewE to be implemented
 public float getSkewnessEStatusUpperBound() { return 0.0; }  // SkewE to be implemented
 
 public float getRoughnessStatusLowerBound() { return 0.0; }  // ROUGH to be implemented
 public float getRoughnessStatusUpperBound() { return 0.0; }  // Rough to be implemented */
 
 public float getRMSLowerThreshold() { return (RMSLowerBound.getLowerBound() + RMSLowerBound.getUpperBound()) / 2; }
 public float getRMSUpperThreshold() { return (RMSUpperBound.getLowerBound() + RMSUpperBound.getUpperBound()) / 2; }
 
 public float getDynIndexLowerThreshold() { return ((DynIndexLowerBound.getLowerBound() + DynIndexLowerBound.getUpperBound()) / 2); }
 public float getDynIndexUpperThreshold() { return ((DynIndexUpperBound.getLowerBound() + DynIndexUpperBound.getUpperBound()) / 2); }
 
 public float getCentroidLowerThreshold() { return (specCentroidLowerBound.getLowerBound() + specCentroidLowerBound.getUpperBound()) / 2; }
 public float getCentroidUpperThreshold() { return (specCentroidUpperBound.getLowerBound() + specCentroidUpperBound.getUpperBound()) / 2; }
 
 public float getComplexityLowerThreshold() { return (specComplexityLowerBound.getLowerBound() + specComplexityLowerBound.getUpperBound()) / 2; }
 public float getComplexityUpperThreshold() { return (specComplexityUpperBound.getLowerBound() + specComplexityUpperBound.getUpperBound()) / 2; }
 
 /*public float getCOBELowerThreshold() { return ( COBELowerBound.getLowerBound() + COBELowerBound.getUpperBound() ) / 2; } //COBE
 public float getCOBEUpperThreshold() { return ( COBEUpperBound.getLowerBound() + COBEUpperBound.getUpperBound() ) / 2; } //COBE
 
 public float getEBFLowerThreshold() { return ( EBFLowerBound.getLowerBound() + EBFLowerBound.getUpperBound() ) / 2; } //EBF
 public float getEBFUpperThreshold() { return ( EBFUpperBound.getLowerBound() + EBFUpperBound.getUpperBound() ) / 2; } //EBF
 
 public float getSkewnessDLowerThreshold() { return ( SkewnessDLowerBound.getLowerBound() + SkewnessDLowerBound.getUpperBound() ) / 2; } //SkewD
 public float getSkewnessDUpperThreshold() { return ( SkewnessDUpperBound.getLowerBound() + SkewnessDUpperBound.getUpperBound() ) / 2; } //SkewD
 
 public float getSkewnessELowerThreshold() { return ( SkewnessELowerBound.getLowerBound() + SkewnessELowerBound.getUpperBound() ) / 2; } //SkewE
 public float getSkewnessEUpperThreshold() { return ( SkewnessEUpperBound.getLowerBound() + SkewnessEUpperBound.getUpperBound() ) / 2; } //SkewE
 
 public float getRoughnessLowerThreshold() { return ( RoughnessLowerBound.getLowerBound() + RoughnessLowerBound.getUpperBound() ) / 2; } //Rough
 public float getRoughnessUpperThreshold() { return ( RoughnessUpperBound.getLowerBound() + RoughnessUpperBound.getUpperBound() ) / 2; } //Rough */
 
 public float getRhythmStrLowerThreshold()  { return (rhythmStrLowerBound.getLowerBound() + rhythmStrLowerBound.getUpperBound()) / 2; }
 public float getRhythmStrUpperThreshold()  { return (rhythmStrUpperBound.getLowerBound() + rhythmStrUpperBound.getUpperBound()) / 2; }
 
 public float getRhythmDensLowerThreshold() { return (rhythmDensLowerBound.getLowerBound() + rhythmDensLowerBound.getUpperBound()) / 2; }
 public float getRhythmDensUpperThreshold() { return (rhythmDensUpperBound.getLowerBound() + rhythmDensUpperBound.getUpperBound()) / 2; }
 
 // STTERS
 public void setRMSLowerBound(float value) 
 {
  RMSLowerBound.setLowerBound(value - 0.02);
  RMSLowerBound.setUpperBound(value + 0.02);
 }

 public void setRMSUpperBound(float value) 
 {
  RMSUpperBound.setLowerBound(value - 0.02);
  RMSUpperBound.setUpperBound(value + 0.02);
 }

 public void setDynIndexLowerBound(float value) 
 {
  DynIndexLowerBound.setLowerBound(value - 0.01);
  DynIndexLowerBound.setUpperBound(value + 0.01);
 }

 public void setDynIndexUpperBound(float value) 
 {
  DynIndexUpperBound.setLowerBound(value - 0.01);
  DynIndexUpperBound.setUpperBound(value + 0.01);
 }

 public void setCentroidLowerBound(float value) 
 {
  specCentroidLowerBound.setLowerBound(value - 150);
  specCentroidLowerBound.setUpperBound(value + 150);
 }

 public void setCentroidUpperBound(float value) 
 {
  specCentroidUpperBound.setLowerBound(value - 200);
  specCentroidUpperBound.setUpperBound(value + 200);
 }

 public void setComplexityLowerBound(float value) 
 {
  specComplexityLowerBound.setLowerBound(value - 1);
  specComplexityLowerBound.setUpperBound(value + 1);
 }

 public void setComplexityUpperBound(float value) 
 {
  specComplexityUpperBound.setLowerBound(value - 1);
  specComplexityUpperBound.setUpperBound(value + 1);
 }
 
 /*public void setCOBELowerBound(float value)  //COBE 
 {
  COBELowerBound.setLowerBound(value);
  COBELowerBound.setUpperBound(value);  
 }
 
 public void setCOBEUpperBound(float value)  //COBE 
 {
  COBEUpperBound.setLowerBound(value);
  COBEUpperBound.setUpperBound(value);  
 }
 
 public void setEBFLowerBound(float value)  //EBF 
 {
  EBFLowerBound.setLowerBound(value);
  EBFLowerBound.setUpperBound(value);  
 }
 
 public void setEBFUpperBound(float value)  //EBF 
 {
  EBFUpperBound.setLowerBound(value);
  EBFUpperBound.setUpperBound(value);  
 }
 
 public void setSkewnessDLowerBound(float value)  //SkewnessD 
 {
  SkewnessDLowerBound.setLowerBound(value);
  SkewnessDLowerBound.setUpperBound(value);  
 }
 
 public void setSkewnessDUpperBound(float value)  //SkewnessD 
 {
  SkewnessDUpperBound.setLowerBound(value);
  SkewnessDUpperBound.setUpperBound(value);  
 }
 
 public void setSkewnessELowerBound(float value)  //SkewnessE 
 {
  SkewnessELowerBound.setLowerBound(value);
  SkewnessELowerBound.setUpperBound(value);  
 }
 
 public void setSkewnessEUpperBound(float value)  //SkewnessE
 {
  SkewnessEUpperBound.setLowerBound(value);
  SkewnessEUpperBound.setUpperBound(value);  
 }
 
 public void setRoughnessLowerBound(float value)  //Rough 
 {
  RoughnessLowerBound.setLowerBound(value);
  RoughnessLowerBound.setUpperBound(value);  
 }
 
 public void setRoughnessUpperBound(float value)  //Rough
 {
  RoughnessUpperBound.setLowerBound(value);
  RoughnessUpperBound.setUpperBound(value);  
 } */
  
 public void setRhythmStrLowerBound(float value) 
 {
  rhythmStrLowerBound.setLowerBound(value - 2.5);
  rhythmStrLowerBound.setUpperBound(value + 2.5);
 }

 public void setRhythmStrUpperBound(float value) 
 {
  rhythmStrUpperBound.setLowerBound(value - 5);
  rhythmStrUpperBound.setUpperBound(value + 5);
 }

 public void setRhythmDensLowerBound(float value) 
 {
  rhythmDensLowerBound.setLowerBound(value - 0.5);
  rhythmDensLowerBound.setUpperBound(value + 0.5);
 }

 public void setRhythmDensUpperBound(float value) 
 {
  rhythmDensUpperBound.setLowerBound(value - 0.5);
  rhythmDensUpperBound.setUpperBound(value + 0.5);
 }
}