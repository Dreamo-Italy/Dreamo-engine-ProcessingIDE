class Gsr extends Biosensor
{  
   public FloatList incomingCon; // vector of float

   public void init()
  {
    sensorName = "con";
    incomingCon = new FloatList();
    
    value = 0; //debug
    
    //debug
    setMin ( 1.0 );
    setMax ( 7.0 ); 
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

    incomingCon = global_connection.extractFromBuffer("con", floor (global_sampleRate/fps) ); // store the incoming conductance value from Connection to another FloatLIst
    
    println("Number of elements extracted: "+ floor (global_sampleRate/fps) );
    println("DEBUG: GSR update.");
    println("buffer size: "+ incomingCon.size() );
    float average = average(incomingCon);
    
    println("average: "+average );
    setValue  (average);
    
    incomingCon.clear();
    
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