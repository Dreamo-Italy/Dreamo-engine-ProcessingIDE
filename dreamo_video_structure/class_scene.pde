//package dreamo.display;  //<>// //<>// //<>//

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
  private Palette targetPal;

  private boolean reflectHorizontally;
  private boolean reflectVertically;

  //fading
  private boolean isFading;
  private int startFading;
  private int endFading;

  private boolean changingBrightness;
  private boolean changingSaturation;


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
    changingBrightness=false;
    changingSaturation=false;

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

    for (int i = 0; i < particlesNumber; i++) // pass by reference
    {
      if (toCopy.particlesList[i] != null)
      {
        particlesList[i] = toCopy.particlesList[i];
      }
    }

    sceneMood = new Mood(toCopy.sceneMood);
    isFading=false;
  }


  public int getParticlesNumber() { return particlesNumber; }

  public void setBackground(Background newBackground) { sceneBackground = newBackground; }

  public void enableBackground() { backgroundEnabled = true; }

  public void disableBackground() { backgroundEnabled = false; }

  public void setHorizontalReflection(boolean newValue) { reflectHorizontally = newValue; }

  public void setVerticalReflection(boolean newValue) { reflectVertically = newValue; }

  public void addParticle(Particle toAdd)
  {
    if (particlesNumber < PARTICLES_MAX)
    {
      particlesList[particlesNumber] = toAdd;
      particlesNumber++;
      sortParticlesList(); // SORT: list[0] = far particle, small (or negative) depth
      // list[big number] = near particle, big depth
      //initialise particle
      if (!toAdd.getInitialised())
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
    if (indexToGet < particlesNumber)
    {
      return particlesList[indexToGet]; // the object pointed by particlesList[indexToRemove] has now no reference and will be removed from memory
    }
    else
    {
      println("Warning: cannot get particle by list index, index higher than instance number.");
      return null;
    }
  }

  public Palette getPalette() { return pal; }

  public void setPalette(Palette p) { this.pal=p; }

  public void sortParticlesList() { Arrays.sort(particlesList, new ParticleComparator()); }

  public void removeParticleById(int idToRemove)
  {
    boolean match = false;
    for (int i = 0; i < particlesNumber; i++)
    {
      if (idToRemove == particlesList[i].getId())
      {
        match = true;
        removeParticleByListIndex(i);
      }
    }
    if (!match)
    {
      println("Warning: no instances with specified id were found to be removed.");
    }
  }

  public void eraseParticles()
  {
    for (int i = 0; i < particlesNumber; i++)
    {
      particlesList[i] = null;
    }
    particlesNumber = 0;
  }

  private void removeParticleByListIndex(int indexToRemove)
  {
    if (indexToRemove < particlesNumber)
    {
      particlesList[indexToRemove] = null; // the object pointed by particlesList[indexToRemove] has now no reference and will be removed from memory
      for (int i = indexToRemove; i < particlesNumber-1; i++)
      {
        particlesList[i] = particlesList[i+1];
      }
      particlesNumber--;
    } else
    {
      println("Warning: cannot remove particle by list index, index higher than instance number.");
    }
  }

  public void popParticle() // remove the youngest particle
  {
    if (particlesNumber>0)
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
    for (int i = 0; i < particlesNumber; i++)
    {
      if (particlesList[i].getPersistence())
      {
        particlesList[i].assertSceneChanged();
        targetScene.addParticle(particlesList[i]);
      }
    }
  }

  //trace and update methods
  public void update()
  {
    for (int i = 0; i < particlesNumber; i++)
    {
      particlesList[i].updatePhysics();
      particlesList[i].update();
    }
  }

  public void trace()
  {
    if (sceneBackground != null && backgroundEnabled)
    {
      sceneBackground.trace();
    }

    for (int i = 0; i < particlesNumber; i++)
    {
      particlesList[i].beginTransformations();
      particlesList[i].trace();
      particlesList[i].endTransformations();
    }

    if (reflectHorizontally) //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
    {
      PImage reflection = get(0, 0, width/2, height);
      pushMatrix();
      scale(-1, 1);
      image(reflection, -width, 0);
      popMatrix();
    }

    if (reflectVertically)
    {
      PImage reflection = get(0, 0, width, height/2);
      pushMatrix();
      scale(1, -1);
      image(reflection, 0, -height);
      popMatrix();
    }

    if (reflectVertically&&reflectHorizontally)
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
    for (int i = 0; i < particlesNumber; i++)
    {
      if (particlesList[i].isToBeDestroyed())
      {
        removeParticleByListIndex(i);
      }
    }
  }


  public void colorFadeTo(Palette p, int seconds, boolean activate)
  {
    if (this.pal.getID()!=p.getID()) //if it's not the same palette
    {
      if (activate || isFading) {
        //if the scene is not already fading
        if (!isFading) //set starting and ending frames
        {
          startFading=frameCount;
          endFading=frameCount+seconds*global_fps;
          targetPal=p;
          isFading=true; //now scene is fading
        }
        else  //continue fading
        {
          if (frameCount<=endFading)//fading finished?
          {
            //set the colors of the palette
            for (int i=0; i<this.pal.paletteSize(); i++)
            {

              if (frameCount % 30 == 0 ) {println("... FADING... ");}
              this.pal.setColor(lerpColor(this.pal.getColor(i), targetPal.getColor(i), map(frameCount, startFading, endFading, 0, 1)), i);
            }
          } else //finished
          {
            this.setPalette(targetPal); //overwrite palette
            isFading=false;
          }
        }
      }
    }
  }


  public void darkenColors(int seconds, float amount, boolean activate)
  {
    if (activate || changingBrightness) {

      //if the scene is not already fading
      if (!changingBrightness) //set starting and ending frames
      {
        //startFading=frameCount;
        endFading=frameCount+seconds*global_fps;
        changingBrightness=true; //now scene is fading
      }
      else  //continue fading
      {
        if (frameCount<=endFading)//fading finished?
        {
          //set the colors of the palette
          this.pal.makeDarker(amount/(seconds*global_fps));
        }
        else //finished
        {
          changingBrightness=false;
        }
      }
    }
  }


  public void lightenColors(int seconds, float amount, boolean activate)
  {
    if (activate || changingBrightness)
    {

      //if the scene is not already fading
      if (!changingBrightness) //set starting and ending frames
      {
        //startFading=frameCount;
        endFading=frameCount+seconds*global_fps;
        changingBrightness=true; //now scene is fading
      } else  //continue fading
      {
        if (frameCount<=endFading)//fading finished?
        {
          //set the colors of the palette
          this.pal.makeBrighter(amount/(seconds*global_fps));
        } else //finished
        {
          changingBrightness=false;
        }
      }
    }
  }


  public void saturateColors(int seconds, float amount, boolean activate)
  {
    if (activate || changingSaturation)
    {

      //if the scene is not already fading
      if (!changingSaturation) //set starting and ending frames
      {
        //startFading=frameCount;
        endFading=frameCount+seconds*global_fps;
        changingSaturation=true; //now scene is fading
      }
      else  //continue fading
      {
        if (frameCount<=endFading)//fading finished?
        {
          println("SATURATING");

          this.pal.saturate(amount/(seconds*global_fps));
        }
        else //finished
        {
          changingSaturation=false;
        }
      }
    }
  }


  public void desaturateColors(int seconds, float amount, boolean activate)
  {
    if (activate || changingSaturation)
    {

      //if the scene is not already fading
      if (!changingSaturation) //set starting and ending frames
      {
        //startFading=frameCount;
        endFading=frameCount+seconds*global_fps;
        changingSaturation=true; //now scene is fading
      }
      else  //continue fading
      {
        if (frameCount<=endFading)//fading finished?
        {
          //set the colors of the palette
          this.pal.desaturate(amount/(seconds*global_fps));
        }
        else //finished
        {
          changingSaturation=false;
        }
      }
    }
  }


  protected String choosePaletteFromAudio()
  {
    //TODO: tune this parameter
    if (audio_decisor.getPaletteIndicator()>PALETTE_THRESHOLD)
    {
      return "warm";
    }
    else
    {
      return "cold";
    }
  }

  protected float chooseElasticityFromAudio()
  {
    float el=0;

    switch((int)audio_decisor.getElasticityIndicator())
    {
      case(0):
      el= 0.4;
      break;

      case(1):
      el= 0.7;
      break;

      case(2):
      el=1;
      break;

      case(3):
      el= 1.3;
      break;

      case(4):
      el= 1.7;
      break;

      case(6):
      el= 2.2;
      break;
    }
    return el;
  }

  protected float chooseRotationFromAudio()
  {
    float rot=0;

    switch((int)audio_decisor.getElasticityIndicator())
    {
      case(0):
      rot= 0.1;
      break;

      case(1):
      rot= 0.09;
      break;

      case(2):
      rot= 0.05;
      break;

      case(3):
      rot= 0.01;
      break;

      case(4):
      rot= 0.005;
      break;

      case(6):
      rot= 0;
      break;
    }
    return rot;
  }

  protected float chooseThicknessFromAudio()
  {
    float t=0;

    switch((int)audio_decisor.getTimbreIndicator())
    {
      case(0):
      t = 40;
      break;

      case(1):
      t = 30;
      break;

      case(2):
      t = 17;
      break;

      case(3):
      t = 11;
      break;

      case(4):
      t = 7;
      break;

      case(6):
      t = 3;
      break;
    }
    return t;
  }


  protected float chooseVibrationFromAudio()
  {
    float vib=0;

    switch((int)audio_decisor.getVibrationIndicator())
    {
      case(0):
      vib = 1;
      break;

      case(1):
      vib = 1.2;
      break;

      case(2):
      vib = 1.5;
      break;

      case(3):
      vib = 1.8;
      break;

      case(4):
      vib = 2;
      break;

      case(6):
      vib= 3.8;
      break;
    }
    return vib;
  }


  protected float chooseVibrationRangeFromAudio()
  {
    float range=0;

    if(audio_decisor.getFeaturesVector()[0]<0.05) {range=3/0.05;}
    else range=3/audio_decisor.getFeaturesVector()[0];

    return range;
  }

  protected float chooseResolutionFromAudio()
  {
    float res=0;

    if(audio_decisor.getStatusVector()[3]==0 || audio_decisor.getStatusVector()[3]==-1)
    {
      if(audio_decisor.getFeaturesVector()[3]<3 || audio_decisor.getFeaturesVector()[0]<0.01 ) res=2; //basic shape when silence or very smooth sound
      else if(audio_decisor.getFeaturesVector()[3]<9) res=5; //basic shape for smooth sounds
      else res=7;
    }
    else if(audio_decisor.getStatusVector()[3]==1)
    {
      res=11;
    }
    else if (audio_decisor.getStatusVector()[3]==3)
    {
      res= audio_decisor.getFeaturesVector()[3];
    }
    return res;
  }

  abstract void init();
}
