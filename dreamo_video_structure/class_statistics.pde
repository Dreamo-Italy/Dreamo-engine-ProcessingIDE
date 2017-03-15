class Statistics
{
  
  float sum;
  float[] acc;
  int window;
  int aidx;
  
  
  public Statistics(int window)
  {
    aidx=0;
    sum=0;
    this.window=window;
    acc=new float[window];
  }
  
  public float getAverage()
  {
    return sum/window;
  }
  
  
  public void accumulate(float data)
  {
    sum-=acc[aidx];//subtract last value
    acc[aidx]=data;//update the value
    sum+=acc[aidx];//update the total
    aidx++;//next position
    if(aidx>=window){aidx=0;}//if at the end go back
    
  }
  
  
}