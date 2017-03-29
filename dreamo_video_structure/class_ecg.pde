class Ecg extends Biosensor
{
  private FloatList StoreEcg;
  DSP bpm;
  public float BPM,RRdist,BPM2,stdDev,Variate,emotionPar;
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
     incomingValues = global_connection.extractFromBuffer("ecg", sampleToExtract*2 ); // store the incoming conductance value from Connection to another FloatLIst
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
    if(StoreEcg.size()> (minBufferSize)-1) 
    {
        float [] tacogram= Tacogramm(ecgPostFilter);
        
        stdDev= StandardDev(tacogram,0);
        Variate  = StandardDev(tacogram,1);
        BPM  = ECGBPMLAST(ecgPostFilter,0);
        BPM2 = ECGBPMLAST(ecgPostFilter,1);
        emotionPar = emotionScale(); 
        flag1 = 1;
        
        if (BPM<50){ 
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
       {
         BPM = this.getBpm();
         stdDev= this.getStDev();
         Variate=this.getVarEcg();
         emotionPar=this.getEmotionPar();
       }
     float newValue = DSP.vmax(filterEcgData(incomingValues.array()));
     if ( newValue < filteredMax )
     
     setValue  ( newValue );
     setStDev( stdDev );
     setVarEcg( Variate );
     setBpm( BPM );
     setEmotionPar( emotionPar );
     println("BPM:"+ BPM );
     println("NEW BPM:"+ BPM2);
     println("standard deviation:" + stdDev);
     println("EmotionPar" + emotionPar);
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
      filtered = DSP.times(filtered,5);
      filtered = DSP.LowPassSP( filtered, 0.25, global_sampleRate);
      filtered = DSP.times(filtered,50);
      //filtered = DSP.MAfilter(filtered, arrayIn.length);
     // filtered = differentiateArray(filtered);  

      filtered = Square(filtered);
   
  
    
      return filtered;
  }
  
  /******************************************************************************************************/

 
 public float[] Square(float [] input)
 {
       float a [] = new float[input.length];
       a = Arrays.copyOf(input, input.length);
       
      for (int i=0; i<a.length;i++){
      a[i]= a[i]*a[i];
      if(a[i]>1){
      }else{ a[i]=0.1;}
      
     
      }
      return a;
 }
 
 /******************************************************************************************************/
     int BPMlast, BPMHRV=20;
float RRdistanceSecond=0,RRdistanceSecondOld=1;
float RRdistanceSecond1=0,RRdistanceSecondOld1=1;

 public int ECGBPMLAST(float[] input, int b)
 {
   float a [] = new float[input.length];
    a = Arrays.copyOf(input, input.length);
    
    int Beatcount=0;

    float index=0,lastPeak=0, nSample=0;

    int N = a.length; //numToExtract*frameRate*5 

    //signal evaluation and peaks counter
    for(int i=0;i<N-1;i++){
       
      if(a[i]>3 && a[i]<a[i+1]){
       
          index=i;
          nSample=index-lastPeak;
          RRdistanceSecond=nSample/(global_sampleRate);
          
          if (RRdistanceSecond > 0.48 && RRdistanceSecond<1.9) {
             if (RRdistanceSecondOld >RRdistanceSecond + ((RRdistanceSecond/100)*12))
                 RRdistanceSecondOld=1;
             
             if (RRdistanceSecond >( RRdistanceSecondOld - ((RRdistanceSecondOld/100)*12))){
             Beatcount++;
             BPMHRV=round(60/RRdistanceSecond);
             RRdistanceSecondOld=RRdistanceSecond;
             lastPeak=index;
           } 
          }
        }   
    }
     if (b==1){
     println("n samples " + nSample);
     println("RR dist " + RRdistanceSecondOld);
     println("last peak " + lastPeak);
     println("BPM 2 " + BPMHRV);
     // BPM detector 
     return BPMHRV;
     }
     else
     {
     BPMlast = Beatcount;
     return BPMlast;
     }
   }
   
 /******************************************************************************************************/
   
    public float[] Tacogramm(float[] input)
 {
   float a [] = new float[input.length];
    a = Arrays.copyOf(input, input.length);
    
    int Beatcount=0;
    FloatList tacogram = new FloatList();
    float index=0,lastPeak=0, nSample=0;
    
    int N = a.length; 

    //signal evaluation 
    for(int i=0;i<N-1;i++){
       
      if(a[i]>3 && a[i]<a[i+1]){
       
          index=i;
          nSample=index-lastPeak;
          RRdistanceSecond1=nSample/(global_sampleRate);
          
          if (RRdistanceSecond1 > 0.48 && RRdistanceSecond1<1.9) {
             if (RRdistanceSecondOld1 >RRdistanceSecond1 + ((RRdistanceSecond1/100)*12))
                 RRdistanceSecondOld1=1;
             
             if (RRdistanceSecond1 >( RRdistanceSecondOld1 - ((RRdistanceSecondOld/100)*12))){
             Beatcount++;
             BPMHRV=round(60/RRdistanceSecond);
             RRdistanceSecondOld=RRdistanceSecond;
             lastPeak=index;
             tacogram.append(RRdistanceSecond);
           } 
          }
        }   
    }
    
       float [] tacogramm = tacogram.array();
       return tacogramm;
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
    
    
     float newMax = max (a); 
     println("max filtered " + newMax);

    //signal evaluation and peaks counter
    for(int i=1;i<N-1;i++)
    {
        if(a[i] > 2 && a[i]>a[i-1] && a[i]<a[i+1])
        {
          if (!flag)
          {
            Beatcount++; 
            //flag=true;
          }
         
        } else {flag=false;}
      }
     
     
     // BPM detector 
     
       BPM = Beatcount;
       return BPM;
  }
}

  public float emotionScale (){
      
    float BPM=global_ecg.getBpm(),GSR=(global_ecg.getValue()/5),HRV=global_ecg.getVarEcg();
    float emotionScale; 
    
    emotionScale=((BPM/120)+GSR+HRV)/3;
    
  
  
  return emotionScale;
  }