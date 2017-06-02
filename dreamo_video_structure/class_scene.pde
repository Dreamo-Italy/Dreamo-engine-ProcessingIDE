//package dreamo.display;

import java.util.Arrays;

abstract class Scene extends AgingObject
{
  private final int PARTICLES_MAX = 10000;
  public final int PARAMETERS_NUMBER = 3;
  protected Particle[] particlesList;
  protected int particlesNumber; // can also decrease

  protected Background sceneBackground;
  protected boolean backgroundEnabled; // true -> screen refresh at every frame

  protected Mood sceneMood;

  protected Palette pal;
  
  private boolean reflectHorizontally;
  private boolean reflectVertically;
  
  //fading 
  private boolean isFading;
  private int startFading;
  private int endFading;
  
  protected int[] audioStatus;
  protected float[] audioFeatures;
  
  //CONSTRUCTORS
  public Scene()
  {
    //allocate palette and init with random colors
    pal = new Palette();
    pal.initColors();

    particlesList = new Particle[PARTICLES_MAX];
    particlesNumber = 0;
    sceneBackground = null;
    backgroundEnabled = false; // false -> the screen doesn't refresh at every frame
    reflectHorizontally = false;
    reflectVertically = false;
    
    isFading=false;
    sceneMood=new Mood();
  }

  //copy constructor
  public Scene(Scene toCopy)
  {
    particlesList = new Particle[PARTICLES_MAX];
    particlesNumber = toCopy.particlesNumber;
    sceneBackground = toCopy.sceneBackground;
    backgroundEnabled = toCopy.backgroundEnabled;
    reflectHorizontally = toCopy.reflectHorizontally;
    reflectVertically = toCopy.reflectVertically;

    for(int i = 0; i < particlesNumber; i++) // pass by reference
    {
      if(toCopy.particlesList[i] != null)
      {
        particlesList[i] = toCopy.particlesList[i];
      }
    }
    
    sceneMood = new Mood(toCopy.sceneMood);
    
  }

  //
  public int getParticlesNumber()
  {
    return particlesNumber;
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
  
  public void setHorizontalReflection(boolean newValue)
  {
    reflectHorizontally = newValue;
  }
  
  public void setVerticalReflection(boolean newValue)
  {
    reflectVertically = newValue;
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
  
  
  public Palette getPalette()
  {
    return pal;
  }
  
  public void setPalette(Palette p)
  {
    this.pal=p;
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
    
    //update audio parameters
    audioStatus=audio_decisor.getStatusVector();
    audioFeatures=audio_decisor.getFeturesVector();
    
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
    
    if(reflectHorizontally) //<>// //<>// //<>// //<>//
    {
      PImage reflection = get(0, 0, width/2, height);
      pushMatrix();
      scale(-1, 1);
      image(reflection, -width, 0);
      popMatrix();
    }
    
    if(reflectVertically)
    {
      PImage reflection = get(0, 0, width, height/2);
      pushMatrix();
      scale(1, -1);
      image(reflection, 0, -height);
      popMatrix();
    }
    
    if(reflectVertically&&reflectHorizontally)
    {
      PImage reflection = get(0, 0, width/2, height/2);
      pushMatrix();
      scale(-1, -1);
      image(reflection, -width, -height);
      popMatrix();
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
  

  public void colorFadeTo(Palette p, int seconds, boolean activate)
  {
    if(this.pal.getID()!=p.getID()) //if it's not the same palette
    {
      if(activate || isFading){
        //if the scene is not already fading
        if(!isFading) //set starting and ending frames
        {
          startFading=frameCount;
          endFading=frameCount+seconds*global_fps;
          isFading=true; //now scene is fading    
        }
    
        else  //continue fading
        {
          if(frameCount<=endFading)//fading finished?
          {
            //set the colors of the palette
            for(int i=0;i<this.pal.paletteSize();i++)
            {
              this.pal.setColor(lerpColor(this.pal.getColor(i), p.getColor(i), map(frameCount,startFading,endFading,0,1)),i);
            }
          }
          else //finished 
          { 
            this.setPalette(p); //overwrite palette
            isFading=false;
          }
         }
        }
       }
       
  }

  abstract void init();
}