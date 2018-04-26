class CrazyL extends Scene
{
  
  CrazyLines C;
  
  public void init()
  {
    pal.initColors("cold");
    C = new CrazyLines(5);
    C.setPalette(pal);
    C.disablePhysics();
    C.setPosition(new Vector2d(width/2, height/2, false));
    addParticle(C);   
    /*
    CrazyLines C2 = new CrazyLines(7);
    C2.setRotation(50);
    C2.setPalette(pal);
    C2.disablePhysics();
    addParticle(C2);
    */   
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    sceneMood.setMood(0,1);

  }
  
  //trace and update methods
  public void update()
  {
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
    
    //**** COLOR CONTROLS
    //choose warm or cold palette
    colorFadeTo(new Palette(choosePaletteFromAudio()),2,audio_decisor.getColorChange()); 
    //println(audio_decisor.getColorChange());
    
    //control color brightness
    darkenColors(3,30f, (audio_decisor.getCentroidChangeDir()==-1));
    lightenColors(3,50f, (audio_decisor.getCentroidChangeDir()==1));
    
    //control color saturation
    desaturateColors(3,20f,(audio_decisor.getComplexityChangeDir()==-1));
    saturateColors(3,50f,(audio_decisor.getComplexityChangeDir()==1));
    
    //follow big changes
    colorFadeTo(new Palette(choosePaletteFromAudio()),2,(audio_decisor.getChangesNumber()>2));
    //if(audio_decisor.getChangesNumber()>2) {C.randomizeShape();}
    
    
    //println(chooseMusicPalette());
    
    C.setElasticityCoeff(chooseElasticityFromAudio());
    C.setVibrationFreq(chooseVibrationFromAudio());
    //println("ELASTICITY: "+chooseMusicElasticity());
    //SHAPE CONTROLS    
    C.setFormResolution((int)chooseResolutionFromAudio());
    C.setThickness(chooseThicknessFromAudio());
    C.setVibrationRange(chooseVibrationRangeFromAudio());
    C.setRotationCoeff(chooseRotationFromAudio());
    
    println(chooseRotationFromAudio());
    /*println("THICK: "+chooseThicknessFromAudio());
    println("RANGE: "+chooseVibrationRangeFromAudio());
    println("FREQ: "+ chooseVibrationFromAudio());
    */
    
    println("AUDIO STATUS | "+audioStatus[0]+" | "+audioStatus[1]+" | "+audioStatus[2]+" | "+audioStatus[3]+" | "+audioStatus[4]+" | "+audioStatus[5]);
    
  }
  

}
