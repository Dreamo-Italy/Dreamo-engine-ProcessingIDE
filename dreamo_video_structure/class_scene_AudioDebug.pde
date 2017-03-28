class AudioDebug extends Scene
{
  
  float[] coefficients;
  float[] long_window;
  Hysteresis timbre_decisor;
  int init;
  
  public void init()
  {
    
    pal.initColors(1);
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    
    coefficients = new float[audio_proc.getSpecSize()];
    long_window = new float[global_rhythm.getLongWindowMaxSize()];
    
    timbre_decisor=new Hysteresis(0.8,0.9,4);
  }
  
  
  public void update()
  {
   
    for(int i = 0; i < audio_proc.getSpecSize(); i++)
    {
      coefficients[i]=audio_proc.getFFTcoeff(i);
    }
        
    if(frameCount%30==0)
    {
      if(global_rhythm.isProcessed())
      {
        for(int i = 0; i < global_rhythm.getLongWindowMaxSize(); i++)
        {
        long_window[i]=global_rhythm.getLongWindowSamples(i);
        }
       }
    }
  }
  
  public void trace()
  {
    
    sceneBackground.trace();
    stroke(pal.getColor(3));
    strokeWeight(1);
    noFill();    
    rectMode(CORNERS);   
    rect(500,height-300,500+512*1.5,height-900);  
    text("Std Deviation: "+global_timbre.getCentroidStdDev(),120,105);
    text("Std Deviation: "+global_dyn.getRMSStdDev(),115,260);
    stroke(pal.getColor(2));
    strokeWeight(2);

    //draw spectrum
    for(int i = 0; i < audio_proc.getSpecSize()/3; i++)
    {
      //draw the line for frequency band i, scaling it up a bit so we can see it
      line(500+i*3, height-300, 500+i*3, height - 300 - coefficients[i]*5);
    }
    
    stroke(pal.getColor(4));
    line(500,height-300-global_timbre.getAvgMagnitude()*5,500+audio_proc.getSpecSize()/3*3,height-300-global_timbre.getAvgMagnitude()*5);
    println("AVG SPECTRUM MAGNITUDE: "+global_timbre.getAvgMagnitude()*5);
   /*
   stroke(pal.getColor(3));
   //draw 1 second window samples
   for(int i = 0; i < long_window.length; i++)
   {      
     line(180+i*0.01, height-100, 180+i*0.01, height-100 - long_window[i]*200);
   } */
   /*
   if(global_rhythm.isPercOnset())
   {
     fill(pal.getColor(1));
     ellipse(width/2,height/2,200,200);
   }
    
  */
  
    if(timbre_decisor.checkWindow(global_timbre.getCentroidDynamicRatio()))
    {
      
      drawEllipse(60, frameCount);
      
    }
    
    
  }
  
  void drawEllipse(int frames, int init)
  {
    //float init=frameCount;
    if(frameCount-init<frames)
    {
      fill(pal.getColor(1));
      ellipse(width/2,height/2,200,200);
    }
  }

  
}