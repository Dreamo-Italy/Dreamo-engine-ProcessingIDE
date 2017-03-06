class Gsr extends Biosensor
{
   public void init()
  {
    sensorName = "gsr";   
  }
  public void update()
   {          
    float currentValue = getAbsolute();
    //int sampleToExtract = ceil (global_sampleRate/frameRate); //<>//
    long initTimeT = System.nanoTime();     

    incomingValues = global_connection.extractFromBuffer("gsr", sampleToExtract ); // store the incoming conductance value from Connection to another FloatLIst

    //long bufT = System.nanoTime() - initTimeT; // duration of ExtractFromBuffer

    currentValue = computeAverage(incomingValues, getDefault() );
    
    //println("Number of elements to extract: " + sampleToExtract );
    //println("buffer size: "+ incomingValues.size() );   
     
        
     setValue  ( currentValue );
     
     if ( ! ( incomingValues == null ) )
       checkCalibration();
       
    // println("    Extract from buffer time: "+ bufT/1000 + " us");
    
  }
  
}