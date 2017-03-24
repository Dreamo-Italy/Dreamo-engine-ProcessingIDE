class BioMood 
{
  private float [] arousal;
  //private float arousalTot;
  
  //default constructor
  public BioMood()
  {
    arousal = new float[global_sensorNumber];
  }
  
  //copy constructor
  public BioMood(BioMood toCopy)
  {
    for(int i=0; i<global_sensorNumber;i++)
      arousal[i]= toCopy.arousal[i];  
  }
  
  public void update()
  {
    if( !global_gsr.isCalibrating() && !global_ecg.isCalibrating() )
    {
      arousal[0] = computeGsrArousal();
      arousal[1] = computeEcgArousal();
    }
    
    println("gsr arousal: "+arousal[0]);
    println("ecg arousal: "+arousal[1]);
    
  }
  
  private float computeGsrArousal()
  {
    float absAr, varAr, gsrArousal;
    
    absAr = computeAbsoluteGsrArousal();
    varAr = computeVariationGsrArousal();
    
    gsrArousal = ( absAr + varAr )/2;
    
    return gsrArousal;       
  }
  
  private float computeAbsoluteGsrArousal()
  {
    float absAr=0;
    
    absAr = global_gsr.getAbsolute();
    absAr = map(absAr, 0.2, 1, 0, 1);
    
    if (absAr < 0) absAr = 0;
    else if (absAr > 1) absAr = 1;
    
    return absAr;    
  }
  
  private float computeVariationGsrArousal()
  {
    float varAr=0;
    
    varAr = global_gsr.getVariation();
    
    // GalvanicSkinResponse "variation" range: 0.8 (relaxed), 5 (excited)
    varAr = map(varAr, 0.8, 5, 0, 1);
    
    if(varAr<0) varAr = 0;
    else if(varAr > 1) varAr = 1;
    
    return varAr;    
  }
  
  private float computeEcgArousal()
  {
    float ecgAr = global_ecg.getBpm();
    ecgAr = map(ecgAr, 40, 120, 0, 1);
    
    if(ecgAr<0) ecgAr = 0;
    else if(ecgAr > 1) ecgAr = 1;
    
    return ecgAr;
  }
  
  
  public float [] getArousal()
  {
    return arousal;
  }

}