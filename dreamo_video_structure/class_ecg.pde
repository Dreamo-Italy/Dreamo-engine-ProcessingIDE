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
  
  protected float [] filterEcgData(float...arrayIn)
  {
      //System.arraycopy(Object src, int srcPos, Object dest, int destPos, int length)

      float [] filtered = new float[arrayIn.length];
      filtered = Arrays.copyOf(arrayIn,arrayIn.length );
      //System.arraycopy(arrayIn, 0, filtered, 0, arrayIn.length);
      
      filtered = DSP.HighPass (filtered, 0.001, global_sampleRate);
      filtered = DSP.HWR(filtered);
      filtered = DSP.times(filtered,10);
      filtered = DSP.LowPassSP( filtered, 0.25, global_sampleRate);
      filtered = DSP.times(filtered,25);
      filtered = DSP.MAfilter(filtered, arrayIn.length);

      for (int i=0; i<filtered.length;i++){
      filtered[i]= filtered[i]*filtered[i];
      if(filtered[i]>0.6){filtered[i]=2;
      filtered[i]= filtered[i]*filtered[i];}
    }
      filtered = differentiateArray(filtered);  
    
      return filtered;
  }
  
  /******************************************************************************************************/
 //TODO: move this into ECG class
 // strani errori nel log se ECGBPM sopra 80 bpm circa 60 bpm per ECGBPMLAST
 // invece se ECGBPM sotto 40 bpm circa 80 bpm per ECGBPMLAST
 // il trend è sempre lo stesso i valori cambiano a seconda della threshold per
 // RRdistanceSecond
 // riguardare potenziali errori
 public int ECGBPMLAST(float[] input)
 {
   float a [] = new float[input.length];
    a = Arrays.copyOf(input, input.length);
    
    int Beatcount=0;
    int BPM;
    float index=0,lastPeak=0, lastPeak2=0, nSample=0;
    float RRdistanceSecond=0;
    int N = a.length; //numToExtract*frameRate*5 
    boolean flag=false;
    
    

    //signal evaluation and peaks counter
    for(int i=0;i<N-1;i++){
       
      if(a[i]> 0.7 && a[i+1]>=a[i] ){
   
          
          if(!flag){
      
          index=i;
          nSample=index-lastPeak;
          RRdistanceSecond=nSample/global_sampleRate;
          
          if (RRdistanceSecond > 0.6 ) {
             Beatcount++;
             flag=true;
             lastPeak2=index;
          }
        
        }
        } else {
        flag=false; lastPeak=lastPeak2;
      }
    }
 
     println("max filtered " + RRdistanceSecond);
     // BPM detector 
     BPM = Beatcount;
     return BPM;
   }
  
 /******************************************************************************************************/
 
  //TODO: move this into ECG class
  public int ECGBPM3(float[] input)
  {
    float a [] = new float[input.length];
    a = Arrays.copyOf(input, input.length);
    
    int Beatcount=0;
    int BPM;
    int N = a.length; //numToExtract*frameRate*5 
    boolean flag=false;
    
    
     float newMax = max ( a); 
     println("max filtered " + newMax);

    //signal evaluation and peaks counter
    for(int i=0;i<N-1;i++)
    {
        if(a[i]> 0.7 /*&& a[i]>a[i-1] */&& a[i]<=a[i+1])
        {
          if (!flag)
          {
            Beatcount++; 
            //flag=true;
          }
        }
        else
          flag = false;
      }
     
     
     // BPM detector 
     
       BPM = Beatcount;
       return BPM;
   }
   
   /******************************************************************************************************/
   //TODO: move this into ECG class
   //BPM ECG (non funziona?)
   public int ECGBPM(float[] a){
     
    int beatcount=0;
    int BPM;
    int N= a.length; 
    int fs=256;
    
    for(int i=1;i<N-1;i++){
        if( (a[i]>a[i-1]) && a[i]>a[i+1] && a[i]>1.5){
         beatcount++;
        }
      }
      
       float duration_second = 1/30; //replace 30 with global_fps
       float duration_minute = 60;
       
       //float duration_second= (float)N/fs;
       //float dur_min=duration_second/60;
       
       BPM = round(beatcount * duration_minute / duration_second );
       return BPM;
   }    
/******************************************************************************************************/
   //TODO: move this into ECG class
   public int ECGBPM2(FloatList a){
    int Beatcount=0;
    int BPM;
    int N= a.size(); 
    int fs=256;
    boolean flag=false;
    //Squaring the signal to increase the peak
    for (int i=0; i<N;i++){
     a.set(i,sq(a.get(i)));
    } 
    //signal evaluation and peaks counter
    for(int i=1;i<N-1;i++){
        if(a.get(i)>1.8){
          if (!flag){
          Beatcount++;
          flag=true;
          }
        }else{flag=false;}
      }
     // BPM detector 
       float duration_second = 1/30;
       float dur_min=60;
       BPM=round(Beatcount* dur_min/duration_second );
       return BPM;
   }


/******************************************************************************************************/
 //TODO: move this into ECG class
  public float RRdistance(float[] a){
    
    float indexs=0, indexsold=0, RRdist=0;
    int N= a.length; //numToExtract*frameRate*5 
    boolean flag=false;

    // Differentiator
    for (int i=0; i<N;i++){
      if(i>3){a[i]= 0.1*(2*a[i] + a[i-1] -a[i-3]-2*a[i-4]);}
     }
    
    //Squaring the signal to increase the peak
    for (int i=0; i<N;i++){
      a[i]= a[i]*a[i];
      //if(a[i] < 0.05) 
      //  a[i] = 0;
    }
    
    //signal evaluation and peaks counter
    for(int i=1;i<N-1;i++){
        if(a[i]> 36000 && a[i]>a[i-1] && a[i+1]>a[i]){
          if (!flag){
          indexs=i/100;
          flag=true;
          }
        }else{flag=false;}
        indexs=indexsold;
        if (indexs>indexsold && indexs!=0 && indexsold!=0){
           RRdist=indexs-indexsold;
          
        }
      
      }
      return RRdist;
       
   }
  
 
  

  
}