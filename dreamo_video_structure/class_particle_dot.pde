class Dot extends Particle
{
  color colore;
  public void init()
  {
    setSpeed(new Vector2d(5, random(TWO_PI), true));
    setGravity(new Vector2d(0, 0.1, false));
    setPersistence(true);    // smoother transition from one scene to another
    setLifeTimeLeft(300);    // time left decreases each frame
   
   int i = floor(random(3));
   
  // colore = questapalette.prendiColore( 4 ) 
   
   
   switch(i)
   {
     case 0: 
       colore = color(255, 0, 0);
       break;
     case 1:
       colore = color(0, 255, 0);
       break;
     case 2:
       colore = color(0, 0, 255);
       break;
     default:
       colore = color(255);
    }
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
    ellipse(-10, -10, 20, 20);
  }
}