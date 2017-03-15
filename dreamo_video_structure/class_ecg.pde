class Ecg extends Biosensor
{
  private FloatList StoreEcg;
  DSP bpm;
  public float BPM,RRdist,BPM2;
  public Boolean FlagTachy = false;
  public Boolean FlagBrad = false;
  int flag1=0;
  
    public void init()
    {
          sensorName = "ecg";   
          BPM = 20;
          setValue( BPM );
          StoreEcg = new FloatList();
          
          physicalMin = 0;
          physicalMax = 5;          
    }
  

    public void update()
    {     
    incomingValues = global_connection.extractFromBuffer("ecg", sampleToExtract ); // store the incoming conductance value from Connection to another FloatLIst
    println(incomingValues.size() );
    for (int i = (incomingValues.size()-1); i > 0; i--) {
          float newFloat = incomingValues.get(i);
          if ( value < physicalMin )
              StoreEcg.append(newFloat);
          incomingValues.remove(i);
         }    
         
    StoreEcg.append(incomingValues);
           
    //println("Number of ECG elements to extract: " + sampleToExtract );
    //println("ECG buffer size: "+ incomingValues.size() );  
    //println("Highest ECG peak: "+ max(StoreEcg.array()) );
 
    println("StoreEcg size: "+StoreEcg.size() );
    
    float [] ecgPreFilter = StoreEcg.array();
    float [] ecgPostFilter = filterEcgData( ecgPreFilter);
    
    if(StoreEcg.size()> global_sampleRate*60) 
    {           
        BPM = ECGBPM3(ecgPostFilter);
        BPM2 = ECGBPMLAST(ecgPostFilter);
          
        flag1 = 1;
        
        if (BPM<60){ 
          println("BRADYCARDIA");
          FlagBrad=true;
          // rallentare le scene
        }
        else
         FlagBrad=false;
        
        if (BPM>110){        
          FlagTachy=true;
          //agitare le scene 
        }
        else
          FlagTachy=false;
          
       StoreEcg.clear();
    }
     else
       BPM = this.getBpm();
     
        
     setValue  ( ecgPostFilter[ ecgPostFilter.length -1] );
     setBpm( BPM );
     println("BPM:"+ BPM );
     println("NEW BPM:"+ BPM2 );
     
     
     // segnala lo stato dell'utente
     if (FlagTachy)  
     println("THACYCARDIA");
     if (FlagBrad)  
     println("BRADYCARDIA");
     if ((!FlagBrad) &&(!FlagTachy))
     println("NORMAL MOOD");
     if ((FlagBrad) &&(FlagTachy))
     println("ERROR MOOD");
     
     //if ( ! ( incomingValues == null ) )
      // checkCalibration();    
  }
  

  
}