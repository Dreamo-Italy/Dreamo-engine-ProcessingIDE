class ScenePresentation extends Scene
{
  private int change;
  private Hysteresis centroidControl;
  
  public void init()
  {
    pal.initColors(0);
    simpleLShape shape = new simpleLShape();
    
    shape.setPosition( new Vector2d(width/2,height/2,false) );
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
   
   colorFadeTo(new Palette(1),7,centroidControl.checkWindow(global_timbre.getCentroidAvg()));
   colorFadeTo(new Palette(4),7,!centroidControl.checkWindow(global_timbre.getCentroidAvg()));
   
   //println("HISTERESIS: "+centroidControl.check(global_timbre.getCentroidAvg()));
   for(int i = 0; i < particlesNumber; i++)
     {
       particlesList[i].updatePhysics();
       particlesList[i].setParameter(0,global_dyn.getRMSAvg());
       particlesList[i].setParameter(1, global_bioMood.getArousal() );
       particlesList[i].setPalette(this.pal);
       particlesList[i].update();
     }
  }

}