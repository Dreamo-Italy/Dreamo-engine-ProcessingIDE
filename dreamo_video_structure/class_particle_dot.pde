class Dot extends Particle
{
  color colore;
  
  public void init()
  {
    setSpeed(new Vector2d(3, random(TWO_PI), true));
    setGravity(new Vector2d(0, 0.007, false));
    setPersistence(true);    // smoother transition from one scene to another
    setLifeTimeLeft(300);    // time left decreases each frame     
   
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
    ellipse(0, 0, 7, 7);
    
  }

  public void setPalette(Palette p)
  {
    pal=p;
  }
  
  
}