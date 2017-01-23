class Gsr extends Biosensor
{  
   public FloatList incomingCon; // vector of float

   public void init()
  {
    sensorName = "con";
    
    value = 0; //debug
    
    if ( !global_connection.networkAvailable() ) 
    //silly way to simulate the values
      {
           global_connection.storeFromText();
           
           setMin ( global_connection.getList("con").min() );
           setMax ( global_connection.getList("con").max() ); 
           setDefault ( 5/* (getMax() + getMin())/ 2 */  );
    
              value = getDefault();
           
           // setMin ( normalizeValue( getMin() ) );
          //  setMax ( normalizeValue( getMax() ) );

           
           println("Min: " + getMin() );
           println("Max: " + getMax() );
           println("Default: " + (getMax() + getMin())/ 2 );
           println("");
      }
  }
  public void update()
   {
    incomingCon = new FloatList();
    int numToExtract = ceil (global_sampleRate/frameRate); //<>//
    long initTimeT = System.nanoTime();     

    incomingCon = global_connection.extractFromBuffer("con", numToExtract ); // store the incoming conductance value from Connection to another FloatLIst

    long bufT = System.nanoTime() - initTimeT; // duration of ExtractFromBuffer
     

    float average = computeAverage(incomingCon);
    
    long avgT = System.nanoTime() - bufT - initTimeT; // duration of average
    
    if(frameCount % 1 == 0) setValue  (average);
    
    long lasT = System.nanoTime()- avgT - bufT - initTimeT; // duration of setValue
   
     println("DEBUG: GSR update.");
     println("Number of elements to extract: " + numToExtract );
     println("buffer size: "+ incomingCon.size() );   
     println("average: "+ average );
     println("    Extract from buffer time: "+ bufT/1000 + " us");
     println("    Average time: "+ avgT/1000 + " us");
     println("    setValue time: "+ (lasT)/1000 + " us");
     println("    GSR UPDATE time: " + (System.nanoTime()-initTimeT )/1000 + " us");
     println("");
    
  }
  
}