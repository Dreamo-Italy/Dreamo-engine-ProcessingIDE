class RadialDot extends Particle
{
  color colore = 255;
  int alfa;
  
  public void init()
  {
    //setSpeed(new Vector2d(1, random(TWO_PI), true));
    setPersistence(true);    // smoother transition from one scene to another
    setLifeTimeLeft(300);    // time left decreases each frame
   
   // int i = floor(random(3));
   
  // colore = questapalette.prendiColore( 4 ) 
   
  }
  
  public void update()
  {
    if(getPosition().getX()<0 || getPosition().getX()>width || getPosition().getY()<0 || getPosition().getY()>height)
    {
      instanceDestroy();
    }
  }
  
  public void trace()
  {
    noStroke();
    fill(colore);
    ellipse(-1, -1, 2, 2);
  }
}