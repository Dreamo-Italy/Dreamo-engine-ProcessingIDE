class Ecg extends Biosensor
{
  
  private FloatList StoreEcg;
  DSP dsp, bpm,bpm2, RR;
  public float BPM,RRdist,BPM2;
  public Boolean FlagTachy=false;
  public Boolean FlagBrad=false;
  int flag1=0;
  //StoreEcg = new FloatList();
  
        public void init()
        {
              sensorName = "ecg";   
              BPM = 20;
              setValue( BPM );
              StoreEcg = new FloatList();
              dsp =new DSP();
              bpm = new DSP();
              bpm2 = new DSP();
              
        }
      
    
        public void update()
        {     
        println("DEBUG: ECG update.");     
        

        if(frameCount % 1 == 0)
        {
          //int numToExtract = ceil (global_sampleRate/frameRate);
      // Per GIOVA: la connessione offline sembra non funzionare, la Floatlist incomingValues è sempre vuota,
      // come segnalato dal println sottostante.
      
          incomingValues = global_connection.extractFromBuffer("ecg", numToExtract ); // store the incoming conductance value from Connection to another FloatLIst
          StoreEcg.append(incomingValues);
                 
          println("Number of ECG elements to extract: " + numToExtract );
          println("ECG buffer size: "+ incomingValues.size() );  
          println("Highest ECG peak: "+ max(StoreEcg.array()) );

          
       }
     
     println("StoreEcg size: "+StoreEcg.size() );
      if(StoreEcg.size()> global_sampleRate*60){
        
        float[] Analysis= StoreEcg.array();
        float[] FilteredHp = dsp.HighPass (Analysis, 50.0,global_sampleRate);
        float[] ampli = dsp.times(FilteredHp,100);
        float[] FilteredLpHp = dsp.LowPassFS (ampli, 100.0,global_sampleRate);
        float[] ampli2 = dsp.times(FilteredLpHp,100);
        
        BPM  = bpm.ECGBPM3(ampli2);
        BPM2 = bpm2.ECGBPMLAST(ampli2);
        flag1=1;
        
        if (BPM<60){ 
          println("BRADYCARDIA");
          FlagBrad=true;
          // rallentare le scene
        }else{FlagBrad=false;}
        if (BPM>110){
          
          FlagTachy=true;
          //agitare le scene 
        }else{FlagTachy=false;}
        StoreEcg.clear();
     }else
       BPM = this.getValue();
     
        
     setValue  ( BPM );
     println("BPM:"+ BPM );
     println("NEW BPM:"+ BPM2 );
     
    if (flag1==1) exit();
     
     // segnala lo stato dell'utente
     if (FlagTachy)  
     println("THACYCARDIA");
     if (FlagBrad)  
     println("BRADYCARDIA");
     if ((!FlagBrad) &&(!FlagTachy))
     println("NORMAL MOOD");
     if ((FlagBrad) &&(FlagTachy))
     println("ERROR MOOD");
     
     if ( ! ( incomingValues == null ) )
       checkCalibration();    
  }
  
}