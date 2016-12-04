      ///*class Ecg extends Biosensor
      //{  
      //  public void init()
      //  {
          
      //     defaultValue = 5;
      //    sensorMin = 1;
      //    sensorMax = 10; 
             
      //  }
        
      //  public float getValue() // takes an int out of the current connection
      //  {
      //    float incoming = -1;
          
      //    if (global_connection != null )
      //      {
      //        if ( global_connection.networkAvailable() == true )
      //          incoming = global_connection.getAnElement();  
      //        else
      //           {
      //             incoming = incomingDataValue1.get(0); // the first element
      //             incomingDataValue1.remove(0); // remove the first element after the reading
      //           }
                
      //      }
      
      //    return incoming;
         
      //  }
        
      //   public void storeFromText()
      //  {
      //        Table table = loadTable("log1_notime.csv", "header"); // content of log1:  Time; ECG; ECG_filtered; ...
          
      //        println(table.getRowCount() + " total rows in table"); 
          
      //        for (TableRow row : table.rows()) {
                
      //         // incomingDataTime.append ( row.getFloat("Time") );
      //        //  incomingDataValue1.append ( row.getFloat("ECG") );
      //         // incomingDataValue2.append ( row.getFloat("ECG_filtered") );
              
      //      }
            
      //      println("Read from table process has completed. ");
      //      println(incomingDataTime);
      //      println(incomingDataValue1);
      //      println(incomingDataValue2);
      //      println("storeFromText function ends here. ");
            
      //   }
        
      //}*/