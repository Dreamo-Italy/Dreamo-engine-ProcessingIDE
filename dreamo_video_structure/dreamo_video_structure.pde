void setup()
{ 
	int i; //<>// //<>// //<>//
	colorMode(HSB, 360, 100, 100, 100); //<>// //<>// //<>// //<>// //<>//
	size(800, 600, FX2D);//fullScreen(FX2D);
	frameRate(global_fps);
	noSmooth();  //<>// //<>//
	//connection //<>// //<>// //<>// //<>//
	global_connection = new Connection(this);  //<>// //<>// //<>// //<>// //<>// //<>// //<>//

	//biosensors
	global_gsr = new Gsr();  
	global_ecg = new Ecg(); 

	//audio features //<>//
	global_audio = new AudioFeatures(this);
	global_tone = new Tone();
	global_rhythm = new Rhythm();
	global_dyn = new Dynamic();

	//init stage
	global_stage = new Stage();

	//scenes
	global_stage.addScene(new ScenePlotter());
	global_stage.addScene(new SceneFireworks());
	global_stage.addScene(new SceneDots()); //<>// //<>// //<>//
	global_stage.addScene(new ScenePerlinNoise());
	global_stage.addScene(new Spirals()); //<>// //<>// //<>//
	global_stage.addScene(new HelloShape(0));
	global_stage.addScene(new HelloShape(1)); 
} //<>// //<>// //<>// //<>// //<>// //<>//

void draw() //<>// //<>// //<>// //<>// //<>//
{   
	float gsr_Val, ecg_Val, q_ecg, q_gsr;
	int scene_num, max_sel;
	//////////////////////////////////////////////////////////////////////////////////
	//update samples in audio buffer //<>// //<>// //<>//
	global_audio.updateBuffer();
	//set samples in dyn, tone and rhythm objects //<>// //<>// //<>//
	global_dyn.setSamples(global_audio.getSamples());
	global_tone.setSamples(global_audio.getSamples());
	global_rhythm.setSamples(global_audio.getSamples());
	////////////////////////////////////////////////////////////////////////////////// //<>// //<>// //<>// //<>// //<>// //<>//
	global_connection.update();
	//<>// //<>// //<>// //<>//
	global_gsr.update(); 
	gsr_Val = global_gsr.getValue();
	
	global_ecg.update();
	ecg_Val = global_ecg.getValue(); 
	//////////////////////////////////////////////////////////////////////////////////
	scene_num = global_stage.getNumberOfScenes();
	 //<>//
	q_gsr = map ( gsr_Val, 1, 10, 0, scene_num - 1 );
	q_ecg = map ( ecg_Val, 1, 10, 0, scene_num - 1 );
  
  max_sel = global_stage.selectSceneByVote(q_gsr, q_ecg, scene_num);
  
  if(!(max_sel < 0))
  {
  	global_stage.selectScene(max_sel);  //<>// //<>// //<>// //<>//
	}
  ////////////////////////////////////////////////////////////////////////////////// 
	global_stage.updateAndTrace();  //<>// //<>// //<>//
	/*
	fill(120); // for the DEBUG text
	stroke(120); // for the DEBUG text
	
	global_gsr.printDebug();  // print the DEBUG TEXT related to the SKIN SENSOR every 20 frames
	global_ecg.printDebug();  // print the DEBUG TEXT related to the SKIN SENSOR every 20 frames
	*/
	//<>//delay(500);
}
//////////////////////////////////////////////////////////////////////////////////
/*void mouseClicked()
{ //<>// //<>// //<>//
	//Mood m = new Mood(random(-1,1), random(-1,1));
	// global_stage.selectScenebyMood(m); //<>// //<>//
	global_stage.nextScene();
}*/
//////////////////////////////////////////////////////////////////////////////////void setup()