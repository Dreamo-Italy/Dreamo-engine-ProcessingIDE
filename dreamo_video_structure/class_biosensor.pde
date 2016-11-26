//package dreamo.display;

abstract class Biosensor
{
  private boolean connected; // connection status of the sensor
 // private float incomingValue; // the input coming from a biosensor
  private float defaultValue; // the average of the incoming values during the "calibration" process
  private boolean calibrating; // is the calibration process running?
  private float sensorMin, sensorMax; // the experimental MINIMUM and MAXIMUM values previously got from the current sensor
  public float absolute; // absolute value of the output, mapped to a 1-10 scale
  public float value; // last value
  
  public FloatList incomingDataTime;
  public FloatList incomingDataValue1; // vector of float
  public FloatList incomingDataValue2; // vector of float

  
  
  // riflessioni : la classe biosensore ha bisogno di N sample, con N che dipende dalla frequenza di campionamento, per poter elaborare informazioni del tipo:
  // variazione del valore nell'ultimo tot di tempo, calcolo dei battiti cardiaci per minuto
  // visto che le funzioni di connessione hanno già un buffer interno, potrebbe essere sensato spostare la coda dalla classe Connection ->dentro alla classe biosensore
  
  public Biosensor()
  {
   //  incomingValue = -1;
    absolute = -1;
    calibrating = false;
    connected = global_connection.networkAvailable(); // temporary
    
    incomingDataValue1 = new FloatList();
    incomingDataValue2 = new FloatList();
      
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
  

  //la differenza tra gli output... e i get... (eg outputAbsolute e getAbsolute) sta nel fatto che
  // gli output... richiamano lastValue(), che prende un nuovo elemento dalla lista
  
  public float outputAbsolute() // absolute value of the output, mapped to a 1-10 scale
  {
    float absolute = this.normalizeValue( lastValue() );
    return absolute;
  }
  
  public float outputVariation() // percentage variation of the sensor with respect to the default value
  {
    float variation =  lastValue() / getDefault() ;

    return variation;
  }
  
  public void printDebug()
  {
    
    println("absolute :"+ outputAbsolute() );
    println("variation :"+ outputVariation() );
    println("default value :"+ getDefault() );
    println("");
    
    

  }
  
  public float normalizeValue(float toNormalize) //map the value to a 1-10 scale according to the experimental min and max values
  {
      // map function from Processing libraries: map(value, start1, stop1, start2, stop2)
      
      float normalized = map ( toNormalize, getMin(), getMax(), 1, 10 );
      return normalized;
  }
  
  public FloatList getList()
  {
    return incomingDataValue1;
  }
  
  // the following methods depend on the SPECIFIC SENSOR
  
  abstract float lastValue(); 
  abstract void init();
  abstract void storeFromText();
  
  public void setMin( float min ) { sensorMin = min; return; }
  public void setMax ( float max ) { sensorMax = max; return; }
  public void setDefault ( float def ) { defaultValue = def; return; }
  public void setValue (float val ) { value = val; return; }
  public void setAbsolute ( float abs ) { absolute = abs; return; }
  
  public float getMin() { return sensorMin; }
  public float getMax() { return sensorMax; }
  public float getDefault() { return defaultValue; }
  public float getValue() { return value; }
  public float getAbsolute() { return absolute; }
  

}