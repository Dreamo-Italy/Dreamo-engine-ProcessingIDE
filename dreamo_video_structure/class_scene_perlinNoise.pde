class ScenePerlinNoise extends Scene
{
  
  // "little snake" 
  void init()
  {

    pal.initColors();

    final int row = 10;
    final int column = 11;
    
    for(int i = 0; i < column; i++)
    {
      for(int j = 0; j < row; j++)
      {
        int x = round(width/column*(i+1));
        int y = round(height/row*(j+1));
        
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
    
    for(int i = 0; i < particlesNumber; i++)
    {
      particlesList[i].updatePhysics();
      particlesList[i].setPalette(this.pal);
      particlesList[i].update();
    }
    
    //UPDATE CONTROL PARAMS
    
  }
  
}