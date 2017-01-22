class Dot extends Particle
{
  color colore;
  //Palette pal;

  public void init()
  {
    setSpeed(new Vector2d(5, random(TWO_PI), true));
    setGravity(new Vector2d(0, 0.001, false));
    setPersistence(true);    // smoother transition from one scene to another
    setLifeTimeLeft(300);    // time left decreases each frame

    colore=this.pal.getColor();
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
    //colorMode(HSB);
    noStroke();
    fill(colore);
    ellipse(-10, -10, 20, 20);
  }

  public void setPalette(Palette p)
  {
    pal=p;
  }
}
