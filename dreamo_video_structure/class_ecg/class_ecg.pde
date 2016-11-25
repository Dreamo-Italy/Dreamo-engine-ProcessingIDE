class ECG extends Biosensor
{  
  
    defaultValue = 60;
    sensorMin = 70;
    sensorMax = 90;
  
  public void init()
  {
    
  }
  
  public int getAnInt() // takes an int out of the current connection
  {
    int incoming = -1;
    
    if (global_connection != null )
      incoming = global_connection.getAnElement();  

    return incoming;
   
  }
  
}