class AudioDecisor
{
  
  private Hysteresis centroid;
  private Hysteresis centroid_relative;
  private Hysteresis complexity; 
  
  private Hysteresis rms;
  private Hysteresis dinamicity;
  private Hysteresis rmsSlope;
  
  private float clarity;
  private float agitation;
  private float energy;
  private float roughness;
  
  
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
    
  AudioDecisor()
  {
    centroid = new Hysteresis(43); //1 sec
    centroid_relative = new Hysteresis(5);
    complexity = new Hysteresis(43);
    
    rms = new Hysteresis(43);
    rmsSlope = new Hysteresis(2);
    dinamicity  = new Hysteresis(43); 
    
    
    
  }
  
  
  //centroid.checkWindow(global_timbre.getCentroid(), __ , __ );
  
  //centroid_relative.checkWindow(global_timbre.getCentroidRelativeRatio(), __ , __ ,  );
  
  //complexity.checkWindow(global_timbre.getComplexityAvg(), __ , __ , );
  
  //rms.checkWindow(global_dyn.getRMS(), __ , __ ); 
  
  //dinamicity.chekWindow(global_dyn.getDynamicityIndex(), __ , __ );
  
  
  public void run()
  {
    
    calcClarity();
    
    calcEnergy();
    
    calcAgitation();
    
    calcRoughness();
    
  }
  
  
  private void calcClarity()
  {
    //spectral centroid
    //rms
  }
  
  
  private void calcEnergy()
  {
    //dinamicity
    //
  }
  
  private void calcAgitation()
  {
  }
  
  private void calcRoughness()
  {
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