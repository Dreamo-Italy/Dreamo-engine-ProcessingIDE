class AudioDecisor
{
  
  private Dynamic dynamic;
  private Rhythm rhythm;
  private Timbre timbre;
  
  private float clarity;
  private float agitation;
  private float energy;
  private float roughness;
  
 
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
  //private int ZCRStatus;
  private int rhythmStrStatus;
  private int rhythmDensStatus;
  
  //***** VECTORS ****
  private float[] instantFeatures;  
  private float[] featuresVector;
  private int[] statusVector;
  private int[] prevStatusVector;
  private final int FEATURES_NUMBER=6;
 
  //**** SCORES ****
  private float[] colorIndicator;
  private boolean colorChange;
  private float[] elasticityIndicator;
  private float vibrationIndicator;
  private float timbreIndicator;
  
  //CHANGES
  private int RMSChange;
  private int dynIndexChange;
  private int centroidChange;
  private int complexityChange;
  private int rhythmStrChange;
  private int rhythmDensChange;
  
  //**** AUDIO DATA FOR DIRECT ASSEGNATION
  //INSTANTANOUS VOL: global_dyn.getRMS();
  //DYNAMIC INDEX: global_dyn.getDynamicityIndex();
  //SPECTRAL CENTROID: global_timbre.getCentroid();
  //SPECTRAL COMPLEXITY: global_timbre.getComplexityAvg(); //average is better? 
        
  //**** AUDIO DATA FOR TRIGGERING
  //SILENCE: global_dyn.isSilence(); //try different thresholds
  //DETECT DROP (?)
  //AVERAGE VOL: global_dyn.getRMSAvg();
  //CENTROID RELATIVE RATIO: global_timbre.getCentroidRelativeRatio();
    
  AudioDecisor(Dynamic d, Rhythm r, Timbre t)
  {
    dynamic=d;
    rhythm=r;
    timbre=t;    
    
    instantFeatures=new float[FEATURES_NUMBER];
    featuresVector=new float[FEATURES_NUMBER];
    statusVector=new int[FEATURES_NUMBER];
    prevStatusVector=new int[FEATURES_NUMBER];

    changesNumber=0;
    checking=false;   
     
    colorIndicator=new float[2];
    colorChange=false; 
    elasticityIndicator=new float[2];
    vibrationIndicator=0;
    timbreIndicator=0;
      
    //STATS
    RMS=new Statistics(86); //2 seconds
    DynIndex=new Statistics(86);   
    specComplexity=new Statistics(86);
    specCentroid=new Statistics(86); 
    //ZCR=new Statistics(86);   
    rhythmStr=new Statistics(172);
    rhythmDens=new Statistics(172);
 
    RMSChange=0;
    dynIndexChange=0;
    centroidChange=0;
    complexityChange=0;
    rhythmStrChange=0;
    rhythmDensChange=0;
   
 
    
    //HYSTERESIS
    //ricontrollare e validare e soglie facendo dei test su varie tracce e calcolando la media per ogni feature
    
    RMSLowerBound=new Hysteresis(0.28,0.32,11); //check for 0.25 seconds
    RMSUpperBound=new Hysteresis(0.54,0.58,11);
    
    DynIndexLowerBound=new Hysteresis(0.09,0.11,11);
    DynIndexUpperBound=new Hysteresis(0.18,0.20,11);
    
    specCentroidLowerBound=new Hysteresis(1900,2200,11);
    specCentroidUpperBound=new Hysteresis(2800,3200,11);
    
    specComplexityLowerBound=new Hysteresis(10,12,11);
    specComplexityUpperBound=new Hysteresis(17,19,11);
    
    rhythmStrLowerBound=new Hysteresis(25,30,11);
    rhythmStrUpperBound=new Hysteresis(120,130,11);
    
    rhythmDensLowerBound=new Hysteresis(1,2,43);
    rhythmDensUpperBound=new Hysteresis(3.5,4.5,43);    
    
    //IDEA: utilizzare la deviazione standard per aggiornare le soglie, in modo che il sistema sia adattivo alla traccia corrente
      
  }
  

  public int[] getStatusVector() { return statusVector; }
 
  public float[] getFeturesVector() { return featuresVector; }
  
  public float[] getInstantFeatures() { return instantFeatures; }
  
  public boolean isSilence() { return dynamic.isSilence(); }
 
  public boolean isSilence(float t) { return dynamic.isSilence(t); }
  
  public int getChangesNumber() { return changesNumber; }
  
  public int getCentroidChangeDir() { return centroidChange;}
  
  public int getComplexityChangeDir() { return complexityChange;}
  
  public boolean getColorChange() { return colorChange; }
  
  public float getColorIndicator() { return colorIndicator[0]; }
  
  public float getElasticityIndicator() { return elasticityIndicator[0]; }
  
  public float getVibrationIndicator() { return vibrationIndicator; }
  
  public float getTimbreIndicator() {return timbreIndicator; }
  

  public void run()
  {   
    if(dynamic.isSilence(-60) || !dynamic.isSilence(-50))
    { 
      collectStats();
      checkStatus();
      aggregateStatus();
    }
    else
    {
      for(int i=0;i<FEATURES_NUMBER;i++)
      {
      statusVector[i]=-1;
      }
    }
        
    checkChanges();
    
  }
  
  
  private void collectStats()
  {
    //DYN
    RMS.accumulate(dynamic.getRMS());
    instantFeatures[0]=dynamic.getRMS();
    
    DynIndex.accumulate(dynamic.getRMSStdDev());
    instantFeatures[1]=dynamic.getRMSStdDev();
    
    //TIMBRE
    specCentroid.accumulate(timbre.getCentroidHz());
    instantFeatures[2]=timbre.getCentroidHz();
    
    specComplexity.accumulate(timbre.getComplexity());
    instantFeatures[3]=timbre.getComplexity();
    
    //RHYTHM
    rhythmStr.accumulate(rhythm.getRhythmStrength());
    instantFeatures[4]=rhythm.getRhythmStrength();
    
    rhythmDens.accumulate(rhythm.getRhythmDensity());
    instantFeatures[5]=rhythm.getRhythmDensity();       
    
  }
  
  
  private void checkStatus()
  {
    checkRMSStatus();
    checkDynIndexStatus();
    checkCentroidStatus();
    checkComplexityStatus();
    checkRhythmStrStatus();
    checkRhythmDensStatus();
   
  }
  
  
  private void checkRMSStatus()
  {
    //CHECK RMS STATUS
    if(!RMSLowerBound.checkWindow(RMS.getAverage()) && !RMSUpperBound.checkWindow(RMS.getAverage()))
    {
      //RMS LOW
      RMSStatus=0;
    }
    
    else if (RMSLowerBound.checkWindow(RMS.getAverage()) && !RMSUpperBound.checkWindow(RMS.getAverage()))
    {
      //RMS MEDIUM
      RMSStatus=1;
    }
  
    else if (RMSLowerBound.checkWindow(RMS.getAverage()) && RMSUpperBound.checkWindow(RMS.getAverage()))
    {
      //RMS HIGH
      RMSStatus=3;
    }
    
    featuresVector[0]=RMS.getAverage();
    statusVector[0]=RMSStatus;
    
  }
  
  private void checkDynIndexStatus()
  {
    //CHECK RMS STATUS
    if(!DynIndexLowerBound.checkWindow(DynIndex.getAverage()) && !DynIndexUpperBound.checkWindow(DynIndex.getAverage()))
    {
      //RMS LOW
      DynIndexStatus=0;
    }
    
    else if (DynIndexLowerBound.checkWindow(DynIndex.getAverage()) && !DynIndexUpperBound.checkWindow(DynIndex.getAverage()))
    {
      //RMS MEDIUM
      DynIndexStatus=1;
    }
  
    else if (DynIndexLowerBound.checkWindow(DynIndex.getAverage()) && DynIndexUpperBound.checkWindow(DynIndex.getAverage()))
    {
      //RMS HIGH
      DynIndexStatus=3;
    }
    
    featuresVector[1]=DynIndex.getAverage();
    statusVector[1]=DynIndexStatus;
    
  }
  
  
 private void checkCentroidStatus()
 {   
    if(!specCentroidLowerBound.checkWindow(specCentroid.getAverage()) && !specCentroidUpperBound.checkWindow(specCentroid.getAverage()))
    {        
      //println("LOW");
      centroidStatus=0;
    }
    
    else if (specCentroidLowerBound.checkWindow(specCentroid.getAverage()) && !specCentroidUpperBound.checkWindow(specCentroid.getAverage()))
    { 
      //println("MEDIUM");
      centroidStatus=1;
    }
  
    else if (specCentroidLowerBound.checkWindow(specCentroid.getAverage()) && specCentroidUpperBound.checkWindow(specCentroid.getAverage()) )
    {
     centroidStatus=3;
    }
   
   featuresVector[2]=specCentroid.getAverage();
   statusVector[2]=centroidStatus;
   
 }
  
 private void checkComplexityStatus()
 {
    
    if(!specComplexityLowerBound.checkWindow(specComplexity.getAverage()) && !specComplexityUpperBound.checkWindow(specComplexity.getAverage()))
    {        
      //println("LOW");
      complexityStatus=0;
    }
    
    else if (specComplexityLowerBound.checkWindow(specComplexity.getAverage()) && !specComplexityUpperBound.checkWindow(specComplexity.getAverage()))
    { 
      //println("MEDIUM");
      complexityStatus=1;
    }
  
    else if (specComplexityLowerBound.checkWindow(specComplexity.getAverage()) && specComplexityUpperBound.checkWindow(specComplexity.getAverage()) )
    {
     complexityStatus=3;
    }
    
    featuresVector[3]=specComplexity.getAverage();
    statusVector[3]=complexityStatus;
  
 }
 
 
 private void checkRhythmStrStatus()
 {
    if(!rhythmStrLowerBound.checkWindow(rhythmStr.getAverage()) && !rhythmStrUpperBound.checkWindow(rhythmStr.getAverage()))
    {        
      //println("LOW");
      rhythmStrStatus=0;
    }
    
    else if (rhythmStrLowerBound.checkWindow(rhythmStr.getAverage()) && !rhythmStrUpperBound.checkWindow(rhythmStr.getAverage()))
    { 
      //println("MEDIUM");
      rhythmStrStatus=1;
    }
  
    else if (rhythmStrLowerBound.checkWindow(rhythmStr.getAverage()) && rhythmStrUpperBound.checkWindow(rhythmStr.getAverage()) )
    {
     rhythmStrStatus=3;
    }
   
   featuresVector[4]=rhythmStr.getAverage();
   statusVector[4]=rhythmStrStatus;
 }
 
  private void checkRhythmDensStatus()
 {
    if(!rhythmDensLowerBound.checkWindow(rhythmDens.getAverage()) && !rhythmDensUpperBound.checkWindow(rhythmDens.getAverage()))
    {        
      //println("LOW");
      rhythmDensStatus=0;
    }
    
    else if (rhythmDensLowerBound.checkWindow(rhythmDens.getAverage()) && !rhythmDensUpperBound.checkWindow(rhythmDens.getAverage()))
    { 
      //println("MEDIUM");
      rhythmDensStatus=1;
    }
  
    else if (rhythmDensLowerBound.checkWindow(rhythmDens.getAverage()) && rhythmDensUpperBound.checkWindow(rhythmDens.getAverage()) )
    {
     rhythmDensStatus=3;
    }
   
   featuresVector[5]=rhythmDens.getAverage();
   statusVector[5]=rhythmDensStatus;
 }
  
  
  private void checkChanges()
  { 
    
    //CHECK STATUS CHANGES IN A 4 SECONDS TEMPORAL WINDOW
    //beginCheck=frameCount;
    if (!checking) {endCheck=frameCount+global_fps*4;}
    
    if(frameCount<=endCheck)
    {
      checking=true;      
      for(int i=0;i<FEATURES_NUMBER;i++)
      {
        if(statusVector[i]!=prevStatusVector[i])
        {
          
          manageChanges(i,(statusVector[i]-prevStatusVector[i]));          
          changesNumber++;
        }
        else {manageChanges(i,0);}
      }      
    }
    
    else 
    {
      changesNumber=0;
      checking=false;
    }
       
    //UPDATE STATUS VECTOR
    for(int i=0;i<FEATURES_NUMBER;i++)
    {
      prevStatusVector[i]=statusVector[i];
    }
    
  }
  
  
  private void manageChanges(int feature_index, int direction)
  {
    switch(feature_index)
    {
      case(0): if(direction>0){RMSChange=1;}
               else if (direction<0) {RMSChange=-1;}
               else {RMSChange=0;}
        break; 
        
      case(1): if(direction>0) dynIndexChange=1;    
               else if (direction<0) dynIndexChange=-1;
               else dynIndexChange=0;
        break;
        
      case(2): if(direction>0) centroidChange=1;
               else if (direction<0) centroidChange=-1;
               else centroidChange=0;
        break;
        
      case(3): if(direction>0) complexityChange=1;
               else if (direction<0) complexityChange=-1;
               else complexityChange=0;
        break;
        
      case(4): if(direction>0) rhythmStrChange=1;
               else if (direction <0) rhythmStrChange=-1;
               else rhythmStrChange=0;
        break;
        
      case(5): if(direction>0) rhythmDensChange=1;
               else if (direction<9) rhythmDensChange=-1;
               else rhythmDensChange=0;
        break;     
    }    
  }
  
  
 
  private void aggregateStatus()
  {
    
    //aggregate features status 
    colorIndicator[0]=statusVector[0]+statusVector[2]+statusVector[3];
    
    if(colorIndicator[0]>3 && colorIndicator[1]<=3) {colorChange=true;}
    else if(colorIndicator[0]<=3 && colorIndicator[1]>3) {colorChange=true;}
    else if((colorIndicator[0]>3 && colorIndicator[1]>3) || (colorIndicator[0]<=3 && colorIndicator[1]<=3)) {colorChange=false;}
    
    colorIndicator[1]=colorIndicator[0];
    
    
    elasticityIndicator[0]=statusVector[1]+statusVector[4];
    
    vibrationIndicator=statusVector[0]+statusVector[5];
    //example: centroid+complexity=timbre status
    //dyn index+rhythm strength= rhythm prominency
    
    timbreIndicator=statusVector[2]+statusVector[3];
    
  }
  
  public float getCentroidStatusLowerBound()
  {
    if(statusVector[2]==0) {return 0;}
    else if(statusVector[2]==1) {return specCentroidLowerBound.getLowerBound();}
    else if(statusVector[2]==3) {return specCentroidUpperBound.getLowerBound();}
    else {return -1;}
  }
  
  public float getCentroidStatusUpperBound()
  {
    if(statusVector[2]==0) {return specCentroidLowerBound.getUpperBound();}
    else if(statusVector[2]==1) {return specCentroidUpperBound.getUpperBound();}
    else if(statusVector[2]==3) {return 7000;}
    else {return -1;}
  }
  
  public float getComplexityStatusLowerBound()
  {
    if(statusVector[3]==0) {return 0;}
    else if(statusVector[3]==1) {return specComplexityLowerBound.getLowerBound();}
    else if(statusVector[3]==3) {return specComplexityUpperBound.getLowerBound();}
    else {return -1;}
  }
  
  
  public float getComplexityStatusUpperBound()
  {
    if(statusVector[3]==0) {return specComplexityLowerBound.getUpperBound();}
    else if(statusVector[3]==1) {return specComplexityUpperBound.getUpperBound();}
    else if(statusVector[3]==3) {return 30;}
    else {return -1;}
  }
  
  
  public float getRMSLowerThreshold()
  {
    return (RMSLowerBound.getLowerBound()+RMSLowerBound.getUpperBound())/2;
  }
  
  public float getRMSUpperThreshold()
  {
    return (RMSUpperBound.getLowerBound()+RMSUpperBound.getUpperBound())/2;
  }
  
  public float getDynIndexLowerThreshold()
  {
    return ((DynIndexLowerBound.getLowerBound()+DynIndexLowerBound.getUpperBound())/2);
  }
  
  public float getDynIndexUpperThreshold()
  {
    return ((DynIndexUpperBound.getLowerBound()+DynIndexUpperBound.getUpperBound())/2);
  }
  
  public float getCentroidLowerThreshold()
  {
    return (specCentroidLowerBound.getLowerBound()+specCentroidLowerBound.getUpperBound())/2;
  }
  
  public float getCentroidUpperThreshold()
  {
    return (specCentroidUpperBound.getLowerBound()+specCentroidUpperBound.getUpperBound())/2;
  }
  
  public float getComplexityLowerThreshold()
  {
    return (specComplexityLowerBound.getLowerBound()+specComplexityLowerBound.getUpperBound())/2;
  } 
  
  public float getComplexityUpperThreshold()
  {
    return (specComplexityUpperBound.getLowerBound()+specComplexityUpperBound.getUpperBound())/2;
  } 
  
  public float getRhythmStrLowerThreshold()
  {
    return (rhythmStrLowerBound.getLowerBound()+rhythmStrLowerBound.getUpperBound())/2;
  }
  
  public float getRhythmStrUpperThreshold()
  {
    return (rhythmStrUpperBound.getLowerBound()+rhythmStrUpperBound.getUpperBound())/2;
  }
  
  public float getRhythmDensLowerThreshold()
  {
    return (rhythmDensLowerBound.getLowerBound()+rhythmDensLowerBound.getUpperBound())/2;
  }
  
  public float getRhythmDensUpperThreshold()
  {
    return (rhythmDensUpperBound.getLowerBound()+rhythmDensUpperBound.getUpperBound())/2;
  }
  
  
  public void setRMSLowerBound(float value) 
  {
    RMSLowerBound.setLowerBound(value-0.02);
    RMSLowerBound.setUpperBound(value+0.02);
  }
  
  public void setRMSUpperBound(float value)
  {
    RMSUpperBound.setLowerBound(value-0.02);
    RMSUpperBound.setUpperBound(value+0.02);   
  }
  
  public void setDynIndexLowerBound(float value)
  {
    DynIndexLowerBound.setLowerBound(value-0.01);
    DynIndexLowerBound.setUpperBound(value+0.01);
  }
  
  public void setDynIndexUpperBound(float value)
  {
    DynIndexUpperBound.setLowerBound(value-0.01);
    DynIndexUpperBound.setUpperBound(value+0.01);
  }
  
  public void setCentroidLowerBound(float value)
  {
    specCentroidLowerBound.setLowerBound(value-150);
    specCentroidLowerBound.setUpperBound(value+150);
  }
  
  public void setCentroidUpperBound(float value)
  {
    specCentroidUpperBound.setLowerBound(value-200);
    specCentroidUpperBound.setUpperBound(value+200);
  }
  
  public void setComplexityLowerBound(float value)
  {
    specComplexityLowerBound.setLowerBound(value-1);
    specComplexityLowerBound.setUpperBound(value+1);
  }
  
  public void setComplexityUpperBound(float value)
  {
    specComplexityUpperBound.setLowerBound(value-1);
    specComplexityUpperBound.setUpperBound(value+1);
  }
  
  public void setRhythmStrLowerBound(float value)
  {
    rhythmStrLowerBound.setLowerBound(value-2.5);
    rhythmStrLowerBound.setUpperBound(value+2.5);
  }
  
  public void setRhythmStrUpperBound(float value)
  {
    rhythmStrUpperBound.setLowerBound(value-5);
    rhythmStrUpperBound.setUpperBound(value+5);
  }
  
  public void setRhythmDensLowerBound(float value)
  {
    rhythmDensLowerBound.setLowerBound(value-0.5);
    rhythmDensLowerBound.setUpperBound(value+0.5);    
  }
  
  public void setRhythmDensUpperBound(float value)
  {
    rhythmDensUpperBound.setLowerBound(value-0.5);
    rhythmDensUpperBound.setUpperBound(value+0.5);    
  }
  
  
  
  /*
  private void calcClarity()
  {  
    clarity=global_timbre.getCentroid()+global_timbre.getCentroidRelativeRatio()*0.5; 
  }
  
  
  private void calcEnergy()
  {
    energy=global_dyn.getDynamicityIndex()+global_dyn.getRMS();
  }
  
  private void calcAgitation()
  {
    //complexity+global_timbre.getComplexityAvg()
    agitation=global_timbre.getComplexityAvg()+global_dyn.getDynamicityIndex();
    //dinamicity
  }
  
  
  private void calcRoughness()
  {
    //complexity
    roughness=global_timbre.getComplexityAvg()+global_timbre.getCentroidRelativeRatio()*0.5;
    //centroidglobal_timbre.getCentroidRelativeRatio()
    
  }
  
  
  
  public boolean musicChange()
  {
    //if(centroid_relative.checkWindow(global_timbre.getCentroidRelativeRatio(),0.7,0.7) &&  rmsSlope.checkWindow(global_dyn.getRmsSlope(),0.8,1.2))
    if(global_timbre.getCentroidRelativeRatio()>0.6 && global_dyn.getRmsSlope()>1.2)
    {
      return true;
    }
    else {return false;}
  }
  
    
  public float getClarity()
  {
    return clarity;
  }
    public float getEnergy()
  {
    return energy;
  }
    public float getAgitation()
  {
    return agitation;
  }
    public float getRoughness()
  {
    return roughness;
  }
  */
  
  
  
}