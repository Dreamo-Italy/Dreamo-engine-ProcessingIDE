class Ecg extends Biosensor
{
  private FloatList StoreEcg;
  DSP bpm;
  public float BPM,RRdist,BPM2;
  public Boolean FlagTachy = false;
  public Boolean FlagBrad = false;
  public final int filteredMax = 15;
  int flag1=0;
  
  private final float minBufferSize = global_sampleRate*60;
  
    public void init()
    {
          sensorName = "ecg";   
          BPM = 20;
          setBpm( BPM );
          StoreEcg = new FloatList();
          
          physicalMin = 0;
          physicalMax = 5;          
    }
  

    public void update()
    {     
      int added = 0;
     incomingValues = global_connection.extractFromBuffer("ecg", sampleToExtract ); // store the incoming conductance value from Connection to another FloatLIst
     for (int i = (incomingValues.size()-1); i > 0; i--) {
          float newFloat = incomingValues.get(i);
          if ( newFloat < physicalMax )
              {
                StoreEcg.append(newFloat);
                added++;
              }
         }    
    
    if(StoreEcg.size()> minBufferSize) {
      for(int i =0; i<added; i++)
         StoreEcg.remove(i);
    }
           
    //println("Number of ECG elements to extract: " + sampleToExtract );
    //println("ECG buffer size: "+ incomingValues.size() );  
    //println("Highest ECG peak: "+ max(StoreEcg.array()) );
 
    println("StoreEcg size: "+StoreEcg.size() );
    
    float [] ecgPreFilter = StoreEcg.array();
    float [] ecgPostFilter = filterEcgData(ecgPreFilter);
    
    if(StoreEcg.size()> minBufferSize-1) 
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
     }
     else
       BPM = this.getBpm();
     
     float newValue = DSP.vmax(filterEcgData(incomingValues.array()));
     if ( newValue < filteredMax )
       setValue  ( newValue );
     setBpm( BPM );
     println("BPM:"+ BPM );
     //println("NEW BPM:"+ BPM2 );
     
     
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