class Cyclo1 extends Scene
{
  
  public void init()
  {
    pal.initColors(3);
    CycloParticle cp = new CycloParticle();
    cp.setPalette(pal);
    cp.disablePhysics();
    
    cp.setPosition(new Vector2d(-100, 0, false));

    CycloParticle cp2 = new CycloParticle();
    cp2.setPalette(pal);
    cp2.disablePhysics(); 
    cp2.setPosition(new Vector2d(+100, 0, false));

       
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