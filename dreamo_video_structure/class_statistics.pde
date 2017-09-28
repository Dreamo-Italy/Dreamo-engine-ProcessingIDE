class Statistics
{
  private float sum;
  private float[] acc;
  private int window;
  private int delay;
  private int aidx;
  private float temp_var;


  public Statistics(int window)
  {
    aidx=0;
    sum=0;
    temp_var=0;
    this.window=window;
    this.delay=0;
    acc=new float[window];
  }
  
  public Statistics(int window, int delay)
  {
    aidx=0;
    sum=0;
    temp_var=0;
    this.window=window;
    this.delay=delay;
    acc=new float[window+delay];
  }

  public float getAverage()
  {
    return sum/window;
  }
  
  public float getVariance()
  {
    if(temp_var<0){temp_var=0;}
    return temp_var/window;
  }
  
  public float getStdDev()
  {
    return (float)FastMath.sqrt(getVariance());
  }
  
  public float getMax()
  {
    return DSP.vmax(acc);
  }
  
  public float getMin()
  {
    return DSP.vmin(acc);
  }

  public void reset()
  {
    acc=new float[window];
    aidx=0;
    sum=0;
    temp_var=0;   
  }
  
  public void accumulate(float data)
  {
    sum -= acc[aidx];//subtract last value
    temp_var -= FastMath.pow((acc[aidx]-getAverage()),2);
    
    acc[aidx]=data;//update the value
    
    sum+=acc[aidx];//update the total    
    temp_var+= FastMath.pow((acc[aidx]-getAverage()),2);
    
    aidx++;//next position
    if (aidx>=window) 
    {
      aidx=0;
    }//if at the end go back 
  }
}