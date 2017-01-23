class Gsr extends Biosensor
{  
   public FloatList incomingCon; // vector of float

   public void init()
  {
    sensorName = "con";
        
    if ( !global_connection.networkAvailable() ) 
    //silly way to simulate the values
      {
           global_connection.storeFromText();
           
           setMin ( global_connection.getList("con").min() );
           setMax ( global_connection.getList("con").max() ); 
           setDefault ( 5/* (getMax() + getMin())/ 2 */  );
      }
  }
  public void update()
   {
     println("DEBUG: GSR update.");     
     float average;
     if(frameCount % 5 == 0)
     {
          incomingCon = new FloatList();
          int numToExtract = ceil (global_sampleRate/frameRate); //<>//
          long initTimeT = System.nanoTime();     
      
          incomingCon = global_connection.extractFromBuffer("con", numToExtract ); // store the incoming conductance value from Connection to another FloatLIst
      
          //long bufT = System.nanoTime() - initTimeT; // duration of ExtractFromBuffer
      
          average = computeAverage(incomingCon);
          println("Number of elements to extract: " + numToExtract );
          println("buffer size: "+ incomingCon.size() );   
     }
     else
       average = this.getValue();
        
     setValue  (average);
       
     println("average: "+ average );
    // println("    Extract from buffer time: "+ bufT/1000 + " us");
     println("");
    
  }
  
}