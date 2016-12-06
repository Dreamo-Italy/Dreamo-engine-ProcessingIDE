//package dreamo.display;

abstract class Biosensor
{
  public String sensorName;
  private boolean connected; // connection status of the sensor
 // private float incomingValue; // the input coming from a biosensor
  private float defaultValue; // the average of the incoming values during the "calibration" process
  private boolean calibrating; // is the calibration process running?
  private float sensorMin, sensorMax; // the experimental MINIMUM and MAXIMUM values previously got from the current sensor
  public float absolute; // absolute value of the output, mapped to a 1-10 scale
  public float variation; // percentage variation WRT default value
  
  
   public float value; // last value
   
 // public FloatList incomingDataTime;
 // public FloatList incomingDataValue2; // vector of float

  
  
  // riflessioni : la classe biosensore ha bisogno di N sample, con N che dipende dalla frequenza di campionamento, per poter elaborare informazioni del tipo:
  // variazione del valore nell'ultimo tot di tempo, calcolo dei battiti cardiaci per minuto
  // visto che le funzioni di connessione hanno già un buffer interno, potrebbe essere sensato spostare la coda dalla classe Connection ->dentro alla classe biosensore
  
  public Biosensor()
  {
    sensorName = "default";
   //  incomingValue = -1;
    absolute = -1;
    calibrating = false;
    connected = global_connection.networkAvailable(); // temporary
    
    
 //   incomingDataValue2 = new FloatList();
      
      // DEBUG PURPOSES
     //if (!connected)
     //   storeFromText();
      
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
    //if ( frameCount % 30 != 0 ) return;
    
    println("absolute :"+ getAbsolute() );
    println("variation :"+ getVariation() );
    println("default value :" + getDefault() );
    println("");
    
    text("\n absolute : " + getAbsolute() + "; framerate: " + getVariation() + "default value : " + getDefault(), 10, 40, 60);

  }
  
 abstract void update(); // update() is called at FrameRate speed
 
  
  public float normalizeValue(float toNormalize) //map the value to a 1-10 scale according to the experimental min and max values
  {
      // map function from Processing libraries: map(value, start1, stop1, start2, stop2)
      
      float normalized = map ( toNormalize, getMin(), getMax(), 1, 10 );
      return normalized;
  }
  

  public float average(FloatList inputList)
  {
    float sum = 0;
    for(short i=0; i<inputList.size();i++)
      { sum += inputList.get(i); }
   
      println("sum: " + sum);
      println("list size: " + inputList.size() );
   return ((float)sum/inputList.size()) ;
  }
  
  public void setValue (float val) // when setValue is called, every other info is updated ( absolute, variation,... )
  {   
    value = val; 
    
    setAbsolute( normalizeValue( value ) );
    setVariation( getAbsolute() / getDefault() ) ;
    
    return; 
  }
  
  public void setMin( float min ) { sensorMin = min; return; }
  public void setMax ( float max ) { sensorMax = max; return; }
  public void setDefault ( float def ) { defaultValue = def; return; }
  public void setVariation (float var ) { variation = var; return; }
  public void setAbsolute ( float abs ) { absolute = abs; return; }
  
  public float getMin() { return sensorMin; }
  public float getMax() { return sensorMax; }
  public float getDefault() { return defaultValue; }
  public float getValue() { return value; }         // the useful info
  public float getAbsolute() { return absolute; } // absolute value of the output, mapped to a 1-10 scale
  public float getVariation() { return variation; } // percentage variation of the sensor with respect to the default value
  public String getID() {return sensorName; }
  
  
  // the following methods depend on the SPECIFIC SENSOR
  
  abstract void init();
 // abstract void storeFromText();
}