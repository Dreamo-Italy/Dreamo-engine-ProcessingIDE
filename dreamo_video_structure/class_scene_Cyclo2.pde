class Cyclo2 extends Scene
{
  
  public void init()
  {
    pal.initColors(1);
    CycloParticle2 cp = new CycloParticle2();
    cp.setPalette(pal);
    cp.disablePhysics();
    cp.setPosition(new Vector2d(width/2, height/2, false));

    
    addParticle(cp);

    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
  }
  
  /*public void update()
  {
    //update particles with music and sensors data
  }*/

  
}