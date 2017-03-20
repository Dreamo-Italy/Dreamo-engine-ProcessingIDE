class SceneDynamicGrid extends Scene
{
  void init()
  {
    pal.initColors();

    GridPlotter grid1 = new GridPlotter();
    grid1.setPalette(pal);
    
    addParticle(grid1 );
    setBackground(new Background());
    enableBackground();
        
    sceneMood.setMood(-0.8,0.6);
    
  }
  
  void update()
  {
    for(int i = 0; i < particlesNumber; i++)
     {
       particlesList[i].updatePhysics();
       particlesList[i].setParameter(0,global_dyn.getRMS());
       //particlesList[i].setParameter(1,global_dyn.getAvgRMS());
       particlesList[i].setParameter(2,global_gsr.getAbsolute() );
       particlesList[i].update();
     }
  }
}