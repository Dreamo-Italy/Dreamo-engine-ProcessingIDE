//package dreamo.display;

import java.util.Arrays;

class Scene extends AgingObject
{
  private final int PARTICLES_MAX = 10000;
  private Particle[] particlesList;
  private int particlesNumber;
  
  private Background sceneBackground;
  private boolean backgroundEnabled;
  
  //CONSTRUCTORS
  public Scene()
  {
    particlesList = new Particle[PARTICLES_MAX];
    particlesNumber = 0;
    sceneBackground = null;
    backgroundEnabled = false;
  }
  
  //copy constructor
  public Scene(Scene toCopy)
  {
    particlesList = new Particle[PARTICLES_MAX];
    particlesNumber = toCopy.particlesNumber;
    sceneBackground = toCopy.sceneBackground;
    backgroundEnabled = toCopy.backgroundEnabled;
    
    for(int i = 0; i < particlesNumber; i++)
    {
      if(toCopy.particlesList[i] != null)
      {
        particlesList[i] = toCopy.particlesList[i];
      }
    }
  }
  
  //
  public void setBackground(Background newBackground)
  {
    sceneBackground = newBackground;
  }
  
  public void enableBackground()
  {
    backgroundEnabled = true;
  }
  
  public void disableBackground()
  {
    backgroundEnabled = false;
  }
  
  public void addParticle(Particle toAdd)
  {
    if(particlesNumber < PARTICLES_MAX)
    {
      particlesList[particlesNumber] = toAdd;
      particlesNumber++;
      Arrays.sort(particlesList, new ParticleComparator());
      //initialise particle
      if(!toAdd.getInitialised())
      {
        toAdd.init();
        toAdd.assertInitialised();
      }
    }
    else
    {
      println("Warning: reached maximum number of particles for a Scene. Last Particle wasn't added.");
    }
  } 
  
  public void removeParticleById(int idToRemove)
  {
    boolean match = false;
    for(int i = 0; i < particlesNumber; i++)
    {
      if(idToRemove == particlesList[i].getId())
      {
        match = true;
        removeParticleByListIndex(i);
      }
    }
    if(!match)
    {
      println("Warning: no instances with specified id were found to be removed.");
    }
  }
  
  private void removeParticleByListIndex(int indexToRemove)
  {
    if(indexToRemove < particlesNumber)
    {
      particlesList[indexToRemove] = null;
      for(int i = indexToRemove; i < particlesNumber-1; i++)
      {
        particlesList[i] = particlesList[i+1];
      }
      particlesNumber--;
      global_particlesCount--;
    }
    else
    {
      println("Warning: cannot remove particle by list index, index higher than instance number.");
    }
  }
  
  public void popParticle()
  {
    if(particlesNumber>0)
    {
      particlesList[particlesNumber] = null;
      particlesNumber--;
    }
    else
    {
      println("Warning: cannot pop any more particles from the scene.");
    }
  }
  
  public void exportPersistentParticles(Scene targetScene)
  {
    for(int i = 0; i < particlesNumber; i++)
    {
      if(particlesList[i].getPersistence())
      {
        targetScene.addParticle(particlesList[i]);
      }
    }
  }
  
  //trace and update methods  
  public void update()
  {
    for(int i = 0; i < particlesNumber; i++)
    {
      particlesList[i].updatePhysics();
      particlesList[i].update();
    }
  }
  
  public void trace()
  {  
    if(sceneBackground != null && backgroundEnabled)
    {
      sceneBackground.trace();
    }
    
    for(int i = 0; i < particlesNumber; i++)
    {
      particlesList[i].beginTransformations();
      particlesList[i].trace();
      particlesList[i].endTransformations();
    }
  }
  
  //verify for particles to be destroyed
  public void trashDeadParticles()
  {
    for(int i = 0; i < particlesNumber; i++)
    {
      if(particlesList[i].isToBeDestroyed())
      {
        removeParticleByListIndex(i);
      }
    }
  }
}