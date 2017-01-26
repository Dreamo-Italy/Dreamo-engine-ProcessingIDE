class Ecg extends Biosensor
{
  
  private FloatList StoreEcg;
  //StoreEcg = new FloatList();
  
        public void init()
        {
              sensorName = "ecg";   
        }
      
    
        public void update()
        {     
        println("DEBUG: ECG update.");     
        float BPM=20; 
        DSP dsp =new DSP();
        DSP bpm =new DSP();
        StoreEcg = new FloatList();

        if(frameCount % 1 == 0)
        {
          int numToExtract = ceil (global_sampleRate/frameRate);
      // Per GIOVA: la connessione offline sembra non funzionare, la Floatlist incomingValues è sempre vuota,
      // come segnalato dal println sottostante.
      
          incomingValues = global_connection.extractFromBuffer("ecg", numToExtract ); // store the incoming conductance value from Connection to another FloatLIst
          StoreEcg.append(incomingValues);
          
          float[] Check = {0,0,0,0,0,0,0,0.5,0.4,2,0.4,0,0,0,0,0,0,0,0,0,0,0,0.4,0.4,2,0.4,0,0,0,0,0,0};          
       
          println("Number of ECG elements to extract: " + numToExtract );
          println("ECG buffer size: "+ incomingValues.size() );  
          
     }
     
     
      if(StoreEcg.size()> 300){
        
        float[] Analysis= StoreEcg.array();
        float[] FilteredHp = dsp.HighPass (Analysis, 50.0,256.0);
        float[] FilteredLpHp = dsp.LowPass (FilteredHp, 100.0,256.0);
        println("BPM:"+ BPM );
        BPM=bpm.ECGBMP(FilteredLpHp);
        println("BPM:"+ BPM );
        StoreEcg.clear();
     }else
       BPM = this.getValue();
     
     setValue  ( BPM );
     
     if ( ! ( incomingValues == null ) )
       checkCalibration();    
  }
  
}