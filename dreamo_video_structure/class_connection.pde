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
  
  final int BUFFER_SIZE = 20; //random value
  private Queue <Integer> incomingData = new ArrayDeque(); // create a queue to store the data
  
  
  public Connection( PApplet p ) // p = parent is needed for the Serial myport ( -->parent<--, list[0], 9600...)
  {
    wifiAvailable = false;
    serialAvailable = false;
    anyConnectionAvailable = false;
    
    incomingValue = 0;
    parent = p;
    
    // DEBUG -- TEMPORARY
    incomingData.add(7);
    incomingData.add(8);
    incomingData.add(7);
    incomingData.add(6);
    incomingData.add(10);
    incomingData.add(7);
    incomingData.add(7);
    incomingData.add(6);
    incomingData.add(6);
    incomingData.add(7);
    incomingData.add(7);
    // DEBUG -- TEMPORARY
    
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
  
  public boolean networkAvailable()
  {
    return anyConnectionAvailable;
  }
  
  private void storeFromSerial()
{
    if ( !serialAvailable ) println(" ERROR: storeFromSerial has been called, but the port is not available");
    
        if ( incomingData.size() > BUFFER_SIZE ) // security check
        { 
          incomingData.clear();
          println("WARNING: queue was getting big: queue is now empty");
        }

    
    while ( serialAvailable && myPort.available() > 0 ) // while there is something on the serial buffer
      {
          incomingValue = myPort.read();
          incomingData.add(incomingValue);
      }
    
}
  
  
  
  private boolean serialConnect() // return TRUE if there is data on the serial buffer
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

  private boolean wifiConnect()
  {
    boolean wifiAvailable = false;
    
    return wifiAvailable;
  }
  
public int getAnElement() // gives out an element from the QUEUE incomingData 
  {
    int toOutput = -1;
    
    if (!incomingData.isEmpty() ) 
        toOutput = incomingData.remove();
     
     // TEMPORARY
     incomingData.add(15);
     //TEMPORARY
     
    return toOutput;
  }
  

  
}



 