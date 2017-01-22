//package dreamo.display;

abstract class Biosensor
{
   //********* PUBLIC MEMBERS ***********
    public String sensorName;
    public float absolute; // absolute value of the output, mapped to a 1-10 scale
    public float variation; // percentage variation WRT default value
    public float value; // last value (not normalized)


   //********* PRIVATE MEMBERS ***********

  private boolean connected; // connection status of the sensor
  private float defaultValue; // average of the incoming values
  private boolean calibrating; // is the calibration process running?
  private float sensorMin, sensorMax; // the experimental MINIMUM and MAXIMUM values previously got from the current sensor
  
   //********* CONSTRUCTOR ***********
  public Biosensor()
  {
    sensorName = "default";
   //  incomingValue = -1;
    absolute = -1;
    calibrating = false;
    connected = global_connection.networkAvailable(); // temporary      
    init(); // specific sensor constructor
    
  }
  
  public boolean calibration() // set defaultValue to the initial condition of the sensor
  {
    if (!connected) return false;    
    int counter = 1;
    while(calibrating)
      {
        setDefault( (getDefault() + getValue() ) / counter ); // average the incoming values to get a DEFAULT value 
        counter++;     
      }
    return true;
  }
  
  public void printDebug()
  {    
    println("absolute :"+ getAbsolute() );
    println("variation :"+ getVariation() );
    println("default value :" + getDefault() );
    println("");    
    text("\n absolute : " + getAbsolute() + "; variation: " + getVariation() + "; default value : " + getDefault(), 10, 50);
  }
  
 
  //map the value to a 1-10 scale according to the experimental min and max values
  public float normalizeValue(float toNormalize) 
  {
      // map function from Processing libraries: map(value, start1, stop1, start2, stop2)
      
      float normalized = map ( toNormalize, getMin(), getMax(), 1, 10 );
      return normalized;
  }
  
 // simple "average" function
  public float computeAverage(FloatList inputList)
  {
    float average;
    int listSize = inputList.size();
      if ( listSize == 0 ) 
        return defaultValue;
      else
      {
          float sum = 0;
          
          for(int i=0; i < listSize ;i++)
            { sum += inputList.get(i); }
         average = (float)sum/listSize;         
         
         if( average < MAX_INT)
           return average ;
         else{
           println("WARNING: AVERAGE VALUE IS NOT VALID");
           return defaultValue;}     
      }
    
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