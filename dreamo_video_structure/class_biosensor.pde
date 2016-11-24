//package dreamo.display;

class Biosensor
{
  private int incomingValue; // the input coming from a biosensor
  private int defaultValue; // the average of the incoming values during the "calibration" process
  private boolean calibrating; // is the calibration process running?
  private int sensorMin, sensorMax; // the experimental MINIMUM and MAXIMUM values got from the current sensor
  
  public Biosensor()
  {
    incomingValue = 0;
    defaultValue = 0;
    sensorMin = 1;
    sensorMax = 10;
    calibrating = false;
  }
  
   public void calibration() // set defaultValue to the initial condition of the sensor
  {
    int counter = 1;
    
    while(calibrating)
      {
        defaultValue = (defaultValue + incomingValue) / counter ; // average the incoming values to get a DEFAULT value 
        counter++;     
      }
  }
  
  public float outputAbsolute()
  {
    float absolute = this.normalizeValue( incomingValue );
    return absolute;
  }
  
  public float normalizeValue(int toNormalize) //map the value to a 1-10 scale
  {
      // map function from Processing libraries: map(value, start1, stop1, start2, stop2)
      
      float normalized = map ( toNormalize, sensorMin, sensorMax, 1, 10 );
      return normalized;
  }
  

}