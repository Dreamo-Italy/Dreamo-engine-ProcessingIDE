//********************************************************
// class Scene
// last modified: 21/08/16
//
//  descrive una scena all'interno della visualizzazione
//
//********************************************************

//CONSTANTS
final int MAX_PARTICLES_NUMBER = 100;
  
class Scene
{
  //PRIVATE MEMBERS
  private int particlesPointer;
  private Particle[] sceneParticles;
  private Background sceneBackground;
  
  //CONSTRUCTORS
  public Scene()
  {
    particlesPointer = 0;
    sceneParticles = new Particle[MAX_PARTICLES_NUMBER];
    sceneBackground = new Background(color(255));
  }
  
  public Scene(Scene toCopy)
  {
    particlesPointer = toCopy.particlesPointer;
    for(int i = 0; i < particlesPointer; i++)
    {
      sceneParticles[i] = toCopy.sceneParticles[i];
    }
    sceneBackground = toCopy.sceneBackground;
  }
  
  //PUBLIC METHODS
  //push/pop methods
  public void pushParticle(Particle toAdd)
  {
    if(particlesPointer < MAX_PARTICLES_NUMBER)
    {
      sceneParticles[particlesPointer] = toAdd;
      particlesPointer++;
    }
    else
    {
      println("warning: reached maximum particles number for the scene. Particle has not been added.");
    }    
  }
   
  public void popParticle()
  {
    if(particlesPointer > 0)
    {
      particlesPointer--;
      sceneParticles[particlesPointer] = null;
    }
    else
    {
      println("warning: there isn't any particle to be removed.");
    }
  }
  
  //trace and update methods
  public void update()
  {
    for(int i = 0; i < particlesPointer; i++)
    {
      sceneParticles[i].update_physics();
    }
  }
  
  public void trace()
  {
    sceneBackground.trace();
    for(int i = 0; i < particlesPointer; i++)
    {
      sceneParticles[i].trace();
    }
  }
}
