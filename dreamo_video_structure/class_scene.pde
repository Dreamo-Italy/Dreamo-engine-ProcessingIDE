//*************************************************
// class Scene
// last modified: 12/11/16
//
//**************************************************

import java.util.Arrays;

class Scene
{
  private final short PARTICLES_MAX = 10000;
  private Particle[] particlesList;
  private short particlesNumber;
  
  //CONSTRUCTORS
  public Scene()
  {
    particlesList = new Particle[PARTICLES_MAX];
    particlesNumber = 0;
  }
  //copy constructor
  public Scene(Scene toCopy)
  {
    particlesList = new Particle[PARTICLES_MAX];
    particlesNumber = toCopy.particlesNumber;
    
    for(short i = 0; i < particlesNumber; i++)
    {
      particlesList[i] = toCopy.particlesList[i];
    }
  }
  
  //
  public void addParticle(Particle toAdd)
  {
    if(particlesNumber < PARTICLES_MAX)
    {
      particlesList[particlesNumber] = toAdd;
      particlesNumber++;
      Arrays.sort(particlesList, new ParticleComparator());
      //initialize particle
      toAdd.init();
    }
    else
    {
      println("Warning: reached maximum number of particles for a Scene.");
    }
  } 
  
  public void removeParticleById(int idToRemove)
  {
    boolean match = false;
    for(short i = 0; i < particlesNumber; i++)
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
  
  private void removeParticleByListIndex(short indexToRemove)
  {
    if(indexToRemove < particlesNumber)
    {
      particlesList[indexToRemove] = null;
      for(short i = indexToRemove; i < particlesNumber-1; i++)
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
  
  //trace and update methods
  public void update()
  {
    for(short i = 0; i < particlesNumber; i++)
    {
      particlesList[i].updatePhysics();
      particlesList[i].update();
    }
  }
  
  public void trace()
  {
    for(short i = 0; i < particlesNumber; i++)
    {
      particlesList[i].beginTransformations();
      particlesList[i].trace();
      particlesList[i].endTransformations();
    }
  }
  
  //verify for instances to be destroyed
  public void trashDeadInstances()
  {
    for(short i = 0; i < particlesNumber; i++)
    {
      if(particlesList[i].isToBeDestroyed())
      {
        removeParticleByListIndex(i);
      }
    }
  }
}