class AudioDebug extends Scene
{
  
  float[] coefficients;
  float[] long_window;
  Hysteresis timbre_decisor;
  int init;
  color c;
  float ratioCoeff;
  float elasticCoeff;
  int articulationCoeff;
  float roughnessCoeff;
  float brightnessCoeff;
  
  
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
    
    //update coefficients
    ratioCoeff=global_dyn.getRMS();  
    elasticCoeff=global_dyn.getDynamicityIndex();
    articulationCoeff=1+(int)global_timbre.getComplexity()*50;
    brightnessCoeff=global_timbre.getCentroid();
    roughnessCoeff=global_timbre.getComplexity()+global_timbre.getCentroid();
    
    /*
    if(global_dyn.isSilence())
    {
      global_timbre.reset();
      pal.initColors();
    }
   */
   
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
    
    //**** AUDIO DATA FOR DIRECT ASSEGNATION
    //INSTANTANOUS VOL: global_dyn.getRMS();
    //DYNAMIC INDEX: global_dyn.getDynamicityIndex();
    //SPECTRAL CENTROID: global_timbre.getCentroid();
    //SPECTRAL COMPLEXITY: global_timbre.getComplexity(); //average is better? 
    
    
    //**** AUDIO DATA FOR TRIGGERING
    //SILENCE: global_dyn.isSilence(); //try different thresholds
    //DETECT DROP (?)
    //AVERAGE VOL: global_dyn.getRMSAvg();
    //CENTROID RELATIVE RATIO: global_timbre.getCentroidRelativeRatio();
   
    stroke(pal.getColor(3));
    strokeWeight(1);   
    //draw quadrant
     
   /* 
    int W=width/2;
    int H=height/2;
    
    c = lerpColor(pal.getDarkest(),pal.getLightest(),global_timbre.getCentroid());
    fill(c);
    if(global_dyn.isSilence()){noFill();}
    for(int i=0;i<articulationCoeff;i++)
    {
      ellipse(W+(50*i),H+(50*i),200+10*ratioCoeff,170+10*ratioCoeff);     
      //quad(W/3, H/4,  W/3+190, H/4+280,W/3+100, H/4+350, W/3+150, H/4+100);
    }
    
    */
    
   
    noFill();    
    //rectMode(CORNERS);   
    //rect(500,height-300,500+512*1.5,height-900);  
    text("Std Deviation: "+global_timbre.getCentroidStdDev(),120,105);
    text("Std Deviation: "+global_dyn.getRMSStdDev(),115,260);
    stroke(pal.getColor(2));
    strokeWeight(2);

    //draw spectrum
    for(int i = 0; i < audio_proc.getSpecSize()/2; i++)
    {
      //draw the line for frequency band i, scaling it up a bit so we can see it
      line(500+i*2, height, 500+i*2, height - coefficients[i]*5);
    }
    
    stroke(pal.getColor(4));
    line(500,height-global_timbre.getAvgMagnitude()*5,500+audio_proc.getSpecSize(),height-global_timbre.getAvgMagnitude()*5);
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
  
    
    //if(timbre_decisor.checkWindow(global_timbre.getCentroidRelativeRatio()))

      //drawEllipse(60, frameCount);
      
    
    
    
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