//package dreamo.display;

abstract class Biosensor
{
  private boolean connected; // connection status of the sensor
  private int incomingValue; // the input coming from a biosensor
  public int defaultValue; // the average of the incoming values during the "calibration" process
  private boolean calibrating; // is the calibration process running?
  public int sensorMin, sensorMax; // the experimental MINIMUM and MAXIMUM values previously got from the current sensor
  public float absolute; // absolute value of the output, mapped to a 1-10 scale
  
  public Biosensor()
  {
    incomingValue = -1;
    absolute = -1;
    calibrating = false;
    connected = false;
    
    if( global_connection.anyConnectionAvailable == false ) // temporary
      connected = false;
      
    init(); // specific sensor constructor
    
  }
  
  public boolean calibration() // set defaultValue to the initial condition of the sensor
  {
    if (!connected) return false;
    
    int counter = 1;

    while(calibrating)
      {
        defaultValue = (defaultValue + incomingValue) / counter ; // average the incoming values to get a DEFAULT value 
        counter++;     
      }
    return true;
  }
  
  public float outputAbsolute() // absolute value of the output, mapped to a 1-10 scale
  {
    absolute = this.normalizeValue( getAnInt() );
    return absolute;
  }
  
  public float outputVariation() // percentage variation of the sensor with respect to the default value
  {
    float variation = (absolute - 1)/ defaultValue ;
    return variation;
  }
  
  public void printDebug()
  {
    
    println("absolute :"+ outputAbsolute() );
    println("variation :"+ outputVariation() );
    println("default value :"+ defaultValue );
    println("");

  }
  
  private float normalizeValue(int toNormalize) //map the value to a 1-10 scale according to the experimental min and max values
  {
      // map function from Processing libraries: map(value, start1, stop1, start2, stop2)
      
      float normalized = map ( toNormalize, sensorMin, sensorMax, 1, 10 );
      return normalized;
  }
  
  abstract int getAnInt(); // this function depends on the SPECIFIC SENSOR
  abstract void init();

}