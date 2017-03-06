class Lissajous extends Scene
{
  public void init()
  {
    pal.initColors();
    LShape shape = new LShape();
    shape.setPalette(pal);
    shape.disablePhysics();
    addParticle(shape);
    
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