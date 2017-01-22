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
  
  private int executionNumber; // # of times StoreFromText has been called
  
  private float incomingValue; // the input coming from a biosensor
  
  public PApplet parent; //needed for the Serial object istantiation
  
  final int BUFFER_SIZE = 200; //random value
  final float MAX_COND = 10.0;
  final int lineFeed = 10;    // Linefeed in ASCII    
  final int numToExtract;
      
      
  private String inputString = null;  
  private FloatList incomingCond;
  
  // p = parent is needed for the Serial myport ( -->parent<--, list[0], 19200...)
  public Connection( PApplet p ) 
  {
    wifiAvailable = false;
    serialAvailable = false;
    connectionAvailable = false;
    executionNumber = 0;
    
    incomingCond = new FloatList();
    
    incomingValue = 0;
    parent = p;
    
    // number of BIOMEDICAL VALUES to extract at each update() cycle
    
    numToExtract = floor (global_sampleRate/global_fps);  //<>//

    
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
    
    if( !serialAvailable ) //<>//
         storeFromText();      // read the data from an OFFLINE TABLE
    else if ( serialAvailable )
        storeFromSerial();    // read the data from the SERIAL LINE

}

  public void storeFromText()
  {        
    Table table_con = loadTable("log_conductance.csv", "header"); // content of log_conductance
      //  Table table_ecg = loadTable("log_ecg.csv", "header"); // content of log_ECG
      
       println(table_con.getRowCount() + " total rows in table conductance"); 
       //   println(table_ecg.getRowCount() + " total rows in table ECG");
      
       // CLEAR the list if the list SIZE is five time bigger than needed
       if ( getList("con").size() > numToExtract*5 )
          { getList("con").clear(); println("List is now empty"); }

      if ( executionNumber >= table_con.getRowCount()/numToExtract )
        executionNumber = 0;
      
      int count = 0;
      int multiplier = executionNumber; //<>//
      int iStart = 0 + numToExtract*multiplier;
      int iEnd = numToExtract*( multiplier + 1); 
      // add the content of the table to a LIST OF FLOAT

        for (TableRow row : table_con.rows()) {
          float newFloat = row.getFloat("conductance");
          count++;
          if ( count>=iStart && count<=iEnd ) 
            getList("con").append (newFloat); 
         }         
            
     //     for (TableRow row : table_ecg.rows() ) {
     //       incomingDataValue2.append ( row.getFloat("ECG_filtered") );
     //     }
     
     if ( getList("con").size() > table_con.getRowCount() )
       println( "WARNING: class connection, storeFromText(): reading is slower than writing.\n");
        
        println("Read from table process has completed. ");
        println("storeFromText function ends here. ");
        println("");
        
     executionNumber++;
        
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
      
      while ( serialAvailable && added < numToExtract && counter < numToExtract*3 && myPort.available() > 4 )
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
  
  public FloatList extractFromBuffer (String listName, int numberOfElements) // gives out numberOfElements elements from the selected list and ERASE THOSE ELEMENTS
    {
      FloatList toOutput = new FloatList();  
      boolean emptyList = false;

      int originalListCondSize = getList("con").size();     
      float inValue = 0;
      short added = 0;
      

      if (listName.equals("con")) //<>//
       {
         // extract numberOfElements of elements from conductance list

         while(! (getList("con").size() <= originalListCondSize  - numberOfElements) && !emptyList) 
            {
              int currentListCondSize = getList("con").size();
              if ( currentListCondSize > 0 )
                 {                   
                   // !connectionAvailable: there aren't any connections available, we're reading the DATA from an OFFLINE TABLE
                   // with randomIndex we pick a different set of values for each cycle              

                   int index = currentListCondSize - 1;
                   if ( index >= 0 && index <= currentListCondSize )
                       {
                         inValue = incomingCond.remove( index );
                         toOutput.append( inValue );
                         added++;
                         }                

                  }
              else
                  emptyList = true;
                  
            }                  //<>//
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



 