class Gsr extends Biosensor
{  
   public void init()
  {

        
    if ( !global_connection.networkAvailable() ) 
    //silly way to simulate the values
      {
           storeFromText();
           setMin ( getList().min() );
           setMax ( getList().max() ); 
           setDefault (  (getMax() + getMin()) / 2  );
           
           // setMin ( normalizeValue( getMin() ) );
          //  setMax ( normalizeValue( getMax() ) );

           
           println("Min: " + getMin() );
           println("Max: " + getMax() );
           println("Default: " + getDefault() );
           println("");
      }
  }
  
  public float lastValue() // takes an int out of the current connection
  {
    float incoming = -1;
    
    
    
    if (global_connection != null )
      {
        if ( global_connection.networkAvailable() == true )
          incoming = global_connection.getAnElement();  
          
        else if ( incomingDataValue1.size() != 0 )
               {
                 // incoming = incomingDataValue1.get( incomingDataValue1.size() - 1 ); // the last element
                 // incomingDataValue1.remove(incomingDataValue1.size() - 1 ); // remove the last element after the reading
                 //println("List size: " + incomingDataValue1.size() );
                 incoming = incomingDataValue1.get( 0 ); // the last element
                 incomingDataValue1.remove( 0 ); // remove the last element after the reading
                
               }
        if ( incomingDataValue1.size() == 0 ) storeFromText(); //debug
       
          
      }
   
    setValue( incoming );
    setAbsolute( normalizeValue( incoming ) );   
    return incoming;
  }
  
    public void storeFromText()
  {
        Table table = loadTable("log_conductance.csv", "header"); // content of log_conductance
    
        println(table.getRowCount() + " total rows in table"); 
    
        for (TableRow row : table.rows()) {
          
         // incomingDataTime.append ( row.getFloat("Time") );
          incomingDataValue1.append ( row.getFloat("conductance") );
        //  incomingDataValue2.append ( row.getFloat("ECG_filtered") );
        
      }
      
      println("Read from table process has completed. ");
      println("");
     // println(incomingDataValue1);
      println("");
      println("storeFromText function ends here. ");
      println("");
      
   }
  
  // this function depends on the SPECIFIC SENSOR
  
}