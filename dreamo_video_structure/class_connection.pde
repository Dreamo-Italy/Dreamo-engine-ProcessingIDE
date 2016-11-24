//package dreamo.display;


import processing.serial.*; 

import java.util.Queue;
import java.util.ArrayDeque;


class Connection
{
  Serial myPort;  // Create object from Serial class

                    //values given by the galvanic skin response
                      // GSR[0] is CON, GSR[1] is RES, GSR[2] is CONV

  private boolean wifiAvailable;
  private boolean serialAvailable;
  private int incomingValue; // the input coming from a biosensor
  
  public PApplet parent;
  
  final int BUFFER_SIZE = 20;
  private Queue <Integer> incomingData = new ArrayDeque(); // create a queue to store the data
  
  
  public Connection( PApplet p ) // p = parent is needed for the Serial myport ( -->parent<--, list[0], 9600...)
  {
    wifiAvailable = false;
    serialAvailable = false;
    incomingValue = 0;
    parent = p;
    
    if(!wifiAvailable) 
      { 
        if ( serialConnect() )
          serialAvailable = true;
        else
          println("Serial port is not available");
      }
        
    
  }
  
  private void storeFromSerial()
{
    if ( !serialAvailable ) println(" storeFromSerial has been called, but the port is not available");
    
    while ( myPort.available() > 0 ) // while there is something on the serial buffer
      {
          incomingValue = myPort.read();
          incomingData.add(incomingValue);
      }
    
    if ( incomingData.size() > BUFFER_SIZE )
        { 
          incomingData.clear();
          println("queue was getting too big: queue is now empty");
        }
}
  
  
  
  private boolean serialConnect() // return TRUE if there is data on the serial buffer
  {
    // I know that the first port in the serial list on my mac
    // is Serial.list()[0].
    // On Windows machines, this generally opens COM1.
    // Open whatever port is the one you're using.
    
    boolean portAvailable;
    String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
    myPort = new Serial(parent, portName, 9600);
    
    if(myPort.available() > 0) // there should be a better check than this
        portAvailable = true; 
    else portAvailable = false;
    
    return portAvailable;   
  }

  private boolean wifiConnect()
  {
    boolean wifiAvailable = false;
    
    return wifiAvailable;
  }
  
public int getAnElement()
  {
    int toOutput = -1;
    
    if (!incomingData.isEmpty() ) 
        toOutput = incomingData.remove();
     
    return toOutput;
  }
  
}



 