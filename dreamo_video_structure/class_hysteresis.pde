class Hysteresis
{
  private boolean[] values;
  private float lowerBound;
  private float upperBound;
  private boolean result;
  
  Hysteresis(float lB, float uB)
  {
    this.lowerBound=lB;
    this.upperBound=uB;
    result=false;
  }
  
  
  public boolean check(float value)
  {
    if(value>=upperBound){result=true;} 
    else if(value<=lowerBound){result=false;}
    
    return result;
    
  }
  
  
}