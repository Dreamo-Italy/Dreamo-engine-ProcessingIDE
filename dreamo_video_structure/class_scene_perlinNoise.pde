class ScenePerlinNoise extends Scene
{
  int change_col_number;
  int change_col_idx;
  int changed;

 void init()
 {
  pal.initColors();
  final int row = 10;
  final int column = 11;
  change_col_number = 7; // Specify how many particles change color at the same time (1-particlesNumber)
  change_col_idx = change_col_number; // Leave as it is.
  changed = 0;

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

  changed = 0;

  for (int i = 0; i < particlesNumber; i++)
  {
   particlesList[i].updatePhysics();
   particlesList[i].setPalette(this.pal);
   particlesList[i].setParameter(2, 1.5 * chooseThicknessFromAudio());
   particlesList[i].setParameter(3, 1200 / chooseVibrationFromAudio());
   particlesList[i].setParameter(4, 200 * chooseElasticityFromAudio());

   if ((audio_decisor.getChangesNumber() > 0) && (frameCount % 5 == 0 ))
   {
     if ((i < change_col_idx) && (i >= change_col_idx - change_col_number))
      {
          particlesList[i].toggleNextColor();
          changed++;
      }
      if (changed == change_col_number) // if enough particles changed color already
      {
        change_col_idx = change_col_idx + change_col_number;
        if (change_col_idx >= particlesNumber)
          {change_col_idx = change_col_number;}
      }
   }

   particlesList[i].update();
  }
 }
}
