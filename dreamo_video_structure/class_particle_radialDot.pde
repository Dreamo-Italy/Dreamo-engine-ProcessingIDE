class RadialDot extends Particle
{
  int alfa;
  private Vector2d gravityCenter;
  boolean destroying;
  float gravityRotation;
  boolean intro;
  
  float damping;

  
  public RadialDot()
  {
    gravityCenter = new Vector2d(0, 0, true);
    gravityRotation = 0;
    damping = 1.04;
    destroying = false;
    intro = true;
  }
  
  public void setDamping(float newDamping)
  {
    damping = map(newDamping, 0, 10, 1.0, 1.5);
  }
  
  public void setGravityCenter(Vector2d newGravityCenter)
  {
    gravityCenter = newGravityCenter;
  }
  
  public void setIntro(boolean introduction)
  {
    intro = introduction;
  }
  
  public void perturbate(float intensity)
  {
    //Vector2d speed = getSpeed().mul(random(intensity));
    //setSpeed(speed);
    setSpeed(new Vector2d(random(intensity), random(TWO_PI), true)); 
  }
  
  public void init()
  {
    //setSpeed(new Vector2d(1, random(TWO_PI), true));
    setPersistence(true);    // smoother transition from one scene to another
   
    if (round(random(1)) == 1) setPosition(new Vector2d(width, height, false));
    else if ( ceil(random(2)) == 2)  setPosition(new Vector2d(width, 0, false) );
    else if ( ceil(random(3)) == 3)  setPosition(new Vector2d(0, height, false) );
  }
  
  public void update()
  {
    if(intro){
      if( gravityRotation == 0 || getParameter(0) > 0.4) 
        {gravityRotation = 0;}
    }
    else if(!intro){
      if( getParameter(0) > 0.2)
        {gravityRotation = 100;}
    }
      
    setGravity(new Vector2d(1, gravityCenter.subtract(getPosition()).getDirection(), true));
    
    getSpeed().setModulus(getSpeed().getModulus()/damping); //DAMPING FACTOR : the more it is, the less particles orbitate
    
    if(getSceneChanged() & !destroying)
    {
      destroying = true;
      setLifeTimeLeft(62);
    }
    
    Vector2d originGravityCenter = gravityCenter.subtract(new Vector2d(width/2, height/2, false)); 
    
    originGravityCenter.setDirection(originGravityCenter.getDirection() + TWO_PI*(gravityRotation/360) );
    
    gravityCenter = originGravityCenter.sum(new Vector2d(width/2, height/2, false));
  }
  
  public void trace()
  {
  }
}