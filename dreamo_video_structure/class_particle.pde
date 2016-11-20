import java.util.Comparator;

//package dreamo.display;

abstract class Particle extends AgingObject
{
  //PRIVATE MEMBERS
  private Vector2d position;
  private Vector2d speed;
  private Vector2d gravity;
  private Vector2d rotation;
  private int depth;
  
  private long id;
  private boolean destroy;
  
  private boolean persistent;
  private boolean initialised;
  
  //CONTRUCTORS  
  public Particle()
  {
    position = new Vector2d(0, 0, false);
    speed = new Vector2d(0, 0, false);
    gravity = new Vector2d(0, 0, false);
    rotation = new Vector2d(1, 0, true); 
    depth = 0;
  
    persistent = false;
    initialised = false;
    
    id = global_particlesInstanciatedNumber;
    global_particlesInstanciatedNumber++;
    global_particlesCount++;
    destroy = false;
  }
  
  //copy constructor
  public Particle(Particle toCopy)
  {
    position = new Vector2d(toCopy.position);
    speed = new Vector2d(toCopy.speed);
    gravity = new Vector2d(toCopy.gravity);
    rotation = new Vector2d(toCopy.rotation);
    depth = toCopy.depth;
    
    persistent = toCopy.persistent;
    initialised = false;
    
    id = global_particlesInstanciatedNumber;
    global_particlesInstanciatedNumber++;
    global_particlesCount++;
    destroy = false;
  }
  
  //PUBLIC METHODS
  //get methods
  public Vector2d getPosition()
  {
    return position;
  }
  
  public Vector2d getSpeed()
  {
    return speed;
  }
  
  public Vector2d getGravity()
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
  
  public boolean getPersistence()
  {
    return persistent;
  }
  
  boolean getInitialised()
  {
    return initialised;
  }
  
  //set methods  
  public void setPosition(Vector2d newPosition)
  {
    position = new Vector2d(newPosition);
  }
  
  public void setSpeed(Vector2d newSpeed)
  {
    speed = new Vector2d(newSpeed);
  }
  
  public void setGravity(Vector2d newGravity)
  {
    gravity = new Vector2d(newGravity); 
  }
  
  public void setRotation(float newRotation)
  {
    rotation = new Vector2d(1, newRotation, true);
  }
  
  public void setDepth(int newDepth)
  {
    depth = newDepth;
  }
  
  public void setPersistence(boolean newPersistent)
  {
    persistent = newPersistent;
  }
  
  void assertInitialised()
  {
    initialised = true;
  }
  
  //apply transformations method
  void beginTransformations()
  {
    pushMatrix();
    position.applyTranslation();
    rotation.applyRotation();
  }
  
  void endTransformations()
  {
    popMatrix();
  }
  
  //destruction
  public void instanceDestroy()
  {
    destroy = true;
  }
  
  boolean isToBeDestroyed()
  {
    return destroy;
  }
  
  //update and trace methods
  void updatePhysics()
  {
    //spacial variables update
    position = position.sum(speed);
    speed = speed.sum(gravity);
    
    //life variables update
    updateTime();
    if(getLifeTimeIsUp())
    {
      instanceDestroy();
    }
  }
  
  abstract void init();
  abstract void update();
  abstract void trace();
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