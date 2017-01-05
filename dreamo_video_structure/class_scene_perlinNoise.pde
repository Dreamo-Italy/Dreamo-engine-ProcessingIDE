class ScenePerlinNoise extends Scene
{
  void init()
  {
    final int row = 30;
    final int column = 15;
    for(int i = 0; i < column; i++)
    {
      for(int j = 0; j < row; j++)
      {
        int x = round(width/column*(i+1));
        int y = round(height/row*(j+1));
        ParticleTracer temp = new ParticleTracer();
        temp.setPosition(new Vector2d(x, y, false));
        addParticle(temp);
      }
    }
    
    setBackground(new Background());
    enableBackground();
    
    setParameter(0, -200.0);
    setParameter(1, -300.0);
    setParameter(2, -400.0);
  }
}
        
    