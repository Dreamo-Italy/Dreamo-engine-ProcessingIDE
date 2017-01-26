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
      
          incomingValues = global_connection.extractFromBuffer("ecg", numToExtract ); // store the incoming conductance value from Connection to another FloatLIst
          float[] Analysis= incomingValues.array();
          float[] FilteredHp = dsp.HighPass (Analysis, 50.0,256.0);
          float[] FilteredLpHp = dsp.LowPass (FilteredHp, 100.0,256.0);
          float[] Check = {0,0,0,0,0,0,0,0.5,0.4,2,0.4,0,0,0,0,0,0,0,0,0,0,0,0.4,0.4,2,0.4,0,0,0,0,0,0};
          
          BPM=bpm.ECGBPM(FilteredLpHp);
          
          //BPM=60;
           println("BPM:"+ BPM );
          
          println("Number of ECG elements to extract: " + numToExtract );
          println("ECG buffer size: "+ incomingValues.size() );   
     }
     else
       BPM = this.getValue();
        
     setValue  ( BPM );
     
     if ( ! ( incomingValues == null ) )
       checkCalibration();    
  }
  
}