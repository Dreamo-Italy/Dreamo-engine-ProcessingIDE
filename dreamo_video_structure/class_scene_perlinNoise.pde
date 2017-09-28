class ScenePerlinNoise extends Scene 
{
 void init() 
 {
  pal.initColors();
  final int row = 10;
  final int column = 11;
  for (int i = 0; i < column; i++) 
  {
   for (int j = 0; j < row; j++) 
   {
    int x = FastMath.round(width / column * (i + 1));
    int y = FastMath.round(height / row * (j + 1));
    NoiseDot temp = new NoiseDot();
    temp.setPalette(pal);
    temp.setPosition(new Vector2d(x, y, false));
    addParticle(temp);
   }
  }
  setBackground(new Background());
  enableBackground();
 }

 public void update() 
 {
  colorFadeTo(new Palette(choosePaletteFromAudio()), 2, audio_decisor.getPaletteChange()); //choose warm or cold palette 

  for (int i = 0; i < particlesNumber; i++) 
  {
   particlesList[i].updatePhysics();
   particlesList[i].setPalette(this.pal);
   particlesList[i].setParameter(2, 1.5 * chooseThicknessFromAudio());
   particlesList[i].setParameter(3, 1200 / chooseVibrationFromAudio());
   particlesList[i].setParameter(4, 200 * chooseElasticityFromAudio());
   particlesList[i].update();
  }
 }
}