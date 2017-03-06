//package dreamo.display;


import processing.serial.*; 
import java.util.Queue;
import java.util.ArrayDeque;

class Connection
{
  //********* CONSTANTS ***********
     
  final int MAX_SENSOR = 5;
  
  //********* PUBLIC MEMBERS ***********

  Serial myPort;  // Create object from Serial class
  public PApplet parent; //needed for the Serial object istantiation
      
  //********* PRIVATE MEMBERS ***********
  
  private boolean wifiAvailable;
  private boolean serialAvailable;
  private boolean connectionAvailable;
  private int executionNumberGsr, executionNumberEcg; // # of times StoreFromText has been called 
  private float incomingValue,incomingValue2; // the input coming from a biosensor    
  private final int BUFFER_SIZE = 200; // random value
  private final int lineFeed = 10;    // Linefeed in ASCII    
  private final int totSampleToExtract, sampleToExtract;
  private String inputString = null;  
  private FloatList incomingGsr;
  private FloatList incomingEcg;
  private Table table_gsr, table_ecg;

  //********* CONSTRUCTOR ***********
  // p = parent is needed for the Serial myport ( -->parent<--, list[0], 19200...)
  public Connection( PApplet p ) 
  {
    wifiAvailable = false;
    serialAvailable = false;
    connectionAvailable = false;
    executionNumberGsr = 0;
    executionNumberEcg = 0;
    incomingValue = 0;
    parent = p;
 
    incomingGsr = new FloatList();
    incomingEcg = new FloatList();
    
    incomingValue = 0;
    parent = p;
    
    // number of BIOMEDICAL VALUES to extract at each update() cycle   
    totSampleToExtract = round (global_sampleRate/global_fps);  //<>//
    sampleToExtract = totSampleToExtract/2;
    
   //<>// //<>//
    //serial check
    if(!wifiAvailable) 
      { 
        println("WARNING: Wifi is not available");
        if ( serialConnect() )
          serialAvailable = true;
        else
        {
          println("WARNING: Serial port is not available");
          loadOfflineTables();
        }
      } 
     
   // IF WIFI OR SERIAL ARE AVAILABLE SET BOOLEAN TO "TRUE"
   if(! (!wifiAvailable && !serialAvailable) ) 
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
    
    if (ports.length  == 1) // DEBUG = 1 ; RIGHT ONE = 0;
    {
      String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
      myPort = new Serial(parent, portName, 38400);
      portAvailable = true; 
    }
    println("Serial connection is available.");
    return portAvailable;   
 }

  
  
  public void update()
  {    //<>// //<>//
    if( !serialAvailable ) //<>//
         storeFromText();      // read the data from an OFFLINE TABLE
    else if ( serialAvailable )
        storeFromSerial();    // read the data from the SERIAL LINE
 }
 
  private void loadOfflineTables()
  {
    table_gsr = loadTable("log_conductance.csv", "header"); // content of log_conductance
    table_ecg = loadTable("ecg_new_mac.csv", "header"); // content of log_ECG
    println(table_gsr.getRowCount() + " total rows in table conductance"); 
    println(table_ecg.getRowCount() + " total rows in table ECG");  
  }

  public void storeFromText()
  { 
       // CLEAR the list if the list SIZE is five time bigger than needed
       if ( getList("gsr").size() > sampleToExtract*5 )
          { getList("gsr").clear(); println("List is now empty"); }
       // CLEAR the list if the list SIZE is five time bigger than needed
       if ( getList("ecg").size() > sampleToExtract*5 )
          { getList("ecg").clear(); println("List is now empty"); }

      // INDEX IS SHIFTED TO AVOID READING ALWAYS THE SAME VALUES
      if ( executionNumberGsr >= table_gsr.getRowCount()/sampleToExtract )
           executionNumberGsr = 0;
                
      int count = 0; //<>// //<>//
      int multiplier = executionNumberGsr; //<>//
      int iStart = 0 + sampleToExtract*multiplier;
      int iEnd = sampleToExtract*( multiplier + 1); 
      
      // add the content of the table to a LIST OF FLOAT
        for (TableRow row : table_gsr.rows()) {
          float newFloat = row.getFloat("conductance");
          if ( count>=iStart && count<iEnd ) 
            getList("gsr").append (newFloat); 
          count++;
         }         
         
     // INDEX IS SHIFTED TO AVOID READING ALWAYS THE SAME VALUES
      if ( executionNumberEcg >= table_ecg.getRowCount()/sampleToExtract )
           executionNumberEcg = 0;
      
      int count2 = 0;
      int multiplier2 = executionNumberEcg;
      int iStart2 = 0 + sampleToExtract*multiplier2;
      int iEnd2 = sampleToExtract*( multiplier2 + 1); 
                
     for (TableRow row : table_ecg.rows() ) 
     {
       float newFloat2 =row.getFloat("ECG_Filtered");
     if ( count2>=iStart2 && count2<iEnd2 ) 
            getList("ecg").append (newFloat2); 
     count2++;

       }  
    
     
     if ( getList("gsr").size() > table_gsr.getRowCount() || getList("ecg").size() > table_gsr.getRowCount() )
       println( "WARNING: class connection, storeFromText(): reading is slower than writing.\n");
        
      println("Read from table process has completed. ");
      println("");
        
     executionNumberGsr++;
     executionNumberEcg++;
   }
   
    // the function that reads the DATA from the SERIAL LINE BUFFER
   private void storeFromSerial()
  {
    
      int incomingGsrSize = incomingGsr.size();
      int incomingEcgSize = incomingEcg.size();
      if ( !serialAvailable ) println(" ERROR: storeFromSerial has been called, but the port is not available");
      if ( incomingGsrSize > BUFFER_SIZE ) // security check
      { 
        incomingGsr.clear();
        println("WARNING: list was getting big: list Gsr is now empty");
      }
      
      if ( incomingEcgSize > BUFFER_SIZE ) // security check
      { 
        incomingEcg.clear();
        println("WARNING: list was getting big: list Ecg is now empty");
      }
            
      short added = 0, counter = 0; //<>//
      
      myPort.readStringUntil(lineFeed); // clean the garbage //<>//

      // while there is something on the serial buffer, add the data to the "incomingGsr" queue
      // myPort.available() greater than 4: there's a pending FLOAT on the buffer (size: 4 bytes)
      
      while ( serialAvailable && added < totSampleToExtract && counter < totSampleToExtract*3) //&& myPort.available() > 4 )
        {
            inputString = myPort.readStringUntil(lineFeed);
            if (inputString != null) 
            {
              inputString = trim(inputString); // removes "\t"
              float inputValues[] = float(split(inputString, '\t') );
              
              if ( inputValues.length == 2 )
              {
                  incomingValue = inputValues[0];
                  incomingValue2 = inputValues[1];
                  
                  println( " cond: " + incomingValue);
                  println( " ecg: " +incomingValue2);
                  
                  incomingGsr.append(incomingValue);
                  incomingEcg.append(incomingValue2);
                  added++;
              }
            }
            
            counter++;
        }
      
     myPort.clear();
     println("");
     println( "DEBUG : incomingGsr queue size: " + incomingGsr.size() );
     println( "DEBUG : incomingEcg queue size: " + incomingEcg.size() );
     println( "DEBUG : elements added: " + added*2 );
     if ( incomingGsr.size() == 0 ) println(" ERROR in storeFromSerial: incomingGsrSize = 0 ");
     if ( incomingEcg.size() == 0 ) println(" ERROR in storeFromSerial: incomingEcgSize = 0 "); 
  }
  
  // gives out numberOfElements elements from the selected list and ERASE THOSE ELEMENTS
  public FloatList extractFromBuffer (String listName, int numberOfElements) 
    {
      FloatList toOutput = new FloatList();  
      boolean emptyList = false;
      boolean emptyList2 = false;
      int originalListGsrSize = getList("gsr").size();    //<>// //<>//
      int originalListEcgSize = getList("ecg").size(); 
      
      float inValue = 0;
      short added = 0;
      

      if (listName.equals("gsr")) //<>//
       {
         // extract numberOfElements of elements from conductance list

         while(! (getList("gsr").size() <= originalListGsrSize  - numberOfElements) && !emptyList) 
            {
              int currentListGsrSize = getList("gsr").size();
              if ( currentListGsrSize > 0 )
                 {                   
                   // !connectionAvailable: there aren't any connections available, we're reading the DATA from an OFFLINE TABLE
                   // with randomIndex we pick a different set of values for each cycle              

                   int index = currentListGsrSize - 1;
                   if ( index >= 0 && index <= currentListGsrSize )
                       {
                         inValue = incomingGsr.remove( index );
                         toOutput.append( inValue ); //<>// //<>//
                         added++;
                         }                

                  }
              else
                  emptyList = true;
                  
            }   //<>//
      }
      if (listName.equals("ecg"))
       {
         // extract numberOfElements of elements from ECG list
         while(! (getList("ecg").size() <= originalListEcgSize  - numberOfElements) && !emptyList2) 
            {
              int currentListEcgSize = getList("ecg").size();
              if ( currentListEcgSize > 0 )
              {                   
                   // !connectionAvailable: there aren't any connections available, we're reading the DATA from an OFFLINE TABLE
                   // with randomIndex we pick a different set of values for each cycle              

                   int index = currentListEcgSize - 1;
                     if ( index >= 0 && index <= currentListEcgSize )
                         {
                           inValue = incomingEcg.remove( index );
                           toOutput.append( inValue );
                           added++;
                          }              
               }
              else
                  emptyList2 = true;                  
            }
       }
      return toOutput;
    }
  
  public FloatList getList(String sensorName)
  {
    if( sensorName.equals("gsr") )
      return incomingGsr;
      
    if(sensorName.equals("ecg"))
      return incomingEcg;
    else 
      return null;
  }
}



 