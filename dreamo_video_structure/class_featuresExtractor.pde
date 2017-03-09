abstract class FeaturesExtractor
{
  
  protected float[] samples;
  protected int buffSize;
  protected float sampleRate;
  private boolean init;
  
  FeaturesExtractor()
  {
    buffSize=0;
    sampleRate=0;
    init=false; 
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
      calcFeatures();   
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
  //exponentially decaying moving average ->window=N
  public float expSmooth(float input, float output, int N)
  {
    //averaging constant
    float tiny;
    tiny=1f-(1f/N);

    return tiny*output+(1-tiny)*input;
   
  }
  
  abstract void calcFeatures();

  
}