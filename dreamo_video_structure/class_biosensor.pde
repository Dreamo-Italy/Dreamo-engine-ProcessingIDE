//package dreamo.display;

abstract class Biosensor
{
 //************ CONSTANTS **************
 
  final private int CALIBRATION_TIME = 3; // duration of the CALIBRATION PROCESS, expressed in seconds

  
 //********* PUBLIC MEMBERS ***********
  public String sensorName;
  public float absolute; // absolute value of the output, mapped to a 1-10 scale
  public float variation; // percentage variation WRT default value
  public float value; // last value (not normalized)


  //********* PRIVATE MEMBERS ***********

  private boolean connected; // connection status of the sensor
  private float defaultValue; // average of the incoming values
  private boolean calibrating; // TRUE IF the calibration process IS RUNNING
  private boolean calibrated; // TRUE if the calibration process HAVE BEEN RUN already
  private float sensorMin, sensorMax; // the experimental MINIMUM and MAXIMUM values previously got from the current sensor
  private float minCal, maxCal; // calibration process min and max values
  private int calibrationCounter;

  protected FloatList incomingValues; // vector of float
  protected FloatList calibrationValues;

  
  //********* CONSTRUCTOR ***********
  
  public Biosensor()
  {
    sensorName = "default";
    absolute = -1;
    
    sensorMin = minCal = MAX_FLOAT;
    sensorMax = maxCal = MIN_FLOAT;
    
    calibrating = false;
    calibrated = false;
    calibrationCounter = 0;
    
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
    if ( !calibrating )            { println("WARNING: not calibrating error"); return; }
    else if ( calibrated )         { println("WARNING: already calibrated error"); return; }
    else if ( incomingValues.size() == 0 ) { println("ERROR: incomingValues is empty"); return; }

    calibrationValues.append( incomingValues );
    
    minCal = calibrationValues.min();
    maxCal = calibrationValues.max();
    
    float newMin = min ( minCal, getMin() );
    float newMax = max ( maxCal, getMax() ); 
    
    println("Calibration process is running...");
    setMin ( newMin ); println( "new min: " + newMin );
    setMax ( newMax ); println( "new max: " + newMax );
    
    calibrationCounter++;
  }
  

  protected void endCalibration()
  {    
    // expand the range by a 20% factor (experimental)
    float newMin = abs ( getMin() );
    float newMax = getMax();
    
    setMin ( newMin );
    setMax ( newMax );
    
    float average = computeAverage( calibrationValues , ( newMin + newMax )/2 );
    
    setDefault( normalizeValue(average) );
    println( "new average: " + average );
    
    calibrationValues.clear();
    
    calibrating = false;
    calibrated = true;
  }
  
  protected boolean isCalibrating()
  {
    return calibrating;
  }
 
  
  protected boolean needCalibration()
  {
    return !calibrated;
  }
 
  //map the value to a 1-10 scale according to the experimental min and max values
  private float normalizeValue(float toNormalize) 
  {
      // map function from Processing libraries: map(value, start1, stop1, start2, stop2)
      
      float normalized = map ( toNormalize, getMin(), getMax(), 1, 10 );
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
  
   public void printDebug()
  {    
    println("absolute :"+ getAbsolute() );
    println("variation :"+ getVariation() );
    println("default value :" + getDefault() );
    println("");    
    text("\n absolute : " + getAbsolute() + "; variation: " + getVariation() + "; default value : " + getDefault(), 10, 50);
  }
  
  //********* SET METHODS **********
 
  // set the sensor CURRENT VALUE ( sensor output useful for video generation )
  // when setValue is called, every other info is updated ( absolute, variation,... )
  public void setValue (float val) 
  {   
    value = val; 
    
    setAbsolute( normalizeValue( value ) );
    setVariation( getAbsolute() / getDefault() ) ;
    
    return; 
  }
  
  // when setValue is called, every other info is updated ( absolute, variation,... )
  public void setMin( float min ) { sensorMin = min; return; }
  public void setMax ( float max ) { sensorMax = max; return; }
  public void setDefault ( float def ) { defaultValue = def; return; }
  public void setVariation (float var ) { variation = var; return; }
  public void setAbsolute ( float abs ) { absolute = abs; return; }
  
  //********* GET METHODS ***********

  
  public float getMin() { return sensorMin; }
  public float getMax() { return sensorMax; }
  public float getDefault() { return defaultValue; }
  public float getValue() { return value; }         // the useful info
  public float getAbsolute() { return absolute; } // absolute value of the output, mapped to a 1-10 scale
  public float getVariation() { return variation; } // percentage variation of the sensor with respect to the default value
  public String getID() {return sensorName; }
  
  
  // the following methods depend on the SPECIFIC SENSOR
  //********* ABSTRACT METHODS ***********

  abstract void init();
  abstract void update(); // update() is called at FrameRate speed

 // abstract void storeFromText();
}