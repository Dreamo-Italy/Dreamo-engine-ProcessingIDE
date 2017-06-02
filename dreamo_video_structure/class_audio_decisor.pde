class AudioDecisor
{
  
  private Dynamic dynamic;
  private Rhythm rhythm;
  private Timbre timbre;
  
  private float clarity;
  private float agitation;
  private float energy;
  private float roughness;
  
  //**** COLLECT STATS ON FEATURES ****
  //DYNAMIC FEATURES
  private Statistics RMS;
  private Statistics DynIndex;
  
  //TIMBRIC FEATURES
  private Statistics specCentroid;
  private Statistics specComplexity;
  private Statistics ZCR;
  
  //RHYTHMIC FEATURES
  private Statistics rhythmStr;
  private Statistics rhythmDens; 
    
  //**** HYSTERESIS CONTROLS ****
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
  
  private float[] featuresVector;
  private int[] statusVector;
  private final int FEATURES_NUMBER=6;
  
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
    
    
    featuresVector=new float[FEATURES_NUMBER];
    statusVector=new int[FEATURES_NUMBER];

   
    //STATS
    RMS=new Statistics(86); //2 seconds
    DynIndex=new Statistics(86);   
    specComplexity=new Statistics(86);
    specCentroid=new Statistics(86); 
    ZCR=new Statistics(86);   
    rhythmStr=new Statistics(172);
    rhythmDens=new Statistics(172);
 
    
    //HYSTERESIS
    RMSLowerBound=new Hysteresis(0.28,0.32,11); //check for 0.25 seconds
    RMSUpperBound=new Hysteresis(0.58,0.62,11);
    
    DynIndexLowerBound=new Hysteresis(0.09,0.11,11);
    DynIndexUpperBound=new Hysteresis(0.18,0.20,11);
    
    specCentroidLowerBound=new Hysteresis(1800,2200,11);
    specCentroidUpperBound=new Hysteresis(2800,3200,11);
    
    specComplexityLowerBound=new Hysteresis(9,11,11);
    specComplexityUpperBound=new Hysteresis(15,17,11);
    
    rhythmStrLowerBound=new Hysteresis(25,30,11);
    rhythmStrUpperBound=new Hysteresis(120,130,11);
    
    rhythmDensLowerBound=new Hysteresis(1,2,43);
    rhythmDensUpperBound=new Hysteresis(3.5,4.5,43);    
    
        
  }
  
  //idea: stabilisco delle soglie generali per capire lo stato della traccia in generale
  
  //aggiungo un controllo "interno" alla traccia
  //idea: se il valore istantaneo si discosta dalla media (5 secondo precedenti?) +/- la std dev calcolata sullo stesso intervallo
  //rileviamo un cambiamento
  
  //esempio: 
  /*
  if(timbre.getCentroid() > specCentroid.getAverage() + specCentroid.getStdDev()/2 || timbre.getCentroid() < specCentroid.getAverage() - specCentroid.getStdDev()/2)
  {
    println("SPECTRAL CETROID CHANGE");
  }
  */

  
  public int[] getStatusVector()
  {
    return statusVector;
  }
  
  public float[] getFeturesVector()
  {
    return featuresVector;
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
  
  public void run()
  {   
    if(dynamic.isSilence(-60) || !dynamic.isSilence(-50))
    { 
      collectStats();
      checkStatus();
    }
    
  }
  
  
  private void collectStats()
  {
    //DYN
    RMS.accumulate(dynamic.getRMS());
    DynIndex.accumulate(dynamic.getRMSStdDev());
    
    //TIMBRE
    specCentroid.accumulate(timbre.getCentroidHz());
    specComplexity.accumulate(timbre.getComplexity());
    ZCR.accumulate(timbre.getZeroCrossingRate());
    
    //RHYTHM
    rhythmStr.accumulate(rhythm.getRhythmStrength());
    rhythmDens.accumulate(rhythm.getRhythmDensity());
  }
  
  
  private void checkStatus()
  {
    checkRMSStatus();
    checkDynIndexStatus();
    checkCentroidStatus();
    checkComplexityStatus();
    //ZCR?
    checkRhythmStrStatus();
    checkRhythmDensStatus();
   
  }
  
  
  private void checkRMSStatus()
  {
    //CHECK RMS STATUS
    if(!RMSLowerBound.checkWindow(RMS.getAverage()) && !RMSUpperBound.checkWindow(RMS.getAverage()))
    {
      //RMS LOW
      RMSStatus=-1;
    }
    
    else if (RMSLowerBound.checkWindow(RMS.getAverage()) && !RMSUpperBound.checkWindow(RMS.getAverage()))
    {
      //RMS MEDIUM
      RMSStatus=0;
    }
  
    else if (RMSLowerBound.checkWindow(RMS.getAverage()) && RMSUpperBound.checkWindow(RMS.getAverage()))
    {
      //RMS HIGH
      RMSStatus=1;
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
      DynIndexStatus=-1;
    }
    
    else if (DynIndexLowerBound.checkWindow(DynIndex.getAverage()) && !DynIndexUpperBound.checkWindow(DynIndex.getAverage()))
    {
      //RMS MEDIUM
      DynIndexStatus=0;
    }
  
    else if (DynIndexLowerBound.checkWindow(DynIndex.getAverage()) && DynIndexUpperBound.checkWindow(DynIndex.getAverage()))
    {
      //RMS HIGH
      DynIndexStatus=1;
    }
    
    featuresVector[1]=DynIndex.getAverage();
    statusVector[1]=DynIndexStatus;
    
  }
  
  
 private void checkCentroidStatus()
 {   
    if(!specCentroidLowerBound.checkWindow(specCentroid.getAverage()) && !specCentroidUpperBound.checkWindow(specCentroid.getAverage()))
    {        
      //println("LOW");
      centroidStatus=-1;
    }
    
    else if (specCentroidLowerBound.checkWindow(specCentroid.getAverage()) && !specCentroidUpperBound.checkWindow(specCentroid.getAverage()))
    { 
      //println("MEDIUM");
      centroidStatus=0;
    }
  
    else if (specCentroidLowerBound.checkWindow(specCentroid.getAverage()) && specCentroidUpperBound.checkWindow(specCentroid.getAverage()) )
    {
     centroidStatus=1;
    }
   
   featuresVector[2]=specCentroid.getAverage();
   statusVector[2]=centroidStatus;
   
 }
  
 private void checkComplexityStatus()
 {
    
    if(!specComplexityLowerBound.checkWindow(specComplexity.getAverage()) && !specComplexityUpperBound.checkWindow(specComplexity.getAverage()))
    {        
      //println("LOW");
      complexityStatus=-1;
    }
    
    else if (specComplexityLowerBound.checkWindow(specComplexity.getAverage()) && !specComplexityUpperBound.checkWindow(specComplexity.getAverage()))
    { 
      //println("MEDIUM");
      complexityStatus=0;
    }
  
    else if (specComplexityLowerBound.checkWindow(specComplexity.getAverage()) && specComplexityUpperBound.checkWindow(specComplexity.getAverage()) )
    {
     complexityStatus=1;
    }
    
    featuresVector[3]=specComplexity.getAverage();
    statusVector[3]=complexityStatus;
  
 }
 
 
 private void checkRhythmStrStatus()
 {
    if(!rhythmStrLowerBound.checkWindow(rhythmStr.getAverage()) && !rhythmStrUpperBound.checkWindow(rhythmStr.getAverage()))
    {        
      //println("LOW");
      rhythmStrStatus=-1;
    }
    
    else if (rhythmStrLowerBound.checkWindow(rhythmStr.getAverage()) && !rhythmStrUpperBound.checkWindow(rhythmStr.getAverage()))
    { 
      //println("MEDIUM");
      rhythmStrStatus=0;
    }
  
    else if (rhythmStrLowerBound.checkWindow(rhythmStr.getAverage()) && rhythmStrUpperBound.checkWindow(rhythmStr.getAverage()) )
    {
     rhythmStrStatus=1;
    }
   
   featuresVector[4]=rhythmStr.getAverage();
   statusVector[4]=rhythmStrStatus;
 }
 
  private void checkRhythmDensStatus()
 {
    if(!rhythmDensLowerBound.checkWindow(rhythmDens.getAverage()) && !rhythmDensUpperBound.checkWindow(rhythmDens.getAverage()))
    {        
      //println("LOW");
      rhythmDensStatus=-1;
    }
    
    else if (rhythmDensLowerBound.checkWindow(rhythmDens.getAverage()) && !rhythmDensUpperBound.checkWindow(rhythmDens.getAverage()))
    { 
      //println("MEDIUM");
      rhythmDensStatus=0;
    }
  
    else if (rhythmDensLowerBound.checkWindow(rhythmDens.getAverage()) && rhythmDensUpperBound.checkWindow(rhythmDens.getAverage()) )
    {
     rhythmDensStatus=1;
    }
   
   featuresVector[5]=rhythmDens.getAverage();
   statusVector[5]=rhythmDensStatus;
 }
 
  
  private void checkChanges()
  { 
    if(timbre.getCentroidShortTimeAvgHz() > specCentroid.getAverage() + 1.5*specCentroid.getStdDev())
    {
       
       println("SPECTRAL CENTROID: "+ timbre.getCentroidHz()); 
       println("CENTROID STANRD DEV: "+specCentroid.getStdDev()); 
       println("SPECTRAL CETROID CHANGE UP");
    }  
    
    if(timbre.getCentroidShortTimeAvgHz() < specCentroid.getAverage() - 1.5*specCentroid.getStdDev())
    {
       
       println("SPECTRAL CENTROID: "+ timbre.getCentroidHz()); 
       println("CENTROID STANRD DEV: "+specCentroid.getStdDev()); 
       println("SPECTRAL CETROID CHANGE DOWN");
    }  
    
  }
  
  
  
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
  
  
  
}