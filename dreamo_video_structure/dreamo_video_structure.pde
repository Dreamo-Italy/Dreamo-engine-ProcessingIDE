float fps = 0;

void setup()
{
  //fullScreen(FX2D);
  size(800, 600, FX2D);
  frameRate(60);
  noSmooth();
  
  //conncetion with arduino
  global_connection = new Connection(this);
  global_gsr = new Gsr();
  global_stage = new Stage();
  
  //audio features
  global_audio = new AudioFeatures(this);
  global_tone = new Tone();
  global_rhythm = new Rhythm();
  global_dyn = new Dynamic();
  
  //scenes
  global_stage.addScene(new SceneFireworks());
  global_stage.addScene(new SceneDots());
  global_stage.addScene(new ScenePerlinNoise());
}

void draw()
{
    long initTimeT = System.nanoTime(); // start time
    fps = frameRate;

     
     println("");
     println("***************************************");
     println("*****************START*****************");
     println("");

   
   //update samples in audio buffer
   global_audio.updateBuffer();
   //set samples in dyn, tone and rhythm objects
   global_dyn.setSamples(global_audio.getSamples());
   global_tone.setSamples(global_audio.getSamples());
   global_rhythm.setSamples(global_audio.getSamples());

   global_connection.update();
   
   long conT = System.nanoTime() - initTimeT; // time elapsed after CONNECTION UPDATE
    
   global_gsr.update();

   long gsrT = (System.nanoTime() - conT -initTimeT ); // time elapsed after GSR UPDATE
    
   global_stage.updateAndTrace();
   
   long viT = (System.nanoTime() - gsrT - conT -initTimeT) ; // time elapsed after VIDEO UPDATE
   
  
  fill(120); // for the DEBUG text
  stroke(120); // for the DEBUG text
    if(frameCount%1 == 0) // print the DEBUG TEXT every 20 frames
  {
    global_gsr.printDebug();
  }
   text("particles: " + global_stage.getCurrentScene().getParticlesNumber() + "; framerate: " + fps + " \n", 10, 20);
   
   
   long loopT = (System.nanoTime()  - initTimeT) ; // OVERALL TIME
   
   
   //----------- print the durations for debug purposes------------
   
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
  float[] defaultParameters = {random(800)-400, random(800)-400, random(800)-400};
  global_stage.selectSceneFromParameters(defaultParameters);
}