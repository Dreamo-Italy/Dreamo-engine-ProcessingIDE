class CrazyL extends Scene
{

 CrazyLines C;

 public void init() 
 {
  pal.initColors();
  C = new CrazyLines(5);
  C.setPalette(pal);
  C.disablePhysics();
  C.setPosition(new Vector2d(width / 2, height / 2, false));
  addParticle(C);

  Background bk = new Background();
  setBackground(bk);
  enableBackground();
 }

 //trace and update methods
 public void update() 
 {

  for (int i = 0; i < particlesNumber; i++) 
  {
   particlesList[i].updatePhysics();
   particlesList[i].setPalette(this.pal);
   particlesList[i].update();
  }

  //**** COLOR CONTROLS   
  colorFadeTo(new Palette(choosePaletteFromAudio()), 2, audio_decisor.getPaletteChange()); //choose warm or cold palette    
  darkenColors(3, 30f, (audio_decisor.getCentroidChangeDir() == -1)); //control color brightness
  lightenColors(3, 50f, (audio_decisor.getCentroidChangeDir() == 1)); //control color brightness  
  desaturateColors(3, 20f, (audio_decisor.getComplexityChangeDir() == -1)); //control color saturation
  saturateColors(3, 60f, (audio_decisor.getComplexityChangeDir() == 1)); //control color saturation       
  colorFadeTo(new Palette(choosePaletteFromAudio()), 2, (audio_decisor.getChangesNumber() > 2)); //follow big changes

  //**** MOTION CONTROLS
  C.setElasticityCoeff(chooseElasticityFromAudio());
  C.setVibrationFreq(chooseVibrationFromAudio());
  C.setRotationCoeff(chooseRotationFromAudio());

  //**** SHAPE CONTROLS  
  C.setFormResolution((int) chooseResolutionFromAudio());
  C.setThickness(chooseThicknessFromAudio());
  C.setVibrationRange(chooseVibrationRangeFromAudio());
  
  println("AUDIO STATUS | " + audio_decisor.getStatusVector()[0] + " | " + audio_decisor.getStatusVector()[1] + " | " + audio_decisor.getStatusVector()[2] + " | " + audio_decisor.getStatusVector()[3] + " | " + audio_decisor.getStatusVector()[4] + " | " + audio_decisor.getStatusVector()[5]);

 }
}