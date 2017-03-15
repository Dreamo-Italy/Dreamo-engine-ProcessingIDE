void setup()
{

  //****** VIDEO ******
  colorMode(HSB, 360, 100, 100, 100);
  size(800, 600, FX2D);
  frameRate(global_fps);
  noSmooth();

  //****** CONNECTION //<>// ****** //<>//
  global_connection = new Connection(this);

  //****** BIOSENSORS ******
  global_gsr = new Gsr();
  global_ecg= new Ecg();

  //****** AUDIO ******
  global_audio = new AudioManager(this); //new audio manager
  audio_proc = new AudioProcessor(global_audio.getBufferSize(),global_audio.getSampleRate()); //new audio processor
  global_audio.addListener(audio_proc); //attach processor to manager
  global_dyn = new Dynamic(global_audio.getBufferSize(),global_audio.getSampleRate()); //new dynamic features extractor
  global_timbre = new Timbre(global_audio.getBufferSize(),global_audio.getSampleRate()); //new timbric features extractor
  //add features extractors to our audio processor
  audio_proc.addDyn(global_dyn);
  audio_proc.addTimbre(global_timbre);

  //****** STAGE ******
  global_stage = new Stage();

  //scenes
  global_stage.addScene(new Lissajous() );
  global_stage.addScene(new ScenePlotter());
  global_stage.addScene(new SceneFireworks());
  global_stage.addScene(new SceneDots());
  global_stage.addScene(new ScenePerlinNoise());
  global_stage.addScene(new Spirals());
  global_stage.addScene(new HelloShape(0));
  global_stage.addScene(new HelloShape(1));
  global_stage.addScene(new DumbC());

  //debug plots
  global_debugPlots = new DebugPlot(this);
}

void draw()
{
    long initTimeT = System.nanoTime(); // start time

  /*
   //update samples in audio buffer
   global_audio.updateBuffer();

   //set samples in dyn, tone and rhythm objects
   global_dyn.setSamples(global_audio.getSamples());
   global_tone.setSamples(global_audio.getSamples());
   global_rhythm.setSamples(global_audio.getSamples());

   */

   long audioTime = System.nanoTime() - initTimeT;

   global_connection.update();

   long conT = System.nanoTime() - audioTime - initTimeT; // time elapsed after CONNECTION UPDATE

   global_gsr.update();

   long gsrT= (System.nanoTime() - conT -initTimeT - audioTime);// time elapsed after GSR UPDATE

   global_ecg.update();

   long ecgT = (System.nanoTime() - conT -initTimeT - audioTime- gsrT); // time elapsed after ECG UPDATE

   global_stage.updateAndTrace();

   long viT = (System.nanoTime() - gsrT - conT - initTimeT - audioTime-ecgT) ; // time elapsed after VIDEO UPDATE

   global_debugPlots.update();


    fill(120); // for the DEBUG text
    stroke(120); // for the DEBUG text

   global_gsr.printDebug();// print the DEBUG TEXT related to the SKIN SENSOR
   //global_ecg.printDebug();// print the DEBUG TEXT related to the ECG SENSOR
   text("particles: " + global_stage.getCurrentScene().getParticlesNumber() + "; framerate: " + nf(frameRate,2,1) + " \n", 10, 20);


   long loopT = (System.nanoTime()  - initTimeT) ; // OVERALL TIME


   //----------- print the durations for debug purposes------------ //<>// //<>//

   println("    Audio update duration: "+ audioTime/1000 + " us");
   println("    Connection update duration: "+ conT/1000 + " us");
   println("    GSR update duration: "+ gsrT/1000 + " us");
   println("    Video update duration: "+ viT/1000 + " us");
   println("");
   println("    LOOP duration: "+ loopT/1000 + " us");
   println("    MAX duration for framerate "+ int(frameRate) +": "+(1/frameRate*1000000)+" us");
   println("");

   println("SPECTRAL CENTROID: "+global_timbre.getCentroidHz()+" Hz");
   println("*******************END*****************");
   println("***************************************");
   println("");
}

void mouseClicked()
{

  //Mood m = new Mood(random(-1,1), random(-1,1));
  // global_stage.selectScenebyMood(m);
  global_stage.nextScene();
}

void keyPressed()
{
     if (true)
     {
       global_gsr.restartCalibration();
       global_ecg.restartCalibration();
       println("key pressed");
     }
}


void stop()
     {
       global_audio.stop();    
     }
