//package dreamo.display;

class Stage
{
  private final int SCENES_MAX = 100;
  private Scene[] scenesList;
  private int scenesNumber;
  
  private Scene currentScene;
  private int currentSceneIndex;
  
  //CONSTRUCTORS
  public Stage()
  {
    scenesList = new Scene[SCENES_MAX];
    scenesNumber = 0;
    currentScene = null;
    currentSceneIndex = -1;
  }
  
  //copy constructor
  public Stage(Stage toCopy)
  {
    scenesList = new Scene[SCENES_MAX];
    scenesNumber = toCopy.scenesNumber;
    currentScene = null;
    currentSceneIndex = -1;
    
    for(int i = 0; i < scenesNumber; i++)
    {
      scenesList[i] = toCopy.scenesList[i];
    }
  }
  
  //
  public void addScene(Scene toAdd)  
  {
    if(scenesNumber < SCENES_MAX)
    {
      scenesList[scenesNumber] = toAdd;
      scenesNumber++;
      if(currentScene == null)
      {
        currentScene = new Scene(toAdd);
        currentSceneIndex = 0;
      }
    }
    else
    {
      println("Warning: reached maximum number of scenes for the Stage. Last Scene wasn't added.");
    }
  }
  
  public void nextScene()  
  {
    if(currentSceneIndex >= 0) // currentSceneIndex = -1 means there are no scenes avalaible
    {
      currentSceneIndex++;
      if(currentSceneIndex >= scenesNumber)
      {
        currentSceneIndex = 0;
      }
      changeScene(scenesList[currentSceneIndex]);
    }
    else
    {
      println("Warning: there are no scenes in the stage.");
    }
  }
  
  public void prevScene()  
  {
    if(currentSceneIndex >= 0)
    {
      currentSceneIndex--;
      if(currentSceneIndex < 0)
      {
        currentSceneIndex = scenesNumber - 1;
      }
      changeScene(scenesList[currentSceneIndex]);
    }
    else
    {
      println("Warning: there are no scenes in the stage.");
    }
  }
  
  public void randomScene()  
  {
    if(currentSceneIndex >= 0)
    {
      currentSceneIndex = floor(random(scenesNumber));
      changeScene(scenesList[currentSceneIndex]);
    }
    else
    {
      println("Warning: there are no scenes in the stage.");
    }
  }
  
  private void changeScene(Scene newScene)  
  {
    Scene tempScene = new Scene(newScene); // use the copy constructor from the class "Scene"
    tempScene.sortParticlesList();
    currentScene.exportPersistentParticles(tempScene);    
    currentScene = tempScene;
  }
  
  public void popScene()
  {
    if(scenesNumber>0)
    {
      scenesList[scenesNumber] = null;
      scenesNumber--;
      if(scenesNumber == 0)
      {
        currentSceneIndex = -1;
      }
    }
    else
    {
      println("Warning: cannot pop any more scenes from the Stage.");
    }
  }
    
  public Scene getCurrentScene()
  {
    return currentScene;
  }
  
  //update and trace methods
  public void updateAndTrace()
  {
    // audioFeature.update()
    // emg.update()
    
    currentScene.update();
    currentScene.trace();
    currentScene.trashDeadParticles();
  }
}