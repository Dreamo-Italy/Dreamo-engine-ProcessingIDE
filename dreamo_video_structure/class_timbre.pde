import ddf.minim.analysis.*;

class Timbre extends FeaturesExtractor
{
  //private float[] samples;
  
  private float[] FFTcoeffs;
  private int specSize;
  private float spectralCentroidHz;
  
  public Timbre(int bSize, float sRate)
  {
    buffSize=bSize;
    sampleRate=sRate; 
    spectralCentroidHz=0;
  }
  
  public void setFFTCoeffs(float[] coeffs)
  {
    //TODO: check if initialized
    FFTcoeffs=new float[specSize];
    FFTcoeffs=coeffs.clone();
    calcFeatures(); 
  }
  
  public void setSpecSize(int sz)
  {
    specSize=sz;
  }
  
  public float getCentroidHz()
  {
    return spectralCentroidHz;
  }
  
  public void calcFeatures()
  {
    calcSpectralCentroid();
  }
 
  private void calcSpectralCentroid()
  {
    float num=0;
    float denom=0;
    float sc=0;
    for(int i=0;i<specSize;i++)
    {
      num+=(centerFreqHz(i)*FFTcoeffs[i]);
      denom+=FFTcoeffs[i];    
    }
    if(denom!=0){sc = num/denom;}
    else{sc=0;}
    spectralCentroidHz=expSmooth(sc, spectralCentroidHz, 5);
    //spectralCentroidHz=sc;
  }
  
  private float centerFreqHz(int idx)
  { 
     return (idx*sampleRate)/buffSize; 
  }

}