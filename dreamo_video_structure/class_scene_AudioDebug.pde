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
  int[] audioStatus;
  float[] audioFeatures;
  
  
  public void init()
  {
    
    pal.initColors();
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    
    coefficients = new float[audio_proc.getSpecSize()];
    //long_window = new float[global_rhythm.getLongWindowMaxSize()];
    
    timbre_decisor=new Hysteresis(0.8,0.9,4);
    
    
  }
  
  
  public void update()
  {
     
    for(int i = 0; i < audio_proc.getSpecSize(); i++)
    {
      coefficients[i]=audio_proc.getFFTcoeff(i);
    }
    
    audioStatus=audio_decisor.getStatusVector();
    audioFeatures=audio_decisor.getFeturesVector();
    
  }
  
  public void trace()
  {
    sceneBackground.trace();
    
   
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
    fill(pal.getColor(1));
    int dist=250;
    int l=450;
    textSize(23);
    text("RMS ||| "+audioFeatures[0],width/4,height/4); text("||| "+audioStatus[0],width/4+l,height/4);
    text("DYN INDEX ||| "+audioFeatures[1],width/4,height/4+dist/6);text("||| "+audioStatus[1],width/4+l,height/4+dist/6);
    text("CENTROID ||| "+audioFeatures[2],width/4,height/4+dist/6*2);text("||| "+audioStatus[2],width/4+l,height/4+dist/6*2);
    text("COMPLEXITY ||| "+audioFeatures[3],width/4,height/4+dist/6*3);text("||| "+audioStatus[3],width/4+l,height/4+dist/6*3);
    text("RHYTHM STREGNGTH ||| "+audioFeatures[4],width/4,height/4+dist/6*4);text("||| "+audioStatus[4],width/4+l,height/4+dist/6*4);
    text("RHYTHM DENSITY ||| "+audioFeatures[5],width/4,height/4+dist/6*5);text("||| "+audioStatus[5],width/4+l,height/4+dist/6*5);
    
   
    noFill();    
    //rectMode(CORNERS);   
    //rect(500,height-300,500+512*1.5,height-900);  
    //text("Centroid Std Deviation: "+global_timbre.getCentroidStdDev(),120,105);
    //text("RMS Std Deviation: "+global_dyn.getRMSStdDev(),115,260);
    stroke(pal.getColor(2));
    strokeWeight(1);

    
    //draw spectrum
    for(int i = 0; i < audio_proc.getSpecSize(); i++)
    {
      //draw the line for frequency band i, scaling it up a bit so we can see it
      line(500+i, height, 500+i, height - coefficients[i]*5);
    }
    
    stroke(pal.getColor(4));
    line(500,height-global_timbre.getAvgMagnitude()*global_timbre.getMagnitudeThreshold(),500+audio_proc.getSpecSize(),height-global_timbre.getAvgMagnitude()*global_timbre.getMagnitudeThreshold());
    //text("AVG SPECTRUM MAGNITUDE: "+global_timbre.getAvgMagnitude(),width/2,height/2);
      
   
   //draw onsets
   if(global_rhythm.isEnergyOnset())
   {
     fill(pal.getColor(1));
     ellipse(width/4+150+l,height/4+dist/6*2,100,100);
   }
        
    textSize(12);
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