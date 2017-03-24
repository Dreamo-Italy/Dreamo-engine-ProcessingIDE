class AudioDebug extends Scene
{
  
  float[] coefficients;
  
  public void init()
  {
    pal.initColors(1);
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    
    coefficients = new float[audio_proc.getSpecSize()];
  }
  
  public void update()
  {
    //if(frameCount%60 == 0) {
    for(int i = 0; i < audio_proc.getSpecSize(); i++)
    {
      coefficients[i]=audio_proc.getFFTcoeff(i);
    }
    //}
    
  }
  
  public void trace()
  {
    sceneBackground.trace();
    
    stroke(pal.getColor(3));
    strokeWeight(1);
    noFill();
    rectMode(CORNERS);
    rect(500,height-300,500+512*1.5,height-900);  
 
    text("Std Deviation: "+global_timbre.getCentroidStdDev(),120,85);
    text("Std Deviation: "+global_dyn.getRMSStdDev(),115,305);
    
    stroke(pal.getColor(2));
    strokeWeight(2);
    
    //draw spectrum
    for(int i = 0; i < audio_proc.getSpecSize()/3; i++)
    {
      //draw the line for frequency band i, scaling it up a bit so we can see it
      line(500+i*3, height-300, 500+i*3, height - 300 - coefficients[i]*5);
    }
    
    
   
    /*
    stroke(pal.getColor(3));
    //draw 1 second window samples
    if(global_rhythm.isProcessed()){
    for(int i = 0; i < global_rhythm.getLongWindowSize(); i++)
    {
      
      //draw the line for frequency band i, scaling it up a bit so we can see it
      line(i, height, i, height - global_rhythm.getLongWindowSamples(i)*500);
    }
    
    }
    */
    
  }
    
}