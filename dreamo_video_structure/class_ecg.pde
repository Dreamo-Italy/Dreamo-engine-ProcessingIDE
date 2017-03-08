class Ecg extends Biosensor
{
  
  private FloatList StoreEcg;
  DSP dsp, bpm;
  float BPM;
  //StoreEcg = new FloatList();
  
        public void init()
        {
              sensorName = "ecg";   
              BPM = 20;
              setValue( BPM );
              StoreEcg = new FloatList();
              dsp =new DSP();
              bpm = new DSP();
        }
      
    
        public void update()
        {     
        //println("DEBUG: ECG update.");  

      
      incomingValues = global_connection.extractFromBuffer("ecg", sampleToExtract ); // store the incoming conductance value from Connection to another FloatLIst
      
      if(incomingValues != null && incomingValues.size() != 0)
      {
        StoreEcg.append(incomingValues);                         
        //println("Number of ECG elements to extract: " + sampleToExtract );
        //println("ECG buffer size: "+ incomingValues.size() );  
        //println("Highest ECG peak: "+ max(StoreEcg.array()) );
      }

     
     // println("StoreEcg size: "+StoreEcg.size() );
      if(StoreEcg.size()> global_sampleRate*60){
        
        float[] Analysis= StoreEcg.array();
        float[] FilteredHp = dsp.HighPass (Analysis, 50.0,256.0);
        //float[] FilteredLpHp = dsp.LowPass (Analysis, 100.0,256.0);
        println("BPM: "+ BPM ); println();
        BPM = bpm.ECGBPM3(Analysis);    
        StoreEcg.clear();
     }else
       BPM = this.getValue();
     
     setValue  ( incomingValues.get(0) );
     println("BPM:"+ BPM );

     
     if ( ! ( incomingValues == null ) )
       checkCalibration();    
  }
  
}