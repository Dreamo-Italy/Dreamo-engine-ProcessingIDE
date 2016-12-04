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
                  //values given by the galvanic skin response  // GSR[0] is CON, GSR[1] is RES, GSR[2] is CONV

  private boolean wifiAvailable;
  private boolean serialAvailable;
  private boolean anyConnectionAvailable;
  
  private int incomingValue; // the input coming from a biosensor
  
  public PApplet parent; //needed for the Serial object istantiation
  
  final int BUFFER_SIZE = 2000; //random value
  
  
  private FloatList incomingCon;
  
  //  private Queue <Integer> incomingCon = new ArrayDeque(); // create a queue to store the conductance
  //  private Queue <Integer> incomingECG = new ArrayDeque(); // create a queue to store the data

  
  public Connection( PApplet p ) // p = parent is needed for the Serial myport ( -->parent<--, list[0], 9600...)
  {
    wifiAvailable = false;
    serialAvailable = false;
    anyConnectionAvailable = false;
    
    incomingCon = new FloatList();
    
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
       anyConnectionAvailable = true;
       
  }
  
  private boolean wifiConnect()
  {
    boolean wifiAvailable = false;  
    return wifiAvailable;
  }
  
  public boolean networkAvailable()
  {
    return anyConnectionAvailable;
  }
  
    private boolean serialConnect() // return TRUE if a serial connection is available
{
    // I know that the first port in the serial list on my mac
    // is Serial.list()[0].
    // On Windows machines, this generally opens COM1.
    // Open whatever port is the one you're using.
    
    boolean portAvailable = false;
    final String[] ports = Serial.list();
    
    if (ports.length != 0) 
    {
      String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
      myPort = new Serial(parent, portName, 9600);
      portAvailable = true; 
    }
    
    return portAvailable;   
 }

  
  
  public void update()
  {
    //if(frameCount%30 == 1)
    {
      if( !serialAvailable )
           storeFromText();
      else if ( serialAvailable )
          storeFromSerial();
    }
    
  }

  public void storeFromText()
  {        
         Table table_con = loadTable("log_conductance.csv", "header"); // content of log_conductance
        //  Table table_ecg = loadTable("log_ecg.csv", "header"); // content of log_ECG
      
          println(table_con.getRowCount() + " total rows in table conductance"); 
       //   println(table_ecg.getRowCount() + " total rows in table ECG");
      
          for (TableRow row : table_con.rows() ) {
            incomingCon.append ( row.getFloat("conductance") ); // add the content of the table row to a LIST OF FLOAT
          }
            
     //     for (TableRow row : table_ecg.rows() ) {
     //       incomingDataValue2.append ( row.getFloat("ECG_filtered") );
     //     }
     
     if ( getList("conductance").size() > table_con.getRowCount() )
       println( " class connection, storeFromText(): reading is slower than writing.\n");
        
        println("Read from table process has completed. ");
    //    println("");
         println("incomingCon size: "+getList("conductance").size());
        println("");
        println("storeFromText function ends here. ");
        println("");
        
        return; 
   }
   
   private void storeFromSerial() // the function that reads the DATA from the SERIAL LINE BUFFER
  {
      if ( !serialAvailable ) println(" ERROR: storeFromSerial has been called, but the port is not available");
      
      if ( incomingCon.size() > BUFFER_SIZE ) // security check
      { 
        incomingCon.clear();
        println("WARNING: list was getting big: list is now empty");
      }
      
      while ( serialAvailable && myPort.available() > 0 ) // while there is something on the serial buffer, add the data to the "incomingCon" queue
        {
            incomingValue = myPort.read();
            incomingCon.append(incomingValue);
        }
     
     println( " DEBUG : incomingCon queue size: " + incomingCon.size() );
      
  }
  
  public FloatList extractFromBuffer (String listName) // gives out every element from the selected list and ERASE THOSE ELEMENTS
    {
      
      FloatList toOutput = new FloatList();
      
      if (listName.equals("conductance"))
        while(! (getList("conductance").size() == 0) ) 
            toOutput.append( incomingCon.remove(0) );
    
      return toOutput;
    }
  
  public FloatList getList(String sensorName)
  {
    if( sensorName.equals("conductance") )
      return incomingCon;
    else
      return null;
  }
}



 