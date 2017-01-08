class Gsr extends Biosensor
{  
   public FloatList incomingCon; // vector of float

   public void init()
  {
    sensorName = "con";
    
    value = 0; //debug
    
    //debug
    setMin ( 1.0 );
    setMax ( 3.5 ); 
    setDefault (  (getMax() + getMin()) / 2  );
    
    //if ( !global_connection.networkAvailable() ) 
    ////silly way to simulate the values
    //  {
    //       storeFromText();
           
    //       setMin ( getList("conductance").min() );
    //       setMax ( getList("conductance").max() ); 
    //       setDefault (  (getMax() + getMin()) / 2  );
    
   //           value = getDefault();
           
    //       // setMin ( normalizeValue( getMin() ) );
    //      //  setMax ( normalizeValue( getMax() ) );

           
    //       println("Min: " + getMin() );
    //       println("Max: " + getMax() );
    //       println("Default: " + getDefault() );
    //       println("");
    //  }
  }
  public void update()
   {
     incomingCon = new FloatList();

    int numToExtract = ceil (global_sampleRate/fps);
     
    long initTimeT = System.nanoTime();     
         
    incomingCon = global_connection.extractFromBuffer("con", numToExtract ); // store the incoming conductance value from Connection to another FloatLIst
    
    long bufT = System.nanoTime() - initTimeT; // duration of ExtractFromBuffer
     
    float average = incomingCon.remove( incomingCon.size() - 1 ) ;
    
    long avgT = System.nanoTime() - bufT - initTimeT; // duration of average
    
    if(frameCount % 1 == 0) setValue  (average);
    
    long lasT = System.nanoTime()- avgT - bufT - initTimeT; // duration of setValue
   
     println("DEBUG: GSR update.");
     println("FPS: "+ fps);   
     println("buffer size: "+ incomingCon.size() );   
     println("average: "+ average );
     println("Number of elements to extract: " + numToExtract );
     println("    Extract from buffer time: "+ bufT/1000 + " us");
     println("    Average time: "+ avgT/1000 + " us");
     println("    setValue time: "+ (lasT)/1000 + " us");
     println("    GSR UPDATE time: " + (System.nanoTime()-initTimeT )/1000 + " us");
     println("");
    
  }
  
  //  public void storeFromText()
  //{
  //      Table table = loadTable("log_conductance.csv", "header"); // content of log_conductance
    
  //      println(table.getRowCount() + " total rows in table"); 
    
  //      for (TableRow row : table.rows()) {
          
  //       // incomingDataTime.append ( row.getFloat("Time") );
  //        incomingDataValue1.append ( row.getFloat("conductance") );
  //      //  incomingDataValue2.append ( row.getFloat("ECG_filtered") );
        
  //    }
      
  //    println("Read from table process has completed. ");
  //    println("");
  //   // println(incomingDataValue1);
  //    println("");
  //    println("storeFromText function ends here. ");
  //    println("");
      
  // }
  
  // this function depends on the SPECIFIC SENSOR
  
}