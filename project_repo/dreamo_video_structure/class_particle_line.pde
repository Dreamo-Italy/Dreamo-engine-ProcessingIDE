class Line extends Particle
{
  color colore;
  
  public void init()
  {
    setSpeed(new Vector2d(2, frameCount/60.0*TWO_PI, true) ); // speed changes
    setPersistence(true); // keep the particle alive after a scene change
    setLifeTimeLeft(100);

    int i = floor(random(3));
    switch(i)
    {
      case 0: 
        colore = color(130, 255, 0);
        break;
      case 1:
        colore = color(0, 255, 100);
        break;
      case 2:
        colore = color(230, 0, 255);
        break;
      default:
        colore = color(200, 80, 80);
    }
  }
  
  public void update()
  {
    setRotation(getRotation() + PI/30); // current angle = current angle + a little slice
    if(getPosition().getX()<0 || getPosition().getX()>width || getPosition().getY()<0 || getPosition().getY()>height)
    {
      instanceDestroy();
    }
  }
  
  public void trace()
  {
    noFill();
    stroke(colore);
    strokeWeight(3);
    line(-8, 0, 8, 0); // relative values : the new origin (0,0) is set by pushMatrix at each frame
  }
}