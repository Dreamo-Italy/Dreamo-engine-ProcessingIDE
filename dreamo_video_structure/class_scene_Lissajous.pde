class Lissajous extends Scene
{
  private int change;
  private Hysteresis centroidControl;
  
  public void init()
  {
    pal.initColors(0);
    LShape shape = new LShape();
    shape.setPalette(pal);
    shape.disablePhysics();
    addParticle(shape);
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    sceneMood.setMood(0,1);
    
    centroidControl = new Hysteresis(4000,6000);
    
  }
  
  
  public void update()
  {
    
   //example of usage
   //TODO: implement histeresis cycle to change status
   //TODO: implement reliable decision algorithm (na parola)
   //change=histeresis(global_timbre.getCentroidAvg(),4000,5000);
   if(centroidControl.check(global_timbre.getCentroidAvg())) {colorFadeTo(new Palette(1),10);}
   else if (!centroidControl.check(global_timbre.getCentroidAvg())) {colorFadeTo(new Palette(4),10);}
   
   for(int i = 0; i < particlesNumber; i++)
     {
       particlesList[i].updatePhysics();
       particlesList[i].setParameter(0,global_dyn.getRMS());
       particlesList[i].setPalette(this.pal);
       particlesList[i].update();
     }
  }

}