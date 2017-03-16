//package dreamo.display;

abstract class Biosensor
{
 //************ CONSTANTS **************
 
  final private int CALIBRATION_TIME = 90; // duration of the CALIBRATION PROCESS, expressed in seconds

  
 //********* PUBLIC MEMBERS ***********
  public String sensorName;
  public float absolute; // absolute value of the output, mapped to a 1-10 scale
  public float variation; // percentage variation WRT default value
  public float value; // last value (not normalized)
  
  protected float physicalMin, physicalMax; // the theoretical MINIMUM and MAXIMUM values of the current sensor


	//********* PRIVATE MEMBERS ***********

  private float bpm;
  private boolean connected; // connection status of the sensor
  private float defaultValue; // average of the incoming values
  private boolean calibrating; // TRUE IF the calibration process IS RUNNING
  private boolean calibrated; // TRUE if the calibration process HAVE BEEN RUN already
  private int calibrationCounter;
  private int BPMcal;
  protected int sampleToExtract;
  protected FloatList incomingValues; // vector of float
  protected FloatList calibrationValues;

  
  //********* CONSTRUCTOR ***********
  
  public Biosensor()
  {    
    sensorName = "default";
    absolute = -1;    
    physicalMin = -1;
    physicalMax = -1;
    
    calibrating = false;
    calibrated = false;
    calibrationCounter = 0;
    
    // number of BIOMEDICAL VALUES to extract at each update() cycle   
    sampleToExtract = floor (global_sampleRate/(global_fps)); 
    
    incomingValues = new FloatList();
    
    if (global_connection != null)
      connected = global_connection.networkAvailable(); 
      
    init(); // specific sensor constructor
    
  }
  
  //********* METHODS ***********
  
  public void checkCalibration() // set defaultValue to the initial condition of the sensor
  {
    if ( this.needCalibration() )
    {
      if ( this.isCalibrating() == false )
        startCalibration();      
    
      calibration();
      
      if ( calibrationCounter > frameRate*CALIBRATION_TIME )
         endCalibration();        
    
   }
  }
    
  
  
  protected void startCalibration()
  {
    calibrationValues = new FloatList();
    calibrationValues.clear();    
    calibrating = true;
  }

  
  protected void calibration()
  {
    if ( !calibrating )                    { println("WARNING: not calibrating error");     return; }
    else if ( calibrated )                 { println("WARNING: already calibrated error");  return; }
    else if ( incomingValues.size() == 0 ) { println("ERROR: incomingValues is empty");     return; }

    calibrationValues.append( incomingValues );
 
    println("Calibrating sensor: " + getID());
    println();
    
    calibrationCounter++;
  }
  

  protected void endCalibration()
  {
    
    float average = computeAverage( calibrationValues , ( min(calibrationValues.array() ) + max(calibrationValues.array() ) )/2 );
     
    if( sensorName == "ecg" && calibrationValues != null)
    {         
      float [] ecgFiltered = this.filterEcgData( calibrationValues.array() );
      
      BPMcal = ECGBPM3( ecgFiltered ); 
      setBpm ( BPMcal );
      setValue  ( BPMcal );
      setDefault( BPMcal );
    }
    
    if ( getID() == "gsr") 
      setDefault( normalizeValue(average) );
    
    println( "new normalized average: " + average );
    
    calibrationValues.clear();
    
    calibrating = false;
    calibrated = true;
    calibrationCounter = 0;
  }
  
  protected boolean isCalibrating()
  {
    return calibrating;
  }
  
  protected boolean needCalibration()
  {
    return !calibrated;
  }
    
  protected void restartCalibration()
  {
    calibrated = false;
  } 
 
  //map the value to a 0-1 scale according to the experimental min and max values
  private float normalizeValue(float toNormalize) 
  {
      // map function from Processing libraries: map(value, start1, stop1, start2, stop2)
      
      float normalized = map ( toNormalize, getPhysicalMin(), getPhysicalMax(), 0, 1);
      return normalized;
  }
  
 // simple "average" function
  public float computeAverage(FloatList inputList, float oldAverage)
  {
    if ( inputList == null )
    {  
        println(" ERROR: computeAverage: NULL argument ");
       return oldAverage;
    }
    
    float average = oldAverage;
    int listSize = inputList.size();
      if ( listSize == 0 ) 
        { println("ERROR: Argument of computeAverage is an empty list. "); 
            return oldAverage; 
          }       
      else
      {
          float sum = 0;
          
          for(int i=0; i < listSize ;i++)
            { 
              if ( inputList.get(i) < MAX_FLOAT )
                 {
                   sum += inputList.get(i); 
                 }
              else
                 { 
                   inputList.set(i, oldAverage);
                   sum += inputList.get(i); 
                   println("WARNING: corrupted float found during computeAverage. Index: "+i);
                 }
            }
         average = (float)sum/listSize;       
      }
      
     return average;  

  }
  
  //TODO: move this into ECG class
  protected float [] filterEcgData(float...arrayIn)
  {
      //System.arraycopy(Object src, int srcPos, Object dest, int destPos, int length)

      float [] filtered = new float[arrayIn.length];
      filtered = Arrays.copyOf(arrayIn,arrayIn.length );
      //System.arraycopy(arrayIn, 0, filtered, 0, arrayIn.length);
      
      filtered = DSP.HighPass (filtered, 5.0, global_sampleRate);
      filtered = DSP.HWR(filtered);
      //filtered = DSP.MAfilter(filtered, arrayIn.length);
      filtered = DSP.times(filtered,5);
      filtered = DSP.LowPassFS (filtered, 45.0, global_sampleRate);
      filtered = DSP.times(filtered,10);
      filtered = differentiateArray(filtered);      
      return filtered;
  }
  
  public float [] squareArray(float [] a)
  {
  //Squaring the signal to increase the peak
    for (int i=0; i< a.length;i++){
      a[i]= a[i]*a[i];
    }
          return a;
  }
  
  public float [] differentiateArray(float [] a)
  {
  // Differentiator
    for (int i=0; i<a.length;i++){
      if(i>3){a[i]= 0.1*(2*a[i] + a[i-1] -a[i-3]-2*a[i-4]);}
     }
    return a;
 }
  
   public void printDebug()
  {     
    int xOffset = 10;
    int yOffset = 35;
    if ( sensorName == "ecg") yOffset += 13;
    
    text(sensorName+ " absolute : " + nf(getAbsolute(),2,2) + "; variation: " + nf(getVariation(),1,2) + 
    "; default value : " + nf(getDefault(),1,2) + "; not normalized: "+nf(getValue(),1,2), xOffset, yOffset);
    if(isCalibrating() && sensorName == "gsr")
      text("Calibration is running", xOffset, yOffset+26);
    
  }
  
  //********* SET METHODS **********
 
  // set the sensor CURRENT VALUE
  // when setValue is called, every other info is updated ( absolute, variation,... )
  public void setValue (float val) 
  {   
    value = val; 
    
    setAbsolute( normalizeValue( value ) );
    setVariation( getAbsolute() / getDefault() ) ;
    
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
    float index=0,lastPeak=0, nSample=0;
    float RRdistanceSecond=0;
    int N = a.length; //numToExtract*frameRate*5 
    boolean flag=false, flag2=true;
    
    //// Differentiator
    //for (int i=0; i<N;i++){
    //  if(i>3){a[i]= 0.1*(2*a[i] + a[i-1] -a[i-3]-2*a[i-4]);}
    // }
    
    ////Squaring the signal to increase the peak
    //for (int i=0; i<N;i++){
    //  a[i]= a[i]*a[i];
    //  //if(a[i] < 0.05) 
    //  //  a[i] = 0;
    //} 

    //signal evaluation and peaks counter
    for(int i=1;i<N-1;i++){
       
      if(a[i]> 3 && a[i]>a[i-1] && a[i+1]>a[i] ){
    
          if(flag2){
          Beatcount++;
          index=i;
          flag2=false;
          }
          
          if(!flag){
          flag=true;
          index=i;
          
          if(lastPeak!=0){
          nSample=index-lastPeak;
          RRdistanceSecond=nSample/30;
          //println("RRbefore " +RRdistanceSecond);
          //println("BCbefore " +Beatcount);
          if (RRdistanceSecond > 0.12) {
             Beatcount++;
          }
        }
        }
        } else {
        flag=false; flag2=false; lastPeak=index;
      }
    }
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
    
    ////Squaring the signal to increase the peak
    //for (int i=0; i<N;i++){
    //  a[i]= a[i]*a[i];
    //  //if(a[i] < 0.05) 
    //  //  a[i] = 0;
    //} 
    
     float newMax = max ( a); 
     println("max filtered " + newMax);

    //signal evaluation and peaks counter
    for(int i=1;i<N-1;i++)
    {
        if(a[i]> 3 /*&& a[i]>a[i-1] */&& a[i]>a[i+1])
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
   
  /******************************************************************************************************/ 
  // when setValue is called, every other info is updated ( absolute, variation,... )
  public void setDefault ( float def ) { defaultValue = def; return; }
  public void setVariation (float var ) { variation = var; return; }
  public void setAbsolute ( float abs ) { absolute = abs; return; }
  public void setBpm ( float newBpm ) { bpm = newBpm; return; }
  
  //********* GET METHODS ***********

  public float getBpm() { return bpm; }
  public float getPhysicalMin() { return physicalMin; }
  public float getPhysicalMax() { return physicalMax; }
  public float getDefault() { return defaultValue; }
  public float getValue() { return value; }
  public float getAbsolute() { return absolute; } // absolute value of the output, mapped to a 0-1 scale
  public float getVariation() { return variation; } // percentage variation of the sensor with respect to the default value
  public String getID() {return sensorName; }
  
  
 // the following methods depend on the SPECIFIC SENSOR
 //********* ABSTRACT METHODS ***********

	abstract void init();
	abstract void update(); // update() is called at FrameRate speed

	// abstract void storeFromText();
}