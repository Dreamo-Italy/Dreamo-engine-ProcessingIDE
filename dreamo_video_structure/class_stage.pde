//package dreamo.display;  //<>// //<>// //<>//

class Stage 
{
 private Scene[] scenesList;
 private int scenesNumber;

 private Scene currentScene;
 private int currentSceneIndex;


 private int global_stage_change_cnt;
 private int[] scene_score;

 private boolean firstChange;

 //CONSTRUCTORS
 public Stage() 
 {
  int i;
  scenesList = new Scene[SCENES_MAX];
  scenesNumber = 0;
  currentScene = null;
  currentSceneIndex = -1;
  global_stage_change_cnt = 0;
  scene_score = new int[SCENES_MAX];

  firstChange = false;

  for (i = 0; i < SCENES_MAX; i++)  //<>// //<>// //<>//
  {
   scene_score[i] = 0;
  }
 }

 //copy constructor
 public Stage(Stage toCopy) 
 {
  scenesList = new Scene[SCENES_MAX];
  scenesNumber = toCopy.scenesNumber;
  currentScene = null;
  currentSceneIndex = -1;

  firstChange = toCopy.firstChange;

  for (int i = 0; i < scenesNumber; i++) 
  {
   scenesList[i] = toCopy.scenesList[i];
  }
 }

 //
 public void addScene(Scene toAdd) 
 {
  if (scenesNumber < SCENES_MAX) 
  {
   scenesList[scenesNumber] = toAdd;
   scenesNumber++;
   if (currentScene == null) // TRUE if currentScene is the first scene
   {
    currentScene = toAdd;
    currentScene.init();
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
  if (currentSceneIndex >= 0) // currentSceneIndex = -1 means there are no scenes avalaible
  {
   currentSceneIndex++;
   if (currentSceneIndex >= scenesNumber) 
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
  if (currentSceneIndex >= 0) 
  {
   currentSceneIndex--;
   if (currentSceneIndex < 0) 
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
   if (currentSceneIndex >= 0) 
   {
    currentSceneIndex = (int) FastMath.floor(random(scenesNumber));
    changeScene(scenesList[currentSceneIndex]);
   } 
   else 
   {
    println("Warning: there are no scenes in the stage.");
   }
  }
  /*
  // looks for the NEAREST scene in the sense of euclidean distance.
  // the input Mood m is calculated from audio and biomedical signals analysis 
  public void selectScenebyMood(Mood m) 
  {
    float minimumDistance = Float.MAX_VALUE;
    Scene minimumDistanceScene = null;
    
    for(int i = 0; i < scenesNumber; i++)
    {
      float sumOfSquares = 0.0;
      
      sumOfSquares += pow(m.getValence() - scenesList[i].sceneMood.getValence(), 2);
      sumOfSquares += pow(m.getArousal() - scenesList[i].sceneMood.getArousal(), 2);
      
      if(sumOfSquares < minimumDistance)
      {
        minimumDistance = sumOfSquares;
        minimumDistanceScene = scenesList[i];
      }
    }
    if(minimumDistanceScene != null)
    {
      changeScene(minimumDistanceScene);
    }
  } 
  */

 public int selectSceneByVote(float q_gsr, float q_ecg, int scene_num) 
 {
  int i, scene_sel, max, max_sel;

  scene_sel = (int) FastMath.round((q_gsr + q_ecg) / 2);
  scene_score[scene_sel] = scene_score[scene_sel] + 1;

  if (global_stage_change_cnt == CHANGE_CHECK) 
  {
   max_sel = -1;
   max = 0;

   for (i = 0; i < scene_num; i++) 
   {
    if (scene_score[i] > SOGLIA_SEL) 
    {
     if (scene_score[i] > max) 
     {
      max = scene_score[i];
      max_sel = i;
     }
     scene_score[i] = 0;
    }
   }

   global_stage_change_cnt = 1;

   if (!(max_sel < 0)) 
   {
    return max_sel;
   }
  }

  global_stage_change_cnt = global_stage_change_cnt + 1;
  return -1;
 }

 private void changeScene(Scene newScene) 
 {
  if (newScene != currentScene) 
  {
   currentScene.exportPersistentParticles(newScene);
   currentScene.eraseParticles();
   currentScene = newScene;
   currentScene.init();
  }
 }

 public void selectScene(int n) 
 {
  if (n < scenesNumber) 
  {
   changeScene(scenesList[n]);
  }
 }

 public void popScene() 
 {
  if (scenesNumber > 0) 
  {
   scenesList[scenesNumber] = null;
   scenesNumber--;
   if (scenesNumber == 0) 
   {
    currentSceneIndex = -1;
   }
  } 
  else 
  {
   println("Warning: cannot pop any more scenes from the Stage.");  //<>// //<>// //<>//
  }
 }

 public Scene getCurrentScene() 
 {
   return currentScene;  //<>// //<>// //<>//
  }
  //update and trace methods
 public void updateAndTrace() 
 {
  currentScene.update();
  currentScene.trace();
  currentScene.trashDeadParticles();
 }

 public int getNumberOfScenes()  { return scenesNumber; }
 
 public void nextSceneIfSilence(int noiseMaxDb) 
 {
  if (frameCount % 30 != 0) return;

  if (global_dyn.isSilence(noiseMaxDb) && firstChange == false) 
  {
   firstChange = true;
   global_stage.nextScene();
  } 
  else if (global_dyn.isSilence(noiseMaxDb) && firstChange) {} 
  else if (firstChange)
   firstChange = false;
 }
}