//package dreamo.display;


import processing.serial.*; 
import java.util.Queue;
import java.util.ArrayDeque;

/*  passare la Queue come argomento di una funzione:
Objects are not passed to methods; rather, references to objects are passed to methods. 
The references themselves are passed by value—a copy of a reference is passed to a method. 
When a method receives a reference to an object, the method can manipulate the object directly.*/

class Connection
{
  Serial myPort;  // Create object from Serial class

  private boolean wifiAvailable;
  private boolean serialAvailable;
  private boolean connectionAvailable;
  
  private float incomingValue; // the input coming from a biosensor
  
  public PApplet parent; //needed for the Serial object istantiation
  
  final int BUFFER_SIZE = 200; //random value
  final float MAX_COND = 10.0;
  final int lineFeed = 10;    // Linefeed in ASCII    
      
      
  private String inputString = null;  
  private FloatList incomingCond;
  
  //  private Queue <Integer> incomingCond = new ArrayDeque(); // create a queue to store the conductance
  //  private Queue <Integer> incomingECG = new ArrayDeque(); // create a queue to store the data

  
  public Connection( PApplet p ) // p = parent is needed for the Serial myport ( -->parent<--, list[0], 19200...)
  {
    wifiAvailable = false;
    serialAvailable = false;
    connectionAvailable = false;
    
    incomingCond = new FloatList();
    
    incomingValue = 0;
    parent = p;
    
    //serial check
    if(!wifiAvailable) 
      { 
        println("WARNING: Wifi is not available");
        if ( serialConnect() )
          serialAvailable = true;
        else
          println("WARNING: Serial port is not available");
      } 
     
     if(! (!wifiAvailable && !serialAvailable) ) // logic expressions : the hard way
       connectionAvailable = true;
       
  }
  
  private boolean wifiConnect()
  {
    boolean wifiAvailable = false;  
    return wifiAvailable;
  }
  
  public boolean networkAvailable()
  {
    return connectionAvailable;
  }
  
    private boolean serialConnect() // return TRUE if a serial connection is available
{
    // I know that the first port in the serial list on my mac
    // is Serial.list()[0].
    // On Windows machines, this generally opens COM1.
    // Open whatever port is the one you're using.
    
    boolean portAvailable = false;
    final String[] ports = Serial.list();
    println( ports );
    
    if (ports.length != 0) // DEBUG = 1 ; RIGHT ONE = 0;
    {
      String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
      myPort = new Serial(parent, portName, 19200);
      portAvailable = true; 
    }
    
    return portAvailable;   
 }

  
  
  public void update()
  {
    //if(frameCount%30 == 1)
    {
      if( !serialAvailable )
           storeFromText();      // read the data from an OFFLINE TABLE
      else if ( serialAvailable )
          storeFromSerial();    // read the data from the SERIAL LINE
    }
    
  }

  public void storeFromText()
  {        
         Table table_con = loadTable("log_conductance.csv", "header"); // content of log_conductance
        //  Table table_ecg = loadTable("log_ecg.csv", "header"); // content of log_ECG
      
          println(table_con.getRowCount() + " total rows in table conductance"); 
       //   println(table_ecg.getRowCount() + " total rows in table ECG");
       
       if ( getList("con").size() > BUFFER_SIZE ) getList("con").clear();

      
          for (TableRow row : table_con.rows()) {
            incomingCond.append ( row.getFloat("conductance") ); // add the content of the table row to a LIST OF FLOAT
           }
          
            
     //     for (TableRow row : table_ecg.rows() ) {
     //       incomingDataValue2.append ( row.getFloat("ECG_filtered") );
     //     }
     
     if ( getList("con").size() > table_con.getRowCount() )
       println( "WARNING: class connection, storeFromText(): reading is slower than writing.\n");
        
        println("Read from table process has completed. ");
    //    println("");
    //    println("incomingCond size: " + getList("con").size());
    //    println("");
        println("storeFromText function ends here. ");
        println("");
        
        return; 
   }
   
   private void storeFromSerial() // the function that reads the DATA from the SERIAL LINE BUFFER
  {
    
      int incomingCondSize = incomingCond.size();
      if ( !serialAvailable ) println(" ERROR: storeFromSerial has been called, but the port is not available");
      if ( incomingCondSize > BUFFER_SIZE ) // security check
      { 
        incomingCond.clear();
        println("WARNING: list was getting big: list is now empty");
      }
      
      print( " available bytes on serial buffer: " + myPort.available() );
      
      short added = 0, counter = 0;
      
      myPort.readStringUntil(lineFeed); // clean the garbage

      // while there is something on the serial buffer, add the data to the "incomingCond" queue
      // myPort.available() greater than 4: there's a pending FLOAT on the buffer (size: 4 bytes)
      
      while ( serialAvailable && added < 12 && counter < 25 && myPort.available() > 4 )
        {
            inputString = myPort.readStringUntil(lineFeed);
            if (inputString != null) 
            {
              incomingValue =float(inputString);  // Converts and prints float
              print( " serial: " + incomingValue );
              incomingCond.append(incomingValue);
              added++;
            }
            
            counter++;
        }
      
     myPort.clear();
     println("");
     println( "DEBUG : incomingCond queue size: " + incomingCond.size() );
     println( "DEBUG : elements added: " + added );
     if ( incomingCond.size() == 0 ) println(" ERROR in storeFromSerial: incomingCondSize = 0 ");
      
  }
  
  public FloatList extractFromBuffer (String listName, int numberOfElements) // gives out every element from the selected list and ERASE THOSE ELEMENTS
    {
      
      FloatList toOutput = new FloatList();
      
      int incomingCondSize = getList("con").size() ;
           
      boolean stop = false;
      float inValue;
      float sum = 0;
      short added = 0;
      
      if (listName.equals("con"))
       {
         while(! (getList("con").size() == incomingCondSize  - numberOfElements) && !stop) // extract numberOfElements of elements from conductance list
            {
              
              int size = getList("con").size();
              if ( size > 0 )
              
                 {                   
                   // !connectionAvailable: there aren't any connections available, we're reading the DATA from an OFFLINE TABLE
                   // with randomIndex we pick a different set of values for each cycle
                   int randomIndex = 0;
                   if ( !connectionAvailable ) 
                      randomIndex = round(random( incomingCondSize/2 ) ); 
                   
                   inValue = incomingCond.remove( size - randomIndex - 1 );
                   
                    //println ( "[extract from buffer] inValue: " + inValue );
                    
                  // if ( inValue < MAX_COND )
                   //  {
                       toOutput.append( inValue );
                       sum = sum + inValue;
                       added++;
                       //println ( "append: " + inValue );
                       //println ( "sum: " + sum );
                    // }
                 }
              else
                  stop = true;
                  
            }
            
      if ( added < 1 ) added = 1;    
      //println ( "added: " + added );
      toOutput.append( sum / added ); // average value        
       }
      return toOutput;
    }
  
  public FloatList getList(String sensorName)
  {
    if( sensorName.equals("con") )
      return incomingCond;
    else
      return null;
  }
}



 