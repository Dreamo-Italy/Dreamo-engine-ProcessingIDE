public final static class DefaultAudioThresholds 
{
 private DefaultAudioThresholds() {}

 static public float RMS_LOWER_TH = 0.3;  // il valore  da inserire è la somma dei due valori del ciclo di isteresi per il lower bound diviso 2 
 static public float RMS_UPPER_TH = 0.56; // il valore  da inserire è la somma dei due valori del ciclo di isteresi per il upper bound diviso 2

 static public float DYNINDEX_LOWER_TH = 0.1;
 static public float DYNINDEX_UPPER_TH = 0.19;

 static public float CENTROID_LOWER_TH = 2050;
 static public float CENTROID_UPPER_TH = 3000;

 static public float COMPLEXITY_LOWER_TH = 11;
 static public float COMPLEXITY_UPPER_TH = 18;

 static public float RHYTHMSTR_LOWER_TH = 27.5;
 static public float RHYTHMSTR_UPPER_TH = 125;

 static public float RHYTHMDENS_LOWER_TH = 1.5;
 static public float RHYTHMDENS_UPPER_TH = 4;
 
 static public float COBE_LOWER_TH = 0.07;
 static public float COBE_UPPER_TH = 0.13;
 
 static public float EBF_LOWER_TH = 1250;
 static public float EBF_UPPER_TH = 1800;
 
 static public float SKEWNESSD_LOWER_TH = 5.5;
 static public float SKEWNESSD_UPPER_TH = 9;
 
 static public float SKEWNESSE_LOWER_TH = 0.5;
 static public float SKEWNESSE_UPPER_TH = 0.75;
 
 static public float ROUGHNESS_LOWER_TH = 0.02;
 static public float ROUGHNESS_UPPER_TH = 0.065;
}
