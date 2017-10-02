void setup()
{ 

  //****** VIDEO ******
  colorMode(HSB, 360, 100, 100, 100);
  size(1280, 750, FX2D);
  //fullScreen(FX2D,1);
  frameRate(global_fps);
  noSmooth();
  
  //****** CONNECTION //<>// ****** //<>// //<>// //<>//
  global_connection = new Connection(this);

  //****** BIOSENSORS ******
  global_gsr = new Gsr();
  global_ecg= new Ecg();

  //****** BIOLOGICAL MOOD ******
  global_bioMood = new BioMood();

  //****** AUDIO ******
  global_audio = new AudioManager(this); //new audio manager
  audio_proc = new AudioProcessor(global_audio.getBufferSize(),global_audio.getSampleRate()); //new audio processor
  global_audio.addListener(audio_proc); //attach processor to manager
  global_dyn = new Dynamic(global_audio.getBufferSize(),global_audio.getSampleRate()); //new dynamic features extractor
  global_timbre = new Timbre(global_audio.getBufferSize(),global_audio.getSampleRate()); //new timbric features extractor
  global_rhythm = new Rhythm(global_audio.getBufferSize(),global_audio.getSampleRate()); //new rhythmic features extractor
  
  //add features extractors to our audio processor
  audio_proc.addDyn(global_dyn);
  audio_proc.addTimbre(global_timbre);
  audio_proc.addRhythm(global_rhythm);

  audio_decisor = new AudioDecisor(global_dyn,global_rhythm,global_timbre);
  
  //****** STAGE ******
  global_stage = new Stage();

  //****** SCENES ********
  //global_stage.addScene(new BlankScene());
  global_stage.addScene(new AudioDebug());
  //global_stage.addScene(new ScenePlotter());
  //global_stage.addScene(new Spirals());
  global_stage.addScene(new ScenePerlinNoise());
  global_stage.addScene(new CrazyL());

  //**** DEBUG PLOTS
  global_debugPlots = new DebugPlot(this);
  
  //**** CONTROL INTERFACE
  setupGUI();
  
}

void draw()
{
  
   //track execution times  
   long initTimeT = System.nanoTime(); // start time
   long audioTime = System.nanoTime() - initTimeT;
   
   global_connection.update();

   long conT = System.nanoTime() - audioTime - initTimeT; // time elapsed after CONNECTION UPDATE

   global_gsr.update();

   long gsrT= (System.nanoTime() - conT -initTimeT - audioTime);// time elapsed after GSR UPDATE

   global_ecg.update();
   global_bioMood.update();

   long ecgT = (System.nanoTime() - conT -initTimeT - audioTime- gsrT); // time elapsed after ECG UPDATE

   global_stage.updateAndTrace();

   long viT = (System.nanoTime() - gsrT - conT - initTimeT - audioTime-ecgT) ; // time elapsed after VIDEO UPDATE

   global_debugPlots.update();

   fill(120); // for the DEBUG text
   stroke(120); // for the DEBUG text

   text("particles: " + global_stage.getCurrentScene().getParticlesNumber() + "; framerate: " + nf(frameRate,2,1) + " \n", marginSpace, interlineSpace );
   text("                                                      Frame Count: "+frameCount,marginSpace, interlineSpace );
   //global_gsr.printDebug();// print the DEBUG TEXT related to the SKIN SENSOR
   //global_ecg.printDebug();// print the DEBUG TEXT related to the ECG SENSOR

   audio_decisor.run();
   
   drawGUI();

   long loopT = (System.nanoTime()  - initTimeT) ; // OVERALL TIME

   /*
   //----------- DEBUG PRINTS ------------ //
   println("    Audio update duration: "+ audioTime/1000 + " us");
   println("    Connection update duration: "+ conT/1000 + " us");
   println("    GSR update duration: "+ gsrT/1000 + " us");
   println("    Video update duration: "+ viT/1000 + " us");
   println("");
   println("    LOOP duration: "+ loopT/1000 + " us");
   println("    MAX duration for framerate "+ int(frameRate) +": "+(1/frameRate*1000000)+" us");
   println(""); 
   
   println("*************************************************");
   println("************** AUDIO PARAMETERS *****************");
   println("*************************************************");
   println("************* DYNAMIC PARAMETERS ****************");
   println("RMS AVG (NORM): "+ global_dyn.getRMSAvg());
   println("DINAMICITY INDEX: "+global_dyn.getDynamicityIndex());
   println("*************************************************");
   println("************* TIMBRIC PARAMETERS ****************");
   println("SPECTRAL CENTROID: "+global_timbre.getCentroidShortTimeAvgHz()+" Hz");
   println("SPECTRAL COMPLEXITY: "+global_timbre.getComplexityAvg()+" peaks");
   println("ZERO CROSSING RATE: "+global_timbre.getZeroCrossingRate());
   println("*************************************************");
   
   println("************* RHYTHMIC PARAMETERS ***************");
   println("RHYTHM DENSITY: "+global_rhythm.getRhythmDensity());
   println("RHYTHM STRENGTH: "+global_rhythm.getRhythmStrength());
   println("*************************************************");
   
   println("************** SILENCE DETECTOR *****************");;
   println("-60dB SILENCE: "+ global_dyn.isSilence(-60));
   println("-50dB SILENCE: "+ global_dyn.isSilence(-50));
   println("-45dB SILENCE: "+ global_dyn.isSilence(-45));
   println("-40dB SILENCE: "+ global_dyn.isSilence(-40));
   println("*******************END***************************");
   println("*************************************************");
   
   println("CLARITY: " + audio_decisor.getClarity());
   println("ENERGY: " + audio_decisor.getEnergy());
   println("AGITATION: " + audio_decisor.getAgitation());
   println("ROUGHNESS: " + audio_decisor.getRoughness());
   */
   
   //global_stage.nextSceneIfSilence(-50);

}


void mouseClicked()
{
  //Mood m = new Mood(random(-1,1), random(-1,1));
  //global_stage.selectScenebyMood(m);
  //global_stage.nextScene();
}

void keyPressed()
{
  
  if (key == 'c')
  {
   global_gsr.restartCalibration();
   global_ecg.restartCalibration();
   println("key pressed");
  }
     
  if (key=='s'||key=='S')
  {
    audio_proc.saveLog(); //SAVE AUDIO DATA LOG
    //global_connection.saveLog(); //SAVE SENSORS LOG
  }
     
  if (key=='m'||key=='M')
  {
    global_audio.enableMonitoring();
  }
    
  if (key=='n'||key=='N')
  {
    global_stage.nextScene();
  }
     
}

void stop()
{
 global_audio.stop();
}