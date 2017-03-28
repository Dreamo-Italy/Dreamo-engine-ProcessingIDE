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
  public float expSmooth(final float currentval, final float smoothedval, int N)
  {
    //averaging constant
    float tiny;
    tiny=1f-(1f/N);

    return tiny*smoothedval+(1-tiny)*currentval;
   
  }
  
  //UTILITY METHODS
  public float linearToDecibel(final float value)
  {
    return 20.0 * (float) Math.log10(value);
  }
  
  //ABSTRACT METHODS  
  abstract void calcFeatures();

  
}