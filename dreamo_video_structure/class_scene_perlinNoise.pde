class ScenePerlinNoise extends Scene
{
  
  // "little snake" 
  void init()
  {

    pal.initColors(9);

    final int row = 10;
    final int column = 11;
    
    for(int i = 0; i < column; i++)
    {
      for(int j = 0; j < row; j++)
      {
        int x = round(width/column*(i+1));
        int y = round(height/row*(j+1));
        ParticleTracer temp = new ParticleTracer();
        temp.setPalette(pal);
        temp.setPosition(new Vector2d(x, y, false));
        addParticle(temp);
      }
    }

    setBackground(new Background());
    enableBackground();
    sceneMood.setMood(1,0);
  }

   public void update()
   {     
   for(int i = 0; i < particlesNumber; i++)
     {
       particlesList[i].updatePhysics();
       particlesList[i].setParameter(0,global_dyn.getRMS());
       particlesList[i].update();
   }
  }
  
}