class Line extends Particle
{
  color colore;
  float alpha;
  
  public void init()
  {
    setSpeed(new Vector2d(2, frameCount/4.111*TWO_PI, true) ); // speed changes
    setPersistence(true); // keep the particle alive after a scene change
    setLifeTimeLeft(300);
    colore=pal.getColor();
    alpha = 100.0;

  }
  
  public void update()
  {
    setRotation(getRotation() + PI/30); // current angle = current angle + a little slice
    if(getPosition().getX()<0 || getPosition().getX()>width || getPosition().getY()<0 || getPosition().getY()>height)
    {
      instanceDestroy();
    }
    if(getSceneChanged() & !isDestroying() )
    {
      assertDestroying();
      setLifeTimeLeft(310);
    }
    if( isDestroying() )
    {
      alpha -= 1.0;
    }
  }
  
  public void trace()
  {
    noFill();
    stroke(colore, alpha);
    strokeWeight(3);
    line(0, 32, 22, 0); // relative values : the new origin (0,0) is set by pushMatrix at each frame
  }
}