import java.util.Comparator;

//package dreamo.display;

abstract class Particle extends AgingObject
{
  //CONSTANTS
  public final int PARAMETERS_NUMBER = 5;
    
  //PRIVATE MEMBERS
  private Vector2d position;
  private Vector2d speed;
  private Vector2d gravity;
  private Vector2d rotation; //image rotation
  private int depth; //layers; small depth => near layer

  private long id; //number of particles
  private boolean destroy; // to be destroyed?

  private boolean persistent; // the particle continues to exist even after changing scene
  private boolean initialised; // has init() been called?
  protected Palette pal;
  private boolean sceneChanged; //has the scene changed (while the particle is persistent)?

  private float[] params; //general parameters
  
  //protected boolean near;
  private boolean destroying = false;

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
    sceneChanged = false;

    id = global_particlesInstanciatedNumber;
    global_particlesInstanciatedNumber++;
    destroy = false;
   
    params = new float[PARAMETERS_NUMBER];    
    for(int i = 0; i < PARAMETERS_NUMBER; i++)
    {
      params[i] = 0.0;
    }
    
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
    sceneChanged = false;

    id = global_particlesInstanciatedNumber;
    global_particlesInstanciatedNumber++;
    destroy = false;
    
    params = new float[PARAMETERS_NUMBER];    
    for(int i = 0; i < PARAMETERS_NUMBER; i++)
    {
      params[i] = toCopy.params[i];
    }
    
  }

  //PUBLIC METHODS
  //get methods
  public Vector2d getPosition()
  {
    return position; // give the address of the "position" vector
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

  boolean getSceneChanged()
  {
    return sceneChanged;
  }

  public float getParameter(int index)
  {
    if(index >= 0 && index < PARAMETERS_NUMBER)
    {
      return params[index];
    }
    else
    {
      println("Warning: trying to get a parameter out of index boudaries, returning 0\n");
      return 0.0;
    }
  }
  
  
  //set methods
  public void setParameter(int index, float newValue)
  {
    if(index >= 0 && index < PARAMETERS_NUMBER)
    {
      params[index] = newValue;
    }
    else
    {
      println("Warning: trying to set a parameter out of index boundaries\n");
    }
  }
 
  public void setPosition(Vector2d newPosition)
  {
    position = new Vector2d(newPosition);
  }

  public void setSpeed(Vector2d newSpeed) // EX: particle.setPosition(new Vector2d(5, pi/4, true));
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

  public void setDepth(int newDepth) //depth can be positive or negative
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

  void assertSceneChanged()
  {
    sceneChanged = true;
  }

  //apply transformations method
  void beginTransformations() //
  {
    pushMatrix();
    position.applyTranslation(); // temporary change from (position_x, position_y) --> (0,0)
    rotation.applyRotation();   // temporary change
  }

  void endTransformations()
  {
    popMatrix(); // wipe temporary changes
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
    //spacial variables update (Heun method)
    Vector2d positionk1 = speed;
    speed = speed.sum(gravity);
    Vector2d positionk2 = speed;
    Vector2d sigma = positionk1.sum(positionk2);
    position = position.sum(sigma.quot(2));
        
    //life variables update
    updateTime();
        
    if(getLifeTimeIsUp())
    {
      instanceDestroy();
    }
  }

  public void setPalette(Palette p)
  {
    pal=p;
  }
  
  
  public void connectParticles(int connectionRadius, int particleRadius)
  {
    final int particlesNumber = global_stage.getCurrentScene().getParticlesNumber()-1;
    float d, a, h;
    
    for(int i1=0;i1<particlesNumber;i1++){
      
    int start_index = (i1 - particleRadius/2) > 0 ?  (i1 - particleRadius/2) : 0;
    int end_index = (i1 + particleRadius/2) < particlesNumber ? (i1 + particleRadius/2) : particlesNumber ;
    
    for (int i2 = start_index; i2 < end_index; i2++) {
       if(
          (!(global_stage.getCurrentScene().getParticleByListIndex(i1).getSceneChanged()&&global_stage.getCurrentScene().getParticleByListIndex(i2).getSceneChanged())&&!destroying)
          ||(global_stage.getCurrentScene().getParticleByListIndex(i1).getSceneChanged()&&global_stage.getCurrentScene().getParticleByListIndex(i2).getSceneChanged()&&destroying)
          ) //with this condition, programs checks whether the particle is from the correct scene
        {
          Vector2d p1 = global_stage.getCurrentScene().getParticleByListIndex(i1).getPosition();
          Vector2d p2 = global_stage.getCurrentScene().getParticleByListIndex(i2).getPosition();
                  
          d = p1.distance(p2);
          a = pow(1/(d/connectionRadius+1), 6);
    
          if (d <= connectionRadius && d > 2) 
            {
              color lineColor = global_stage.getCurrentScene().getPalette().getColor();
              stroke(lineColor, a*200);
              line(p1.getX(), p1.getY(), p2.getX(), p2.getY());  
           }
          }
        }            
     }        
  }

  //methods to implement in the "child classes"
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