class Spirals extends Scene
{
  void init()
  {
    pal.initColors(4);
    SpiralParticle sp = new SpiralParticle();
    //sp.disablePhysics();
    sp.setPalette(pal);
    addParticle(sp);
 
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