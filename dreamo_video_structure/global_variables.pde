//package dreamo.display;
//GLOBAL VARIABLES 
int global_fps = 30;

//keeps count of the number of particles that have been instantiated from the beginning of the program
long global_particlesInstanciatedNumber = 0; 
float global_sampleRate = 100; 
//////////////////////////////////////////////////////////////////////////////////
String globalGsrTable = "LastLogGsr.csv";///"log_conductance_SIM.csv";////
String globalEcgTable = "TheVeryLastLogEcg.csv";///"log_ecg_SIM.csv";////
//////////////////////////////////////////////////////////////////////////////////	
final int SCENES_MAX = 100; 
final int SOGLIA_SEL = 12;
final int CHANGE_CHECK = 4*8;

final int PALETTE_THRESHOLD=3;

final int interlineSpace = 24;
final int marginSpace = 10;

//main object for display
Stage global_stage; 
//main object for connections
Connection global_connection;

Gsr global_gsr;
Ecg global_ecg;

BioMood global_bioMood;

short global_sensorNumber = 2;

DebugPlot global_debugPlots;

//global audio objects
AudioManager global_audio;
AudioProcessor audio_proc;
//Tone global_tone;
//Rhythm global_rhythm;
Dynamic global_dyn;
Timbre global_timbre;
Rhythm global_rhythm;

AudioDecisor audio_decisor;