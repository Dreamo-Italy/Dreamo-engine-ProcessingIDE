class AudioDebug extends Scene 
{
 float[] coefficients;
 float[] long_window;
 Hysteresis timbre_decisor;
 int init;
 color c;
 float ratioCoeff;
 float elasticCoeff;
 int articulationCoeff;
 float roughnessCoeff;
 float brightnessCoeff;

 boolean activate = false;

 public void init() 
 {
  pal.initColors("warm");
  //println(pal.getID());

  Background bk = new Background();
  setBackground(bk);
  enableBackground();

  coefficients = new float[audio_proc.getSpecSize()];
  //long_window = new float[global_rhythm.getLongWindowMaxSize()];

  timbre_decisor = new Hysteresis(0.8, 0.9, 4);
 }
 
 int counter = 0;

 public void update() 
 {
  for (int i = 0; i < audio_proc.getSpecSize(); i++) 
  {
   coefficients[i] = audio_proc.getFFTcoeff(i);
  }
  //println("CHANGES "+audio_decisor.getChangesNumber());


  //pal.influenceColors(0,map(audio_decisor.getFeaturesVector()[3],0,30,0,1),0);

  //println(map(audio_decisor.getFeaturesVector()[3],0,30,0,1));

  //println("STATUS CHANGES IN THE LAST 2 SECS: "+audio_decisor.getChangesNumber());
  //println(audio_decisor.getColorChange());
  //println(audio_decisor.getColorIndicator());
  //println(map(audio_decisor.getFeaturesVector()[2],0,6000,-0.7,1));
 }

 public void trace() 
 {
  sceneBackground.trace();

  //draw quadrant

  /*
   int W=width/2;
   int H=height/2;
   
   c = lerpColor(pal.getDarkest(),pal.getLightest(),global_timbre.getCentroid());
   fill(c);
   if(global_dyn.isSilence()){noFill();}
   for(int i=0;i<articulationCoeff;i++)
   {
     ellipse(W+(50*i),H+(50*i),200+10*ratioCoeff,170+10*ratioCoeff);     
     //quad(W/3, H/4,  W/3+190, H/4+280,W/3+100, H/4+350, W/3+150, H/4+100);
   }
   */
  stroke(pal.getColor(0));
  fill(pal.getColor(0));
  int dist = 250;
  int l = 450;
  textSize(23);
  text("RMS ||| " + audio_decisor.getFeaturesVector()[0], width / 5, height / 6);
  text("||| " + audio_decisor.getStatusVector()[0], width / 5 + l, height / 6);
  text("DYN INDEX ||| " + audio_decisor.getFeaturesVector()[1], width / 5, height / 6 + dist / 6);
  text("||| " + audio_decisor.getStatusVector()[1], width / 5 + l, height / 6 + dist / 6);
  text("CENTROID ||| " + audio_decisor.getFeaturesVector()[2], width / 5, height / 6 + dist / 6 * 2);
  text("||| " + audio_decisor.getStatusVector()[2], width / 5 + l, height / 6 + dist / 6 * 2);
  text("COMPLEXITY ||| " + audio_decisor.getFeaturesVector()[3], width / 5, height / 6 + dist / 6 * 3);
  text("||| " + audio_decisor.getStatusVector()[3], width / 5 + l, height / 6 + dist / 6 * 3);
  text("RHYTHM STRENGTH ||| " + audio_decisor.getFeaturesVector()[4], width / 5, height / 6 + dist / 6 * 4);
  text("||| " + audio_decisor.getStatusVector()[4], width / 5 + l, height / 6 + dist / 6 * 4);
  text("RHYTHM DENSITY ||| " + audio_decisor.getFeaturesVector()[5], width / 5, height / 6 + dist / 6 * 5);
  text("||| " + audio_decisor.getStatusVector()[5], width / 5 + l, height / 6 + dist / 6 * 5);

  noFill();
  stroke(pal.getColor(1));

  //draw spectrum
  for (int i = 0; i < audio_proc.getSpecSize(); i++) 
  {
   //draw the line for frequency band i, scaling it up a bit so we can see it
   line(250 + i, height, 250 + i, height - coefficients[i] * 4);
  }

  stroke(pal.getColor(2));
  strokeWeight(2);
  line(250, height - global_timbre.getAvgMagnitude() * global_timbre.getMagnitudeThreshold(), 250 + audio_proc.getSpecSize(), height - global_timbre.getAvgMagnitude() * global_timbre.getMagnitudeThreshold());
  //text("AVG SPECTRUM MAGNITUDE: "+global_timbre.getAvgMagnitude(),width/2,height/2);
  strokeWeight(1);

  //draw onsets
  if (global_rhythm.isEnergyOnset()) 
  {
   fill(pal.getColor(3));
   ellipse(width / 5 + 150 + l, height / 4 + dist / 6 * 2, 100, 100);
  }

  if (global_dyn.isSilence(-60) || !global_dyn.isSilence(-50)) 
  {
   fill(pal.getColor(4));
   textSize(28);
   text("READING AUDIO DATA", width / 4, height / 9);
  }

  textSize(12);
 }
}