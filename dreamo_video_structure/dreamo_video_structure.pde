void setup()
{
  colorMode(HSB, 360, 100, 100);
  //fullScreen(FX2D);
  size(800, 600, FX2D);
  frameRate(global_fps);
  noSmooth();

  //connection //<>//
  global_connection = new Connection(this);
  
  //biosensors
  global_gsr = new Gsr();

  //audio features
  global_audio = new AudioFeatures(this);
  global_tone = new Tone();
  global_rhythm = new Rhythm();
  global_dyn = new Dynamic();

  //init stage
  global_stage = new Stage();

  //scenes
  global_stage.addScene(new SceneFireworks());
  global_stage.addScene(new SceneDots());
  global_stage.addScene(new ScenePerlinNoise());
  global_stage.addScene(new ScenePlotter());
  global_stage.addScene(new SceneDynamicGrid());
}

void draw()
{
    long initTimeT = System.nanoTime(); // start time

   //update samples in audio buffer
   global_audio.updateBuffer();
   
   //set samples in dyn, tone and rhythm objects
   global_dyn.setSamples(global_audio.getSamples());
   global_tone.setSamples(global_audio.getSamples());
   global_rhythm.setSamples(global_audio.getSamples());
   
   long audioTime = System.nanoTime() - initTimeT;

   global_connection.update(); //<>//

   long conT = System.nanoTime() - audioTime - initTimeT; // time elapsed after CONNECTION UPDATE
   
   global_gsr.update();
   

   long gsrT = (System.nanoTime() - conT -initTimeT - audioTime); // time elapsed after GSR UPDATE

   global_stage.updateAndTrace();

   long viT = (System.nanoTime() - gsrT - conT - initTimeT - audioTime) ; // time elapsed after VIDEO UPDATE


    fill(120); // for the DEBUG text
    stroke(120); // for the DEBUG text

   global_gsr.printDebug();  // print the DEBUG TEXT related to the SKIN SENSOR every 20 frames
   text("particles: " + global_stage.getCurrentScene().getParticlesNumber() + "; framerate: " + frameRate + " \n", 10, 20);


   long loopT = (System.nanoTime()  - initTimeT) ; // OVERALL TIME


   //----------- print the durations for debug purposes------------

   println("    Audio update duration: "+ audioTime/1000 + " us");
   println("    Connection update duration: "+ conT/1000 + " us");
   println("    GSR update duration: "+ gsrT/1000 + " us");
   println("    Video update duration: "+ viT/1000 + " us");
   println("");
   println("    LOOP duration: "+ loopT/1000 + " us");
   println("    MAX duration for framerate "+ int(frameRate) +": "+(1/frameRate*1000000)+" us");
   println("");
   println("*******************END*****************");
   println("***************************************");
   println("");
}

void mouseClicked()
{
  
  Mood m = new Mood(random(-1,1), random(-1,1));
  // global_stage.selectScenebyMood(m);
  global_stage.nextScene();
}