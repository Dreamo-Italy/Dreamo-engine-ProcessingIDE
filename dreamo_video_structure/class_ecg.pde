class Ecg extends Biosensor
{
  
        public void init()
        {
              sensorName = "ecg";   
        }
      
    
        public void update()
        {     
        println("DEBUG: ECG update.");     
        float BPM;        
        DSP dsp =new DSP();
        DSP bpm =new DSP();
        if(frameCount % 1 == 0)
        {
          int numToExtract = ceil (global_sampleRate/frameRate);
          long initTimeT = System.nanoTime();     
      
<<<<<<< HEAD
          incomingValues = global_connection.extractFromBuffer("ecg", numToExtract ); // store the incoming ECG value from Connection to another Floatlist
          //float[] Analysis= incomingValues.array();  // Convert to array the floatlist
          //float[] FilteredHp = dsp.HighPass (Analysis, 50.0,256.0);    // use the DSP IIR filter to clean the signal
          //float[] FilteredLpHp = dsp.LowPass (FilteredHp, 100.0,256.0);
          float[] Check = {0,0,0,0,0,0,0,0.5,0.4,2,0.4,0,0,0,0,0,0,0,0,0,0,0,0.4,0.4,2,0.4,0,0,0,0,0,0};
          BPM=bpm.ECGBPM(Check);    // use the ECGBPM function 
=======
          incomingValues = global_connection.extractFromBuffer("ecg", numToExtract ); // store the incoming conductance value from Connection to another FloatLIst
          float[] Analysis= incomingValues.array();
          float[] FilteredHp = dsp.HighPass (Analysis, 50.0,256.0);
          float[] FilteredLpHp = dsp.LowPass (FilteredHp, 100.0,256.0);
          BPM=bpm.ECGBPM(FilteredLpHp);
>>>>>>> fcf1d58a2acfea8d42caa2135affe5e5a61fd1bf
          //BPM=60;
           println("BPM:"+BPM );
          //long bufT = System.nanoTime() - initTimeT; // duration of ExtractFromBuffer
          
          println("Number of elements to extract: " + numToExtract );
          println("buffer size: "+ incomingValues.size() );   
     }
     else
       BPM = this.getValue();
        
     setValue  ( BPM );
     
     if ( ! ( incomingValues == null ) )
       checkCalibration();
       
    // println("    Extract from buffer time: "+ bufT/1000 + " us");
     println("");
    
  }
  
}