class Cyclo1 extends Scene
{
  
  public void init()
  {
    pal.initColors(3);
    CycloParticle cp = new CycloParticle();
    cp.setPalette(pal);
    cp.disablePhysics();
    
    CycloParticle cp2 = new CycloParticle();
    cp2.setPalette(pal);
    cp2.disablePhysics(); 
    cp2.setPosition(new Vector2d(width/5, height/5, false));
       
    addParticle(cp);
    addParticle(cp2);
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
  }
  
  /*public void update()
  {
    //update particles with music and sensors data
  }*/

  
}