class Lissajous extends Scene
{
  private boolean change;
  
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
    
    change=false;
  }
  
  
  public void update()
  {
   if(global_timbre.getCentroidAvg()>2900)
   {
     change=true;
   }
   
   if(change) {colorFadeTo(new Palette(1),35);}
   
   for(int i = 0; i < particlesNumber; i++)
     {
       particlesList[i].updatePhysics();
       particlesList[i].setParameter(0,global_dyn.getRMS());
       particlesList[i].setPalette(this.pal);
       particlesList[i].update();
     }
  }

}