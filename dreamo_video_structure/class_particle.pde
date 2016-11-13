//*************************************************
// class Particle
// last modified: 12/11/16
//
//**************************************************

import java.util.Comparator;

abstract class Particle
{
  //PRIVATE MEMBERS
  private Vector position;
  private Vector speed;
  private Vector gravity;
  private Vector rotation;
  private int depth;
  private int lifeTime;
  
  private long id;
  private boolean destroy;
  
  //CONTRUCTORS  
  public Particle()
  {
    position = new Vector(0, 0, false);
    speed = new Vector(0, 0, false);
    gravity = new Vector(0, 0, false);
    rotation = new Vector(1, 0, true); 
    depth = 0;
    lifeTime = -1;
    
    id = global_particlesInstanciatedNumber;
    global_particlesInstanciatedNumber++;
    global_particlesCount++;
    destroy = false;
  }
  
  public Particle(int newDepth)
  {
    position = new Vector(0, 0, false);
    speed = new Vector(0, 0, false);
    gravity = new Vector(0, 0, false);
    rotation = new Vector(1, 0, true); 
    depth = newDepth;
    lifeTime = -1;
    
    id = global_particlesInstanciatedNumber;
    global_particlesInstanciatedNumber++;
    global_particlesCount++;
    destroy = false;
  }
  //copy constructor
  public Particle(Particle toCopy)
  {
    position = new Vector(toCopy.position);
    speed = new Vector(toCopy.speed);
    gravity = new Vector(toCopy.gravity);
    rotation = new Vector(toCopy.rotation);
    depth = toCopy.depth;
    lifeTime = -1;
    
    id = global_particlesInstanciatedNumber;
    global_particlesInstanciatedNumber++;
    global_particlesCount++;
    destroy = false;
  }
  
  //PUBLIC METHODS
  //get methods
  public Vector getPosition()
  {
    return position;
  }
  
  public Vector getSpeed()
  {
    return speed;
  }
  
  public Vector getGravity()
  {
    return gravity;
  }
  
  public float getRotation()
  {
    return rotation.getDirection();
  }
  
  public int getDepth()
  {
    return depth;
  }
  
  public long getId()
  {
    return id;
  }
  
  public int getLifeTime()
  {
    return lifeTime;
  }
  
  //set methods  
  public void setPosition(Vector newPosition)
  {
    position = new Vector(newPosition);
  }
  
  public void setSpeed(Vector newSpeed)
  {
    speed = new Vector(newSpeed);
  }
  
  public void setGravity(Vector newGravity)
  {
    gravity = new Vector(newGravity); 
  }
  
  public void setRotation(float newRotation)
  {
    rotation = new Vector(1, newRotation, true);
  }
  
  public void setDepth(int newDepth)
  {
    depth = newDepth;
  }
  
  public void setLifeTime(int newLifeTime)
  {
    lifeTime = newLifeTime;
  }
  
  //apply transoformations method
  public void beginTransformations()
  {
    pushMatrix();
    position.applyTranslation();
    rotation.applyRotation();
  }
  
  public void endTransformations()
  {
    popMatrix();
  }
  
  //destruction
  public void instanceDestroy()
  {
    destroy = true;
  }
  
  public boolean isToBeDestroyed()
  {
    return destroy;
  }
  
  //update and trace methods
  public void updatePhysics()
  {
    //spacial variables update
    position = position.sum(speed);
    speed = speed.sum(gravity);
    
    //life variables update
    if(lifeTime > 0)
    {
      lifeTime--;
      if(lifeTime == 0)
      {
        instanceDestroy();
      }
    }
  }
  
  public abstract void init();
  public abstract void update();
  public abstract void trace();
}

class ParticleComparator implements Comparator<Particle>
{
  //sort particles by depth -> minor depth means that the particle has to be drawn before
  
  public int compare(Particle A, Particle B)
  {
    if(A == null && B == null) return 0;
    if(A == null) return 1;
    if(B == null) return -1;
    return A.depth - B.depth;
  }
  
  public boolean equals(Particle A, Particle B)
  {
    if(A == null && B == null) return true;
    if(A == null) return false;
    if(B == null) return false;
    return A.depth == B.depth;
  }
}