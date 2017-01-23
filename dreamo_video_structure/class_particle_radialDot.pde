class RadialDot extends Particle
{
  color colore = 255;
  int alfa;
  private Vector2d gravityCenter;
  boolean destroying = false;
  float lastMouseX;
  float currentMouseX;
  
  public RadialDot()
  {
    gravityCenter = new Vector2d(0, 0, false);
  }
  
  public void setGravityCenter(Vector2d newGravityCenter)
  {
    gravityCenter = newGravityCenter;
  }
  
  public void perturbate(float intensity)
  {
    setSpeed(new Vector2d(random(intensity), random(TWO_PI), true)); 
  }
  
  public void init()
  {
    //setSpeed(new Vector2d(1, random(TWO_PI), true));
    setPersistence(true);    // smoother transition from one scene to another
    //setLifeTimeLeft(300);    // time left decreases each frame
   
    // int i = floor(random(3));
   
    // colore = questapalette.prendiColore( 4 ) 
   
    setPosition(new Vector2d(random(width), random(height), false));
    currentMouseX = mouseX;
    lastMouseX = currentMouseX;
  }
  
  public void update()
  {
    currentMouseX = mouseX;
    /*if(getPosition().getX()<0 || getPosition().getX()>width || getPosition().getY()<0 || getPosition().getY()>height)
    {
      instanceDestroy();
    }*/
    setGravity(new Vector2d(1, gravityCenter.subtract(getPosition()).getDirection(), true));
    
    getSpeed().setModulus(getSpeed().getModulus()/1.05); //THIS COMMAND SET THE DAMPING FACTOR (the more it is, the less particles orbitate)
    
    if(getSceneChanged() & !destroying)
    {
      destroying = true;
      setLifeTimeLeft(62);
    }
    
    Vector2d originGravityCenter = gravityCenter.subtract(new Vector2d(width/2, height/2, false));
    originGravityCenter.setDirection(originGravityCenter.getDirection() + TWO_PI*(lastMouseX - currentMouseX)/width);
    gravityCenter = originGravityCenter.sum(new Vector2d(width/2, height/2, false));
    lastMouseX = currentMouseX;
    
    if(frameCount%100 == 0) perturbate(20);
  }
  
  public void trace()
  {
  }
}