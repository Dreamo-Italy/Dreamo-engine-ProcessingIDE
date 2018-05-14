import controlP5.*;

ControlP5 cp5;
Slider[] sliders;
Button default_button;
Slider inputVol;

//params to control
float RMSlower = DefaultAudioThresholds.RMS_LOWER_TH; //start with default values
float RMSupper = DefaultAudioThresholds.RMS_UPPER_TH;

float DYNINDEXlower = DefaultAudioThresholds.DYNINDEX_LOWER_TH;
float DYNINDEXupper = DefaultAudioThresholds.DYNINDEX_UPPER_TH;

float CENTROIDlower = DefaultAudioThresholds.CENTROID_LOWER_TH;
float CENTROIDupper = DefaultAudioThresholds.CENTROID_UPPER_TH;

float COMPLEXITYlower = DefaultAudioThresholds.COMPLEXITY_LOWER_TH;
float COMPLEXITYupper = DefaultAudioThresholds.COMPLEXITY_UPPER_TH;

float RSTRENGTHlower = DefaultAudioThresholds.RHYTHMSTR_LOWER_TH;
float RSTRENGTHupper = DefaultAudioThresholds.RHYTHMSTR_UPPER_TH;

float RDENSITYlower = DefaultAudioThresholds.RHYTHMDENS_LOWER_TH;
float RDENSITYupper = DefaultAudioThresholds.RHYTHMDENS_UPPER_TH;

float COBElower = DefaultAudioThresholds.COBE_LOWER_TH;
float COBEupper = DefaultAudioThresholds.COBE_UPPER_TH;

float EBFlower = DefaultAudioThresholds.EBF_LOWER_TH;
float EBFupper = DefaultAudioThresholds.EBF_UPPER_TH;

float SkewnessDlower = DefaultAudioThresholds.SKEWNESSD_LOWER_TH;
float SkewnessDupper = DefaultAudioThresholds.SKEWNESSD_UPPER_TH;

float SkewnessElower = DefaultAudioThresholds.SKEWNESSE_LOWER_TH;
float SkewnessEupper = DefaultAudioThresholds.SKEWNESSE_UPPER_TH;

float Roughnesslower = DefaultAudioThresholds.ROUGHNESS_LOWER_TH;
float Roughnessupper = DefaultAudioThresholds.ROUGHNESS_UPPER_TH;

float inVol = 0;

void setupGUI()
{
  cp5 = new ControlP5(this);
  cp5.setFont(createFont("Arial",10));
  cp5.setColorActive(color(0,130,164));
  cp5.setColorBackground(color(170));
  cp5.setColorForeground(color(50));
  cp5.setColorCaptionLabel(color(50));
  cp5.setColorValueLabel(color(255));

  int left=5;
  int top=10;
  int len=100;
  int thick=10;
  int posY=0;
  int increment=40;

  ControlGroup controls = cp5.addGroup("controls");
  controls.setPosition(780,30);
  controls.setColorLabel(color(255));
  controls.close();

  // Input volume control
  inputVol = cp5.addSlider("inVol");
  inputVol.setPosition(950, 30);
  inputVol.setSize(len, thick);
  inputVol.setCaptionLabel("Input vo dB");
  inputVol.setRange(-64,6);
  inputVol.getCaptionLabel().toUpperCase(true);
  inputVol.getCaptionLabel().setColorBackground(0x99ffffff);


  sliders = new Slider[22];

  sliders[0]=cp5.addSlider("RMSupper",audio_decisor.getRMSLowerThreshold(),1,left,top+posY,len,thick);
  sliders[0].setCaptionLabel("RMS upper Th");
  sliders[1]=cp5.addSlider("RMSlower",0,audio_decisor.getRMSUpperThreshold(),left,top+posY+20,len,thick);
  sliders[1].setCaptionLabel("RMS lower Th");
  posY+=increment;

  sliders[2]=cp5.addSlider("DYNINDEXupper",audio_decisor.getDynIndexLowerThreshold(),1,left,top+posY,len,thick);
  sliders[2].setCaptionLabel("DYN INDEX upper Th");
  sliders[3]=cp5.addSlider("DYNINDEXlower",0,audio_decisor.getDynIndexUpperThreshold(),left,top+posY+20,len,thick);
  sliders[3].setCaptionLabel("DYN INDEX LOWER Th");
  posY+=increment;

  sliders[4]=cp5.addSlider("CENTROIDupper",audio_decisor.getCentroidLowerThreshold(),7000,left,top+posY,len,thick);
  sliders[4].setCaptionLabel("CENTROID upper Th");
  sliders[5]=cp5.addSlider("CENTROIDlower",0,audio_decisor.getCentroidUpperThreshold(),left,top+posY+20,len,thick);
  sliders[5].setCaptionLabel("CENTROID LOWER Th");
  posY+=increment;

  sliders[6]=cp5.addSlider("COMPLEXITYupper",audio_decisor.getComplexityLowerThreshold(),50,left,top+posY,len,thick);
  sliders[6].setCaptionLabel("COMPLEXITY upper Th");
  sliders[7]=cp5.addSlider("COMPLEXITYlower",0,audio_decisor.getComplexityUpperThreshold(),left,top+posY+20,len,thick);
  sliders[7].setCaptionLabel("COMPLEXITY LOWER Th");
  posY+=increment;

  sliders[8]=cp5.addSlider("RSTRENGTHupper",audio_decisor.getRhythmStrLowerThreshold(),400,left,top+posY,len,thick);
  sliders[8].setCaptionLabel("RHYTHM STR upper Th");
  sliders[9]=cp5.addSlider("RSTRENGTHlower",0,audio_decisor.getRhythmStrUpperThreshold(),left,top+posY+20,len,thick);
  sliders[9].setCaptionLabel("RHYTHM STR LOWER Th");
  posY+=increment;

  sliders[10]=cp5.addSlider("RDENSITYupper",audio_decisor.getRhythmDensLowerThreshold(),9,left,top+posY,len,thick);
  sliders[10].setCaptionLabel("RHYTHM DENS upper Th");
  sliders[11]=cp5.addSlider("RDENSITYlower",0,audio_decisor.getRhythmDensUpperThreshold(),left,top+posY+20,len,thick);
  sliders[11].setCaptionLabel("RHYTHM DENS LOWER Th");
  posY+=increment;

  sliders[12] = cp5.addSlider("COBEupper",audio_decisor.getCOBELowerThreshold(), 1 ,left ,top+posY ,len ,thick);
  sliders[12].setCaptionLabel("COBE upper Th");
  sliders[13] = cp5.addSlider("COBElower",0, audio_decisor.getCOBEUpperThreshold(), left, top+posY+20, len, thick);
  sliders[13].setCaptionLabel("COBE lower Th");
  posY+=increment;

  sliders[14] = cp5.addSlider("EBFupper",audio_decisor.getEBFLowerThreshold(), 7000 ,left ,top+posY ,len ,thick);
  sliders[14].setCaptionLabel("EBF upper Th");
  sliders[15] = cp5.addSlider("EBFlower",0, audio_decisor.getEBFUpperThreshold(), left, top+posY+20, len, thick);
  sliders[15].setCaptionLabel("EBF lower Th");
  posY+=increment;

  sliders[16] = cp5.addSlider("SkewnessDupper",audio_decisor.getSkewnessDLowerThreshold(), 12 ,left ,top+posY ,len ,thick);
  sliders[16].setCaptionLabel("SKEWNESS D upper Th");
  sliders[17] = cp5.addSlider("SKewnessDlower",0, audio_decisor.getSkewnessDUpperThreshold(), left, top+posY+20, len, thick);
  sliders[17].setCaptionLabel("SKEWNESS D lower Th");
  posY+=increment;

  sliders[18] = cp5.addSlider("SkewnessEupper",audio_decisor.getSkewnessELowerThreshold(), 2 ,left ,top+posY ,len ,thick);
  sliders[18].setCaptionLabel("SKEWNESS E upper Th");
  sliders[19] = cp5.addSlider("SKewnessElower",0, audio_decisor.getSkewnessEUpperThreshold(), left, top+posY+20, len, thick);
  sliders[19].setCaptionLabel("SKEWNESS E lower Th");
  posY+=increment;

  sliders[20] = cp5.addSlider("Roughnessupper",audio_decisor.getSkewnessELowerThreshold(), 1 ,left ,top+posY ,len ,thick);
  sliders[20].setCaptionLabel("ROUGHNESS upper Th");
  sliders[21] = cp5.addSlider("Roughnesslower",0, audio_decisor.getSkewnessEUpperThreshold(), left, top+posY+20, len, thick);
  sliders[21].setCaptionLabel("ROUGHNESS lower Th");


  for(int i = 0; i < 22; i++)
  {
   sliders[i].setSliderMode(Slider.FLEXIBLE);
   sliders[i].setGroup(controls);
   sliders[i].getCaptionLabel().toUpperCase(true);
   sliders[i].getCaptionLabel().getStyle().padding(4,3,3,3);
   sliders[i].getCaptionLabel().getStyle().marginTop = -4;
   sliders[i].getCaptionLabel().getStyle().marginLeft = 0;
   sliders[i].getCaptionLabel().getStyle().marginRight = -14;
   sliders[i].getCaptionLabel().setColorBackground(0x99ffffff);
  }

  //RESET BUTTON
  default_button=cp5.addButton("restoreDefault").setValue(0);
  default_button.setCaptionLabel("RESET");
  default_button.setPosition(left,top+posY+ 40);
  default_button.setGroup(controls);

}

void drawGUI()
{
  cp5.show();
  cp5.draw();
  updateParams();
  updateRanges();
}

void updateParams()
{
  audio_decisor.setRMSLowerBound(RMSlower);
  audio_decisor.setRMSUpperBound(RMSupper);

  audio_decisor.setDynIndexLowerBound(DYNINDEXlower);
  audio_decisor.setDynIndexUpperBound(DYNINDEXupper);

  audio_decisor.setCentroidLowerBound(CENTROIDlower);
  audio_decisor.setCentroidUpperBound(CENTROIDupper);

  audio_decisor.setComplexityLowerBound(COMPLEXITYlower);
  audio_decisor.setComplexityUpperBound(COMPLEXITYupper);

  audio_decisor.setRhythmStrLowerBound(RSTRENGTHlower);
  audio_decisor.setRhythmStrUpperBound(RSTRENGTHupper);

  audio_decisor.setRhythmDensLowerBound(RDENSITYlower);
  audio_decisor.setRhythmDensUpperBound(RDENSITYupper);

  audio_decisor.setCOBELowerBound(COBElower);
  audio_decisor.setCOBEUpperBound(COBEupper);

  audio_decisor.setEBFLowerBound(EBFlower);
  audio_decisor.setEBFUpperBound(EBFupper);

  audio_decisor.setSkewnessDLowerBound(SkewnessDlower);
  audio_decisor.setSkewnessDUpperBound(SkewnessDupper);

  audio_decisor.setSkewnessELowerBound(SkewnessElower);
  audio_decisor.setSkewnessEUpperBound(SkewnessEupper);

  audio_decisor.setRoughnessLowerBound(Roughnesslower);
  audio_decisor.setRoughnessUpperBound(Roughnessupper);

  global_audio.setMasterGain(inVol);
}

void updateRanges()
{
  sliders[0].setRange(audio_decisor.getRMSLowerThreshold(),1);
  sliders[1].setRange(0,audio_decisor.getRMSUpperThreshold());

  sliders[2].setRange(audio_decisor.getDynIndexLowerThreshold(),1);
  sliders[3].setRange(0,audio_decisor.getDynIndexUpperThreshold());

  sliders[4].setRange(audio_decisor.getCentroidLowerThreshold(),7000);
  sliders[5].setRange(0,audio_decisor.getCentroidUpperThreshold());

  sliders[6].setRange(audio_decisor.getComplexityLowerThreshold(),50);
  sliders[7].setRange(0,audio_decisor.getComplexityUpperThreshold());

  sliders[8].setRange(audio_decisor.getRhythmStrLowerThreshold(),400);
  sliders[9].setRange(0,audio_decisor.getRhythmStrUpperThreshold());

  sliders[10].setRange(audio_decisor.getRhythmDensLowerThreshold(),9);
  sliders[11].setRange(0,audio_decisor.getRhythmDensUpperThreshold());

  sliders[12].setRange(audio_decisor.getCOBELowerThreshold(),    1   );
  sliders[13].setRange(0, audio_decisor.getCOBEUpperThreshold());

  sliders[14].setRange(audio_decisor.getEBFLowerThreshold(),    7000   );
  sliders[15].setRange(0, audio_decisor.getEBFUpperThreshold());

  sliders[16].setRange(audio_decisor.getSkewnessDLowerThreshold(),    12   );
  sliders[17].setRange(0,  audio_decisor.getSkewnessDUpperThreshold());

  sliders[18].setRange(audio_decisor.getSkewnessELowerThreshold(),    2    );
  sliders[19].setRange(0,  audio_decisor.getSkewnessEUpperThreshold());

  sliders[20].setRange(audio_decisor.getRoughnessLowerThreshold(),  1  );
  sliders[21].setRange(0,  audio_decisor.getRoughnessUpperThreshold());


}

public void restoreDefault()
{
 sliders[0].setValue(DefaultAudioThresholds.RMS_UPPER_TH);
 sliders[1].setValue(DefaultAudioThresholds.RMS_LOWER_TH);

 sliders[2].setValue(DefaultAudioThresholds.DYNINDEX_UPPER_TH);
 sliders[3].setValue(DefaultAudioThresholds.DYNINDEX_LOWER_TH);

 sliders[4].setValue(DefaultAudioThresholds.CENTROID_UPPER_TH);
 sliders[5].setValue(DefaultAudioThresholds.CENTROID_LOWER_TH);

 sliders[6].setValue(DefaultAudioThresholds.COMPLEXITY_UPPER_TH);
 sliders[7].setValue(DefaultAudioThresholds.COMPLEXITY_LOWER_TH);

 sliders[8].setValue(DefaultAudioThresholds.RHYTHMSTR_UPPER_TH);
 sliders[9].setValue(DefaultAudioThresholds.RHYTHMSTR_LOWER_TH);

 sliders[10].setValue(DefaultAudioThresholds.RHYTHMDENS_UPPER_TH);
 sliders[11].setValue(DefaultAudioThresholds.RHYTHMDENS_LOWER_TH);

 sliders[12].setValue(DefaultAudioThresholds.COBE_UPPER_TH);
 sliders[13].setValue(DefaultAudioThresholds.COBE_LOWER_TH);

 sliders[14].setValue(DefaultAudioThresholds.EBF_UPPER_TH);
 sliders[15].setValue(DefaultAudioThresholds.EBF_LOWER_TH);

 sliders[16].setValue(DefaultAudioThresholds.SKEWNESSD_UPPER_TH);
 sliders[17].setValue(DefaultAudioThresholds.SKEWNESSD_LOWER_TH);

 sliders[18].setValue(DefaultAudioThresholds.SKEWNESSE_UPPER_TH);
 sliders[19].setValue(DefaultAudioThresholds.SKEWNESSE_LOWER_TH);

 sliders[20].setValue(DefaultAudioThresholds.ROUGHNESS_UPPER_TH);
 sliders[21].setValue(DefaultAudioThresholds.ROUGHNESS_LOWER_TH);
}