abstract class FeaturesExtractor
{
  
  protected float[] samples;
  protected int buffSize;
  protected float sampleRate;
  private boolean init;
  
  //SOPE CALC VARIABLES
  private float previousVal;
  private float slope;
  
  private float[] diffMemory;
  
  
  FeaturesExtractor()
  {
    buffSize=0;
    sampleRate=0;
    init=false; 
    previousVal=0;
    slope=0;
    diffMemory=new float[5];
  }
  
  /*FeaturesExtractor(int bSize, float sRate)
  {
    samples=new float[bSize];
    buffSize=bSize;
    sampleRate=sRate;
    init=false;
  }
  */
  
  //SET METHODS
  public void setSamples(float[] _samples)
  {   
      samples=_samples.clone();
      //calcFeatures();   
  }
  
  //public void setBufferSize
  
  public void setInitialized()
  {
    init=true;
  }
  
  //GET METHODS 
  public int getBufferSize()
  {
    return buffSize;
  }
  
  public float getSampleRate()
  {
    return sampleRate;
  }
  
  public boolean isInitialized()
  {
    return init;
  }
  
  //CALC METHODS
  //exponentially decaying moving average -> window=N
  protected float expSmooth(final float currentval, final float smoothedval, int N)
  {
    //averaging constant
    float tiny;
    tiny=1f-(1f/N);

  return tiny * smoothedval + (1 - tiny) * currentval;
 }

 //UTILITY METHODS
 protected float linearToDecibel(final float value) { return 20.0 * (float) FastMath.log10(value); }
 
 protected float realTimeSlope(float input) 
 {
  slope = input - previousVal;
  previousVal = input;
  return slope;
 }

 public float differentiateArray(float input) 
 {
  diffMemory[4] = input;
  for (int i = 1; i < diffMemory.length; i++) 
  {
   diffMemory[i - 1] = diffMemory[i];
  }
  //return 0;
  // Differentiator    
  return 0.1 * (2 * diffMemory[4] + diffMemory[3] - diffMemory[1] - diffMemory[0]);
 }

 //ABSTRACT METHODS  
 abstract void calcFeatures();
}
