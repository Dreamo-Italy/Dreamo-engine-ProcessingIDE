//package dreamo.display;
//GLOBAL VARIABLES

import grafica.*;

short global_fps = 30;

//keeps count of the number of particles that have been instantiated from the beginning of the program
long global_particlesInstanciatedNumber = 0;

short global_sampleRate = 100;


//main object for display
Stage global_stage;

//main object for connections
Connection global_connection;

Gsr global_gsr;
Ecg global_ecg;

short global_sensorNumber = 2;

DebugPlot global_debugPlots;

//global audio objects
AudioManager global_audio;
AudioProcessor audio_proc;
//Tone global_tone;
//Rhythm global_rhythm;
Dynamic global_dyn;
Timbre global_timbre;
