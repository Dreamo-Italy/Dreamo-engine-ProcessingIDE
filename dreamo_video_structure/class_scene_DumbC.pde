class DumbC extends Scene
{
  public void init()
  {
    pal.initColors();
    DumbCircle dc = new DumbCircle();
    dc.setPalette(pal);
    dc.disablePhysics();
    addParticle(dc);
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    sceneMood.setMood(0,1);
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