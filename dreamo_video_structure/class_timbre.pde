import ddf.minim.analysis.*;

class Timbre extends FeaturesExtractor 
{
 //SPECTRUM DATA
 private float[] FFTcoeffs;
 private int specSize;

 //AVERAGE SPECTRUM MAGNITUDE
 private float avgMagnitude;

 //CENTROID VARIABLES
 private float spectralCentroidHz;
 private float spectralCentroidNormalized;

 //CENTROID STATISTICS
 private Statistics centroidLongTerm; //long term statistics
 private final int W = 129; // long term statistics window length (43=~1s)
 private Statistics centroidShortTerm; //short term statistics

 //COMPLEXITY VARIABLES
 private float spectralComplexity;
 private final float COMPLEXITY_THRESHOLD_COEFF = 2.6;

 //COMPLEXITY STATISTICS
 private Statistics complexityLongTerm;

 //ZERO CROSSING RATE
 private float ZCR;

 // COBE VARIABLES
 private float[] EnvSignal;
 private float[] EnvFilteredSignal;
 private float[] COBEistant;
 private float COBEsamples;

 private float[] EBFistant;
 private float EBFsamples;

 //COBE STATISTICS
 private Statistics COBElongTerm;
 private Statistics COBEshortTerm;

 private Statistics EBFlongTerm;
 private Statistics EBFshortTerm;
 
 // SKEWNESS EASY VARIABLES
 private float SkewnessE;
 
 // SKEWNESS EASY STATISTICS
 private Statistics SkewnessElongTerm;
 private Statistics SkewnessEshortTerm;
 
 // SKEWNESS DIFFICULT VARIABLES
 private float SkewnessD;
 
 // SKEWNESS DIFFICULT STATISTICS
 private Statistics SkewnessDlongTerm;
 private Statistics SkewnessDshortTerm;
 
 //Roughness VAR
 private float Roughness;
 private float level;
 
 // Roughness  STATISTICS
 private Statistics RoughnessLongTerm;
 private Statistics RoughnessShortTerm;
 
 //**** CONSTRUCTOR
 public Timbre(int bSize, float sRate) 
 {

  buffSize = bSize;
  sampleRate = sRate;

  FFTcoeffs = new float[bSize / 2 + 1];

  spectralCentroidHz = 0;
  spectralComplexity = 0;

  //initialize statistics data
  centroidLongTerm = new Statistics(W);
  centroidShortTerm = new Statistics(43); // 1 sec   

  complexityLongTerm = new Statistics(W);

  // ZCR initialize
  ZCR = 0;

  // COBE STATS CREATION
  COBElongTerm = new Statistics(W);
  COBEshortTerm = new Statistics(43);

  EBFlongTerm = new Statistics(W);
  EBFshortTerm = new Statistics(43);
  
  //SKEWNESS EASY
  SkewnessE = 0;
  
  //SKEWNESS EASY STATS
  SkewnessElongTerm = new Statistics(W);
  SkewnessEshortTerm = new Statistics(43);
  
  //SKEWNESS DIFFICULT
  SkewnessD = 0;
  
  //SKEWNESS DIFFICULT STATS
  SkewnessDlongTerm = new Statistics(W);
  SkewnessDshortTerm = new Statistics(43);
  
  //Roughness VAR
  Roughness = 0;
  
  //Roughness  STATISTICS
  RoughnessLongTerm = new Statistics(W);
  RoughnessShortTerm = new Statistics(43);
  
 }

 //SET METHODS

 // Sets FFT coefficients (used in AudioProcessor)

 public void setFFTCoeffs(float[] coeffs, int size) 
 {
  specSize = size;
  FFTcoeffs = coeffs.clone();
 }

 public void setAvgMagnitude(float avgm) { avgMagnitude = avgm; }
 
 public void setRMS(float RMSvalue) {level = RMSvalue ;}

 //GET METHODS
 public float getAvgMagnitude() { return avgMagnitude; }

 //CENTROID  
 public float getCentroid() { return spectralCentroidNormalized; } //instantaneous - normalized respect the theoretical maximum

 public float getCentroidAvg() { return centroidLongTerm.getAverage(); } //average - normalized respect the theoretical maximum

 public float getCentroidStdDev() { return centroidLongTerm.getStdDev(); } //std deviation - normalized respect the theoretical maximum

 public float getCentroidHz() { return spectralCentroidHz; } //instantaneous in Hz

 public float getCentroidShortTimeAvgHz() { return centroidShortTerm.getAverage(); }

 public float getCentroidShortTimeMaxHz() { return centroidShortTerm.getMax(); }

 //COMPLEXITY
 public float getComplexity() { return spectralComplexity; }

 public float getComplexityAvg() { return complexityLongTerm.getAverage(); }

 public float getMagnitudeThreshold() { return COMPLEXITY_THRESHOLD_COEFF; }

 //ZCR
 public float getZeroCrossingRate() { return ZCR; }

 //COBE GETTER
 public float[] getCOBEarray() { return COBEistant; }

 public float getCOBEsamples() { return COBEsamples; }

 public float[] getRMSenvelope() { return EnvSignal; }

 public float[] getRMSenvelopeFilteredSignal() { return EnvFilteredSignal; }

 public float getCOBElongTermAvg() { return COBElongTerm.getAverage(); }

 public float getCOBEshortTermAvg() { return COBEshortTerm.getAverage(); }

 public float getMaxCOBElongTerm() { return COBElongTerm.getMax(); }

 public float getMaxCOBEshortTerm() { return COBEshortTerm.getMax(); }

 public float getMinCOBElongTerm() { return COBElongTerm.getMin(); }

 public float getMinCOBEshortTerm() { return COBEshortTerm.getMin(); }

 public float [] getEBFarray() { return EBFistant; }

 public float getEBFsamples() { return EBFsamples; }

 public float getEBFlongTermAvg() { return EBFlongTerm.getAverage(); }

 public float getEBFshortTermAvg() { return EBFshortTerm.getAverage(); }
 
 // SKEWNESS  EASY GETTER
 public float getSkewnessE() { return SkewnessE; }
 
 public float getSkewnessEshortTermAvg() { return SkewnessEshortTerm.getAverage(); }
 
 public float getSkewnessElongTermAvg() { return SkewnessElongTerm.getAverage(); }
 
 // SKEWNESS  DIFFICULT GETTER
 public float getSkewnessD() { return SkewnessD; }
 
 public float getSkewnessDshortTermAvg() { return SkewnessDshortTerm.getAverage(); }
 
 public float getSkewnessDlongTermAvg() { return SkewnessDlongTerm.getAverage(); }
 
 //Roughness GETTER
 public float getRoughness() { return Roughness; } // su picchi in 512 samples
 
 public float getRMS() { return level  ;}
 
 public float getRoughnessShortTermAvg() { return RoughnessShortTerm.getAverage(); } // 1 sec 
 
 public float getRoughnessLongTermAvg() { return RoughnessLongTerm.getAverage(); } // 3 sec
 
 
 //CALC FEATURES METHOD (overrides the inherited method)
 public void calcFeatures() 
 {
  calcSpectralCentroid(); //contains also spectral complexity calc
  calcSpectralComplexity();
  calcZeroCrossingRate();
  calcCOBE(); // calcola COBE istantaneo (1024 valori per buffer da 1024 samples), COBE su 3 sec , COBE su 1 sec.
  calcSpectralSkewnessE();
  calcSpectralSkewnessD();
  calcRoughness();
 }

 //PRIVATE METHODS

 private void calcCOBE() 
 {
  EnvSignal = new float[samples.length];
  EnvFilteredSignal = new float[samples.length];
  COBEistant = new float[samples.length];
  EBFistant = new float[samples.length];

  float tmp = 0;
  float tmp1 = 0;

  // OTTENGO INVILUPPI
  EnvSignal = fastRMS(1);
  EnvFilteredSignal = fastRMS(2);

  //CALCOLO COBE e EBF 
  for (int i = 0; i < COBEistant.length; i++) 
  {
   COBEistant[i] = EnvFilteredSignal[i] / EnvSignal[i];

   EBFistant[i] = (float) ((44100 / PI) * FastMath.asin( COBEistant[i] / 2));
  }

  // EBF medio su 1024 samples
  for (int i = 0; i < EBFistant.length; i++) 
  {
   tmp1 = tmp1 + EBFistant[i];
  }
  EBFsamples = tmp1 / EBFistant.length;

  // CHECK FOR NANs 
  if (Float.isNaN(EBFsamples)) 
  {
   EBFsamples = 0;
  }

  // Accumuluate for stats
  EBFlongTerm.accumulate(EBFsamples);
  EBFshortTerm.accumulate(EBFsamples);

  // NORMALIZZO COBE  TRA 0 E 1 
  float max = max(COBEistant);
  float min = min(COBEistant);

  for (int i = 0; i < COBEistant.length; i++) 
  {
   COBEistant[i] = (COBEistant[i] - min) / (max - min);
  }

  // MEDIA COBE SU 1024 SAMPLES
  for (int i = 0; i < COBEistant.length; i++) 
  {
   tmp = tmp + COBEistant[i];
  }
  COBEsamples = tmp / COBEistant.length; // media del COBE su 1024 samples. Lo faccio così perchè cosi poi posso accumulare le medie 

  // CHECK FOR NANs 
  if (Float.isNaN(COBEsamples)) 
  {
   COBEsamples = 0;
  }

  // Accumuluate for stats
  COBElongTerm.accumulate(COBEsamples);
  COBEshortTerm.accumulate(COBEsamples);

 }

 private float[] fastRMS(int method) // method == 1 means  rms env on NON FILTERED signal , method == 2 mean rms env  on FILTERED signal
 {
  int windowsize = samples.length / 4;
  float[] samp = new float[samples.length];
  float[] x = new float[samples.length];
  float[] w = new float[windowsize];
  float[] y = new float[samples.length];
  int m = 0;

  if (method == 1) 
  {
   for (int i = 0; i < samples.length; i++) 
   {
    x[i] = (samples[i] * samples[i]) / windowsize;
   }
  }

  if (method == 2) 
  {
   for (int i = 0; i < samples.length; i++) 
   {
    samp[i] = samples[i];
   }
   //applico flitro al segnale 
   samp = DSP.HighPass(samp, 5000, 44100); // il secondo argoemto è la frequenza di taglio del filtro 

   for (int i = 0; i < samples.length; i++) 
   {
     x[i] = (samp[i] * samp[i]) / windowsize;
   }
  }

  for (int i = 0; i < windowsize; i++) // lunghezza w = 512
  {
   w[i] = 0;
  }

  for (int i = 0; i < samples.length; i++) 
  {
   y[i] = 0;
  }

  y[0] = x[0];

  for (int n = 1; n < x.length; n++) 
  {
   y[n] = y[n - 1] - w[m] + x[n];
   w[m] = x[n];
   m = (int)((m + 1) - FastMath.floor((m + 1) / windowsize) * windowsize);
  }

  for (int i = 0; i < y.length; i++) 
  {
   y[i] = (float) FastMath.sqrt(y[i]);
  }

  return y;

 }
 
 private void calcSpectralSkewnessD()
 {
   double tmp = 0;
   double tmp1 = 0;
   double tmp2 = 0;
   double meanFFT = 0;
   double sum = 0;
   double sum1 = 0;
   double sd = 0; 
   double s3 = 0;
   double m3 = 0;
   
   for(int i = 0; i < specSize - 1; i++ )
   {
     tmp = tmp + FFTcoeffs[i];
   }
   meanFFT = tmp / (specSize - 1);
   
   for(int i = 0; i < specSize - 1; i++ )
   {
     tmp1 = FastMath.pow((FFTcoeffs[i] - meanFFT), 2);
     tmp2 = FastMath.pow((FFTcoeffs[i] - meanFFT), 3);
     sum = sum + tmp1;
     sum1 = sum1 + tmp2;
   }
   sum =  sum / specSize - 2;
   sd = FastMath.sqrt(sum);
   
   m3= sum1 / specSize - 1;
   s3 = FastMath.pow(sd, 3);
   
   SkewnessD = (float)m3 / (float)s3;
   
   if(Float.isNaN(SkewnessD))
    SkewnessD = 0;
   
   // Accumulate for stats
   SkewnessDshortTerm.accumulate(SkewnessD);
   SkewnessDlongTerm.accumulate(SkewnessD);
 }
 
 private void calcSpectralSkewnessE()
 {
   double tmp = 0;
   double tmp1 = 0;
   double sum = 0;
   double meanFFT = 0;
   double sdFFT = 0;
   double medianFFT = 0;
   float [] arr = new float[specSize - 1];
   
   //MEDIA
   for(int i = 0; i < specSize - 1; i++ )
   {
     tmp = tmp + FFTcoeffs[i];
   }
   meanFFT = tmp / (specSize - 1);
   
   //SD
   for(int i = 0; i < specSize - 1; i++ )
   {
     tmp1 = FastMath.pow((FFTcoeffs[i] - meanFFT), 2);
     sum = sum + tmp1; 
   }
   sum =  sum / specSize - 2;
   sdFFT = FastMath.sqrt(sum);
   
   //MEDIANA
   arr = FFTcoeffs.clone();
   Arrays.sort(arr);
   
   if ((arr.length) % 2 == 0)
    medianFFT = ( (double)arr[arr.length  / 2] + (double)arr[(arr.length  / 2 ) - 1] ) / 2;
   else
    medianFFT = (double)arr[arr.length / 2];
   
   //SKEWNESS VALUE
   SkewnessE = ( 3 * ( (float)meanFFT - (float)medianFFT) ) / (float)sdFFT;
   
   // Check for NaNs because when in the track ther's a drop the volume goes around 0 so Skew becomes NaN we set it to 0 cause no volume is perfectly symmetric.
   if(Float.isNaN(SkewnessE))
    SkewnessE = 0;

   // ACCUMULATE FOR STATS
   SkewnessEshortTerm.accumulate(SkewnessE);
   SkewnessElongTerm.accumulate(SkewnessE);
 }
 
 //Spectral centroid computation method see https://en.wikipedia.org/wiki/Spectral_centroid
 
 private void calcSpectralCentroid() 
 {
  float num = 0;
  float denom = 0;
  float SC = 0;

  for (int i = 0; i < specSize - 1; i++) 
  {
   num += (centerFreqHz(i) * FFTcoeffs[i]);
   denom += FFTcoeffs[i];
  }

  if (denom != 0) 
  {
   SC = (float) num / denom;
  } 
  else 
  {
   SC = 0;
  }

  //get the value in Hz before the mapping (with smoothing)
  spectralCentroidHz = expSmooth(SC, spectralCentroidHz, 5);

  //collect data for short time stats
  centroidShortTerm.accumulate(SC); //accumulate values       

  //accumulate for long term statistcs
  centroidLongTerm.accumulate(SC);

  //smoothing
  spectralCentroidNormalized = expSmooth(SC, spectralCentroidNormalized, 5);
 }
 
 private void calcRoughness() 
 {
  float [] peakValue = new float[50];  
  float [] freqValue = new float[50];
  boolean largerThanPrevious;
  boolean largerThanNext;
  boolean largerThanNoiseFloor;     
  int peak = 0;
  float fm = 0.0;
  float fcb = 0.0;
  float gfcbParam = 0.0;
  float gfcb = 0.0;
  float num = 0.0;
  float denom = 0.0;
  
  if( 20 * FastMath.log10(level) < -50.0) 
  { 
   Roughness = 0.0;  
   println("flag 1 peak --> " + peak);
   RoughnessShortTerm.accumulate(Roughness);
   RoughnessLongTerm.accumulate(Roughness); 
  }
  else
  {
   for (int i = 1; i < specSize - 1; i++) 
   {
    largerThanPrevious = (FFTcoeffs[i - 1] < FFTcoeffs[i]);
    largerThanNext = (FFTcoeffs[i] > FFTcoeffs[i + 1]);
    largerThanNoiseFloor = (FFTcoeffs[i] > avgMagnitude * 2.6); 
    if (largerThanPrevious && largerThanNext && largerThanNoiseFloor ) 
    {
     peak++;    
     peakValue[ peak - 1 ] = FFTcoeffs[i];
     freqValue[ peak - 1 ] = centerFreqHz(i);
    }
   }
   println("flag 2 peak --> " + peak);
  
   for(int j = 0, k = 1; (j < peakValue.length && k < peakValue.length - 1) ; j++, k++)
   {
    
    if (peakValue[k] == 0.0 ) { break; }
   
    fm = (freqValue[j] + freqValue[k]) / 2;
    fcb = 1.72 * ((float) FastMath.pow(fm, 0.65));  
    gfcbParam = FastMath.abs((freqValue[k] - freqValue[j])) / fcb;
    gfcb = (float) FastMath.pow( ( ( gfcbParam  / 0.25 ) * FastMath.pow( 2.71828, ( 1 - ( gfcbParam  / 0.25 ) ) ) ), 2) ;
   
    num += peakValue[j] * peakValue[k] * gfcb;
    denom += FastMath.pow(peakValue[j], 2);
   }
  
   Roughness = num / denom;
   //println("flag 2 --> " + Roughness);
   //ACUMULATE FOR STAT
   RoughnessShortTerm.accumulate(Roughness);
   RoughnessLongTerm.accumulate(Roughness);
  }
 }
 
 private void calcSpectralComplexity() 
 {
  boolean largerThanPrevious;
  boolean largerThanNext;
  boolean largerThanNoiseFloor;
  int peaks = 0;

  for (int i = 1; i < specSize - 1; i++) 
  {
   largerThanPrevious = (FFTcoeffs[i - 1] < FFTcoeffs[i]);
   largerThanNext = (FFTcoeffs[i] > FFTcoeffs[i + 1]);
   largerThanNoiseFloor = (FFTcoeffs[i] > avgMagnitude * COMPLEXITY_THRESHOLD_COEFF);
   if (largerThanPrevious && largerThanNext && largerThanNoiseFloor) 
   {
    peaks++;
   }
  }
  
  spectralComplexity = expSmooth(peaks, spectralComplexity, 5);
  complexityLongTerm.accumulate(spectralComplexity);
 }

 private void calcZeroCrossingRate() 
 {
  float zeroCrossingRate = 0;
  int numberOfZeroCrossings = 0;
  
  for (int i = 1; i < samples.length; i++) 
  {
   if (samples[i] * samples[i - 1] < 0) 
   {
    numberOfZeroCrossings++;
   }
  }

  zeroCrossingRate = numberOfZeroCrossings / (float)(samples.length - 1);

  //smoothing
  ZCR = expSmooth(zeroCrossingRate, ZCR, 5);
 }

 //Returns the center frequency on Hz of the idx-th bin in the spectrum
  
 private float centerFreqHz(int idx) 
 {
  return (idx * sampleRate) / buffSize;
 }
}