class CrazyL extends Scene
{
  public void init()
  {
    pal.initColors("cold");
    CrazyLines C = new CrazyLines(5);
    C.setPalette(pal);
    C.disablePhysics();
    addParticle(C);
    
    
    CrazyLines C2 = new CrazyLines(3);
    C2.setRotation(50);
    C2.setPalette(pal);
    C2.disablePhysics();
    addParticle(C2);
    
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    sceneMood.setMood(0,1);

  }
  
  //trace and update methods
  public void update()
  {
      
    //**** COLOR CONTROLS
    //choose warm or cold palette
    colorFadeTo(new Palette(chooseMusicPalette()),2,audio_decisor.getColorChange()); 
    //println(audio_decisor.getColorChange());
    
    //control color brightness
    darkenColors(3,30f, (audio_decisor.getCentroidChangeDir()==-1));
    lightenColors(3,50f, (audio_decisor.getCentroidChangeDir()==1));
    
    //control color saturation
    desaturateColors(3,20f,(audio_decisor.getComplexityChangeDir()==-1));
    saturateColors(3,50f,(audio_decisor.getComplexityChangeDir()==1));
    
    //follow big changes
    colorFadeTo(new Palette(chooseMusicPalette()),2,(audio_decisor.getChangesNumber()>2));
    
    //println(chooseMusicPalette());
    
    //update audio parameter
    instantFeatures=audio_decisor.getInstantFeatures();
    audioFeatures=audio_decisor.getFeturesVector();
    audioStatus=audio_decisor.getStatusVector();
    
    for(int i = 0; i < particlesNumber; i++)
    {
      particlesList[i].updatePhysics();
      particlesList[i].updateAudio(instantFeatures,audioFeatures,audioStatus);
      particlesList[i].setPalette(this.pal);
      particlesList[i].update();
    }
    

    //println("COMPLEXITY STATUS: "+audioStatus[3]);
    
    /*
    int l=10;
    text("||| "+audioStatus[0],width/2,height-50);
    text("||| "+audioStatus[1],width/2+l,height-50);
    text("||| "+audioStatus[2],width/2+2*l,height-50);
    text("||| "+audioStatus[3],width/2+3*l,height-50);
    text("||| "+audioStatus[4],width/2+4*l,height-50);
    text("||| "+audioStatus[5],width/2+5*l,height-50);   
    */
  }
  

}