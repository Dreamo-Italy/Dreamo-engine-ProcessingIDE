//package dreamo.display;

import java.util.Arrays;

abstract class Scene extends AgingObject
{
  private final int PARTICLES_MAX = 10000;
  public final int PARAMETERS_NUMBER = 3;
  private Particle[] particlesList;
  private int particlesNumber; // can also decrease
  
  private Background sceneBackground;
  private boolean backgroundEnabled; // true -> screen refresh at every frame
  
  private float[] parameters;
  
  //CONSTRUCTORS
  public Scene()
  {
    particlesList = new Particle[PARTICLES_MAX];
    particlesNumber = 0;
    sceneBackground = null;
    backgroundEnabled = false; // false -> the screen doesn't refresh at every frame
    parameters = new float[PARAMETERS_NUMBER];    
    for(int i = 0; i < PARAMETERS_NUMBER; i++)
    {
      parameters[i] = 0.0;
    }
  }
  
  //copy constructor
  public Scene(Scene toCopy)
  {
    particlesList = new Particle[PARTICLES_MAX];
    particlesNumber = toCopy.particlesNumber;
    sceneBackground = toCopy.sceneBackground;
    backgroundEnabled = toCopy.backgroundEnabled;
    
    for(int i = 0; i < particlesNumber; i++) // pass by reference
    {
      if(toCopy.particlesList[i] != null)
      {
        particlesList[i] = toCopy.particlesList[i];
      }
    }
    
    parameters = new float[PARAMETERS_NUMBER];    
    for(int i = 0; i < PARAMETERS_NUMBER; i++)
    {
      parameters[i] = toCopy.parameters[i];
    }
  }
  
  //
  public int getParticlesNumber()
  {
    return particlesNumber;
  }
  
  public float getParameter(int index)
  {
    if(index >= 0 && index < PARAMETERS_NUMBER)
    {
      return parameters[index];
    }
    else
    {
      println("Warning: trying to get a parameter out of index boudaries, returning 0\n");
      return 0.0;
    }
  }
  
  public void setParameter(int index, float newValue)
  {
    if(index >= 0 && index < PARAMETERS_NUMBER)
    {
      parameters[index] = newValue;
    }
    else
    {
      println("Warning: trying to set a parameter out of index boundaries\n");
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
      sortParticlesList(); // SORT: list[0] = far particle, small (or negative) depth 
                                                            // list[big number] = near particle, big depth
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
  
    
  private Particle getParticleByListIndex(int indexToGet)
  {
    if(indexToGet < particlesNumber)
    {
      return particlesList[indexToGet]; // the object pointed by particlesList[indexToRemove] has now no reference and will be removed from memory     
    }
    else
    {
      println("Warning: cannot get particle by list index, index higher than instance number.");
      return null;
    }
  }
  
  public void sortParticlesList()
  {
    Arrays.sort(particlesList, new ParticleComparator());
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
  
  public void eraseParticles()
  {    
    for(int i = 0; i < particlesNumber; i++)
    {      
      particlesList[i] = null;      
    }
    particlesNumber = 0;
  }      
  
  private void removeParticleByListIndex(int indexToRemove)
  {
    if(indexToRemove < particlesNumber)
    {
      particlesList[indexToRemove] = null; // the object pointed by particlesList[indexToRemove] has now no reference and will be removed from memory
      for(int i = indexToRemove; i < particlesNumber-1; i++)
      {
        particlesList[i] = particlesList[i+1];
      }
      particlesNumber--;
    }
    else
    {
      println("Warning: cannot remove particle by list index, index higher than instance number.");
    }
  }
  
  public void popParticle() // remove the youngest particle
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
        particlesList[i].assertSceneChanged();
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
  
  abstract void init();
}