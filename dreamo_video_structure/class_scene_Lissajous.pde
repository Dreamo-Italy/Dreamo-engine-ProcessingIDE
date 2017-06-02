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
    
    centroidControl = new Hysteresis(2950,3200,16);
    
  }
  
  
  public void update()
  {
    
   //example of usage
   //TODO: implement histeresis cycle to change status
   //TODO: implement reliable decision algorithm (na parola) 
   
   colorFadeTo(new Palette(4),7,centroidControl.checkWindow(global_timbre.getCentroidAvg()));
   colorFadeTo(new Palette(7),7,!centroidControl.checkWindow(global_timbre.getCentroidAvg()));
   
   //println("HISTERESIS: "+centroidControl.check(global_timbre.getCentroidAvg()));
   for(int i = 0; i < particlesNumber; i++)
     {
       particlesList[i].updatePhysics();
       particlesList[i].setParameter(0,global_dyn.getRMS());
       particlesList[i].setPalette(this.pal);
       particlesList[i].update();
     }
  }

}