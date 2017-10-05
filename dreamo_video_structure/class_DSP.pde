import java.util.Arrays;

public final static class DSP {

private DSP() {}


 //*********** DSP algorithms methods *********************

 /* Most of these have analogs in
  * Matlab with the same name. 
  * This code only operates on real valued data.
  */

 //CONVOLVES SEQUENCES a AND b.The resulting convolution has length (a.length+b.length-1)
 public static float[] conv(float[] a, float[] b) 
 {
  float[] y = new float[a.length + b.length - 1];
  // make sure that a is the shorter sequence
  
  if (a.length > b.length) 
  {
   float[] tmp = a;
   a = b;
   b = tmp;
  }

  for (int lag = 0; lag < y.length; lag++) 
  {
   y[lag] = 0;

   // where do the two signals overlap?
   int start = 0;
   // we can't go past the left end of (time reversed) a
   if (lag > a.length - 1)
    start = lag - a.length + 1;

   int end = lag;
   // we can't go past the right end of b
   if (end > b.length - 1)
   {
    end = b.length - 1;
   }

   //System.out.println("lag = " + lag +": "+ start+" to " + end);
   for (int n = start; n <= end; n++) 
   {
    //System.out.println("  ai = " + (lag-n) + ", bi = " + n); 
    y[lag] += b[n] * a[lag - n];
   }
  }
  return (y);
 }

 /******************************************************************************************************/

 //COMPUTES CROSS CORRELATION BETWEEN a AND b. maxlag IS THE MAXIMUM LAG
 public static float[] xcorr(float[] a, float[] b, int maxlag) 
 {
  float[] y = new float[2 * maxlag + 1];
  Arrays.fill(y, 0);

  for (int lag = b.length - 1, idx = maxlag - b.length + 1; lag > -a.length; lag--, idx++) 
  {
   if (idx < 0)
    continue;

   if (idx >= y.length)
    break;

   // where do the two signals overlap?
   int start = 0;
   // we can't start past the left end of b
   if (lag < 0) {
    //System.out.println("b");
    start = -lag;
   }

   int end = a.length - 1;
   // we can't go past the right end of b
   if (end > b.length - lag - 1) 
   {
    end = b.length - lag - 1;
    //System.out.println("a "+end);
   }

   //System.out.println("lag = " + lag +": "+ start+" to " + end+"   idx = "+idx);
   for (int n = start; n <= end; n++) 
   {
    //System.out.println("  bi = " + (lag+n) + ", ai = " + n); 
    y[idx] += a[n] * b[lag + n];
   }
   //System.out.println(y[idx]);
  }
  return (y);
 }


 //COMPUTES AUTOCORRELATION OF a (time domain)
 public static float[] autocorr(float[] a, int maxlag) 
 {
  return xcorr(a, a, maxlag);
 }

 //SUBTRACT MEMBER TO MEMEBER
 public static float[] minus(float[] a, float[] b) 
 {
  //if(a.length==b.length){
  float[] y = new float[a.length];
  for (int x = 0; x < y.length; x++) 
  {
   y[x] = a[x] - b[x];
  }
  return y;
  //}
  /*else {
    println("VECTORS MUST HAVE THE SAME LENGTH");
    return [0,0];
  }*/
 }

 //SUM MEMBER TO MEMBER
 public static float[] plus(float[] a, float[] b) 
 {
  //if(a.length==b.length) {
  float[] y = new float[a.length];
  for (int x = 0; x < y.length; x++) 
  {
   y[x] = a[x] + b[x];
  }
  return y;
  //}
  /*else {
    println("VECTORS MUST HAVE THE SAME LENGTH");
    return [0,0];
  }*/
 }

 //HALF WAVE RECTIFICATION (clipping to positive values)
 public static float[] HWR(float[] a) 
 {
  //float[] b = new float[a.length];
  for (int i = 0; i < a.length; i++) 
  {
   if (a[i] < 0) 
   {
    a[i] = 0;
   }
  }
  return a;
 }

 //UPSAMPLING BY FACTOR n WITH ZERO INSERTION
 public static float[] upsample(final float[] x, int n) 
 {
  float[] y = new float[x.length * n];

  for (int i = 0; i < x.length; i++) 
  {
    
   y[i * n] = x[i];

   for (int j = 1; j < n; j++) 
   {
    y[(i * n) + j] = 0;
   }
   
  }
  return y;
 }

 //FIND MAX VALUE IN a
 public static float vmax(float[] a) 
 {
  float y = Float.MIN_VALUE;

  for (int x = 0; x < a.length; x++)
  {
   if (a[x] > y)
   {
    y = a[x];
   }
  }
  return y;
 }

 //FIND THE MIN VALUE IN a
 public static float vmin(float[] a) 
 {
  float y = Float.MAX_VALUE;

  for (int x = 0; x < a.length; x++)
  {
   if (a[x] < y)
   {
    y = a[x];
   }
  }
  return y;
 }

 //FIND THE INDEX OF THE MAX VALUE IN a
 public static int argmax(float[] a) 
 {
  float y = Float.MIN_VALUE;
  int idx = -1;

  for (int x = 0; x < a.length; x++) 
  {
   if (a[x] > y) 
   {
    y = a[x];
    idx = x;
   }
  }
  return idx;
 }

 //FIND THE INDEX OF THE MIN VALUE IN a
 public static int argmin(float[] a) 
 {
  float y = Float.MAX_VALUE;
  int idx = -1;

  for (int x = 0; x < a.length; x++) 
  {
   if (a[x] < y) 
   {
    y = a[x];
    idx = x;
   }
  }
  return idx;
 }

 //SIMPLE MOVING AVERAGE FILTER WITH WINDOW SIZE = M
 public static float[] MAfilter(final float[] x, int M) 
 {
  float[] y = new float[x.length];
  float[] b = new float[M];

  for (int i = 0; i < b.length; i++) 
  {
   b[i] = 1f / (float) M;
  }

  for (int t = 0; t < x.length; t++) 
  {
   y[t] = 0;
   int len = b.length - 1 < t ? b.length - 1 : t;
   for (int ib = 0; ib <= len; ib++) 
   {
    y[t] += b[ib] * x[t - ib];
   }
  }
  return y;
 }

 /******************************************************************************************************/

 //IIR filter
 public static float[] IIRfilter(float[] b, float[] a, final float[] input) 
 {
  float[] y = new float[input.length];

  // factor out a[0]
  if (a[0] != 1) 
  {
   for (int ia = 1; ia < a.length; ia++)
    a[ia] = a[ia] / a[0];

   for (int ib = 0; ib < b.length; ib++)
    b[ib] = b[ib] / a[0];
  }

  for (int t = 0; t < input.length; t++) 
  {
   y[t] = 0;

   // input terms
   int len = b.length - 1 < t ? b.length - 1 : t;
   for (int ib = 0; ib <= len; ib++)
    y[t] += b[ib] * input[t - ib];

   // output terms
   len = a.length - 1 < t ? a.length - 1 : t;
   for (int ia = 1; ia <= len; ia++)
    y[t] -= a[ia] * y[t - ia];
  }
  return y;
 }

 //Tarsos IIR filter 
 public static float[] TarsosFilter(float[] b, float[] a, final float[] input) 
 {
  float[] x = new float[input.length];
  System.arraycopy(input, 0, x, 0, input.length);

  float[] in = new float[b.length];
  float[] out = new float[a.length];

  for (int i = 0; i < x.length; i++) 
  {
   //shift the in array
   System.arraycopy( in , 0, in , 1, in .length - 1); in [0] = x[i];

   //calculate y based on a and b coefficients
   //and in and out.
   float y = 0;
   for (int j = 0; j < b.length; j++) 
   {
    y += b[j] * in [j];
   }

   for (int j = 0; j < a.length; j++) 
   {
    y += a[j] * out[j];
   }
   
   //shift the out array
   System.arraycopy(out, 0, out, 1, out.length - 1);
   out[0] = y;

   x[i] = y;

  }

  return x;

 }


 //high pass filtering (Tarsos coefficients calculation)
 public static float[] HighPass(final float[] in , float freq, float sampleRate) 
 {
  //calculate coefficients
  float fracFreq = freq / sampleRate;
  float x = (float) FastMath.exp(-2 * FastMath.PI * fracFreq);
  float[] b = { (1 + x) / 2,-(1 + x) / 2 };
  float[] a = { x };
  return TarsosFilter(b, a, in );
 }

 //low pass filtering (Tarsos coefficients calculation)
 public static float[] LowPassSP(final float[] in , float freq, float sampleRate) 
 {
  //calculate coefficients
  float fracFreq = freq / sampleRate;
  float x = (float) FastMath.exp(-2 * Math.PI * fracFreq);
  float[] b = { 1 - x };
  float[] a = { x };

  return TarsosFilter(b, a, in );
 }


 //low pass filtering (Tarsos coefficients calculation)
 public static float[] LowPassFS(final float[] in , float freq, float sampleRate) 
 {
  //minimum frequency is 60Hz!
  freq = freq > 60 ? freq : 60;

  //calculate coefficients
  float fracFreq = freq / sampleRate;
  float x = (float) FastMath.exp(-14.445 * fracFreq);
  float[] b = { (float) FastMath.pow(1 - x, 4) };
  float[] a = { 4 * x, -6 * x * x, 4 * x * x * x, -x * x * x * x };

  return TarsosFilter(b, a, in );

 }

 /******************************************************************************************************/

 public static float[] BandPass(float[] in , float freq, float bandWidth, float sampleRate) 
 {
  float bw = bandWidth / sampleRate;
  float fracFreq = freq / sampleRate;
  float R = 1 - 3 * bw;

  float T = 2 * (float) FastMath.cos(2 * FastMath.PI * fracFreq);
  float K = (1 - R * T + R * R) / (2 - T);
  float[] b = new float[] { 1 - K, (K - R) * T, R * R - K };
  float[] a = new float[] { R * T, -R * R };

  return TarsosFilter(b, a, in );
 }


 //TIME SCALING BY FACTOR K(2-7) (upsampling-> interpolation->delay compensation)
 public static float[] timeScale(float[] in , int k) 
 {
  if (k < 2 || k > 7) 
  {
   println("TIME SCALING FACTOR MUT BE BETWEEN 2-7");
   return in;
  }

  float[] out = new float[ in .length * k];
  float[] b;
  float[] a = { 1.0f };
   
  int delay;
  out = upsample( in , k);

  //interpolation filter design obtained through MATLAB "intfilt" function
  //delay compensation values obtained with the MATLAB "grpdelay" function
  switch (k) 
  {
   case (2):
    b = new float[] { -0.0928f, 0.0000f, 0.5862f, 1.0000f, 0.5862f, 0.0000f, -0.0928f };
    delay = 3;
    //interpolate
    out = IIRfilter(b, a, out);
    //compensate delay    
    for (int i = delay; i < out.length; i++) 
    {
     out[i - delay] = out[i];
    }
    for (int i = out.length - delay; i < out.length; i++) 
    {
     out[i] = 0;
    }
    break;

   case (3):
    b = new float[] {  -0.0737f, -0.0905f, -0.0000f, 0.3856f, 0.7670f, 1.0000f, 0.7670f, 0.3856f, -0.0000f, -0.0905f, -0.0737f };
    delay = 5;
    //interpolate
    out = IIRfilter(b, a, out);
    //compensate delay    
    for (int i = delay; i < out.length; i++) 
    {
     out[i - delay] = out[i];
    }
    for (int i = out.length - delay; i < out.length; i++) 
    {
     out[i] = 0;
    }
    break;

   case (4):
    b = new float[] { -0.0582705792151601f, -0.0927574239625004f, -0.0794091996115624f, -7.58608763583476e-16f, 0.283737725653296f, 0.586188400313451f, 0.844415778667541f, 1.00000000000000f, 0.844415778667541f, 0.586188400313451f, 0.283737725653296f, -7.58608763583476e-16f, -0.0794091996115624f, -0.0927574239625004f, -0.0582705792151601f };
    delay = 7;
    //interpolate
    out = IIRfilter(b, a, out);
    //compensate delay    
    for (int i = delay; i < out.length; i++) 
    {
     out[i - delay] = out[i];
    }
    for (int i = out.length - delay; i < out.length; i++) 
    {
     out[i] = 0;
    }
    break;

   case (5):
    b = new float[] 
    {
     -0.0476885790563417f, -0.0834476814118154f, -0.0943472678474937f, -0.0692546198103147f, -2.58938095830087e-16f,
     0.223500279527746f, 0.466996004841528f, 0.698253729670430f, 0.885435806305467f, 1.00000000000000f, 0.885435806305467f,
     0.698253729670430f, 0.466996004841528f, 0.223500279527746f, -2.58938095830087e-16f, -0.0692546198103147f, -0.0943472678474937f, -0.0834476814118154f, -0.0476885790563417f
    };
    delay = 9;
    //interpolate
    out = IIRfilter(b, a, out);
    //compensate delay    
    for (int i = delay; i < out.length; i++) 
    {
     out[i - delay] = out[i];
    }
    for (int i = out.length - delay; i < out.length; i++) 
    {
     out[i] = 0;
    }
    break;

   case (6):
    b = new float[] 
    {
     -0.0402052901267244f, -0.0736764712886255f, -0.0927574239625000f, -0.0904567084036644f, -0.0609468634305184f, -2.99359031607279e-16f, 0.184012725506651f, 0.385578494336829f, 0.586188400313451f, 0.767049294369887f, 0.910269768364241f,
     1.00000000000000f, 0.910269768364241f, 0.767049294369887f, 0.586188400313451f, 0.385578494336829f, 0.184012725506651f, -2.99359031607279e-16f, -0.0609468634305184f, -0.0904567084036644f, -0.0927574239625000f, -0.0736764712886255f, -0.0402052901267244f
    };
    delay = 11;
    //interpolate
    out = IIRfilter(b, a, out);
    //compensate delay    
    for (int i = delay; i < out.length; i++) 
    {
     out[i - delay] = out[i];
    }
    for (int i = out.length - delay; i < out.length; i++) 
    {
     out[i] = 0;
    }
    break;

   case (7):
    b = new float[] 
    {
     -0.0346912392370583f,-0.0652548207669644f,-0.0868117128907737f,-0.0947612440094304f,-0.0850199866289910f,
     -0.0542405479156626f,1.50963412379881e-15f,0.156231652964996f,0.327260885041986f,0.501542675941591f,0.667195414109892f,
     0.812551039702753f,0.926699030176009f,0.999999999999998f,0.926699030176009f,0.812551039702753f,0.667195414109892f,
     0.501542675941591f,0.327260885041986f,0.156231652964996f,1.50963412379881e-15f,-0.0542405479156626f,-0.0850199866289910f,
     -0.0947612440094304f,-0.0868117128907737f,-0.0652548207669644f,-0.0346912392370583f
    };
    delay = 13;
    //interpolate
    out = IIRfilter(b, a, out);
    //compensate delay    
    for (int i = delay; i < out.length; i++) 
    {
     out[i - delay] = out[i];
    }
    for (int i = out.length - delay; i < out.length; i++) 
    {
     out[i] = 0;
    }
    break;
  }
  return out;
 }

 //MULTIPLIES EACH ELEMENT OF a BY THE SCALAR k
 public static float[] times(final float[] a, float k) 
 {
  float[] y = new float[a.length];

  for (int x = 0; x < y.length; x++)
   y[x] = a[x] * k;

  return y;
 }
}