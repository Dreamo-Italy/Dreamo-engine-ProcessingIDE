class ScenePerlinNoise extends Scene
{
  void init()
  {
    final int row = 10;
    final int column = 11;
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
  
    public void update(){
    
   int alpha;
   //update with audio information
   alpha=(int)map(global_dyn.getRMS(),0,0.3,0,255);
      
   for(int i = 0; i < particlesNumber; i++)
     {
       particlesList[i].updatePhysics();
       particlesList[i].setAlpha(alpha);
       particlesList[i].update();
   }
    
    
  }
}
        
    