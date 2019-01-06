//package dreamo.display;

abstract class Biosensor 
{
 //************ CONSTANTS **************

 final private int CALIBRATION_TIME = 30; // duration of the CALIBRATION PROCESS, expressed in seconds


 //********* PUBLIC MEMBERS ***********
 public String sensorName;
 public float normalized; // absolute value of the output, normalized to a 1-10 scale
 public float variation; // percentage variation WRT default value
 public float value; // last value (not normalized)

 protected float physicalMin, physicalMax; // the theoretical MINIMUM and MAXIMUM values of the current sensor


 //********* PRIVATE MEMBERS ***********

 private float bpm, StDev, VarEcg, EmoPar, MaxBpm;
 private boolean connected; // connection status of the sensor
 private float defaultValue; // average of the incoming values
 private boolean calibrating; // TRUE IF the calibration process IS RUNNING
 private boolean calibrated; // TRUE if the calibration process HAVE BEEN RUN already
 private int calibrationCounter;
 protected int sampleToExtract;
 protected FloatList incomingValues; // vector of float
 protected FloatList calibrationValues;


 //********* CONSTRUCTOR ***********

 public Biosensor() 
 {
  sensorName = "default";
  normalized = -1;
  physicalMin = -1;
  physicalMax = -1;

  calibrating = false;
  calibrated = false;
  calibrationCounter = 0;

  // number of BIOMEDICAL VALUES to extract at each update() cycle   
  sampleToExtract =(int) FastMath.ceil((global_sampleRate / global_fps));

  incomingValues = new FloatList();

  if (global_connection != null)
   connected = global_connection.networkAvailable();

  init(); // specific sensor constructor

 }

 //********* METHODS ***********

 public void checkCalibration() // set defaultValue to the initial condition of the sensor
 {
  if (this.needCalibration()) 
  {
   if (this.isCalibrating() == false)
     startCalibration();

   calibration();

   if (calibrationCounter > frameRate * CALIBRATION_TIME)
    endCalibration();
   }
  }

 protected void startCalibration() 
 {
  calibrationValues = new FloatList();
  calibrationValues.clear();
  calibrating = true;
 }

 protected void calibration() 
 {
  if (!calibrating) 
  {
   println("WARNING: not calibrating error");
   return;
  } 
  else if (calibrated) 
  {
   println("WARNING: already calibrated error");
   return;
  } 
  else if (incomingValues.size() == 0) 
  {
   println("ERROR: incomingValues is empty");
   return;
  }

  calibrationValues.append(incomingValues);

  //println("Calibrating sensor: " + getID());
  //println();

  calibrationCounter++;
 }


 protected void endCalibration() 
 {

  float average = computeAverage(calibrationValues, (min(calibrationValues.array()) + max(calibrationValues.array())) / 2);

  if (sensorName == "ecg" && calibrationValues != null) 
  {
   //float [] ecgFiltered = this.filterEcgData( calibrationValues.array() );

   //BPMcal = ECGBPM3( ecgFiltered ); 
   //setBpm ( BPMcal );
   //setValue  ( BPMcal );
   //setDefault( BPMcal );
  }

  if (getID() == "gsr")
   setDefault(normalizeValue(average));

  println("new normalized average: " + average);

  calibrationValues.clear();

  calibrating = false;
  calibrated = true;
  calibrationCounter = 0;
 }

 protected boolean isCalibrating() 
 {
  return calibrating;
 }

 protected boolean needCalibration() 
 {
  return !calibrated;
 }

 protected void restartCalibration() 
 {
  calibrated = false;
 }

 //map the value to a 0-1 scale according to the experimental min and max values
 private float normalizeValue(float toNormalize) 
 {
  // map function from Processing libraries: map(value, start1, stop1, start2, stop2)

  float normalized = map(toNormalize, getPhysicalMin(), getPhysicalMax(), 0, 1);
  return normalized;
 }

 // simple "average" function
 public float computeAverage(FloatList inputList, float oldAverage) 
 {
  if (inputList == null) 
  {
   println(" ERROR: computeAverage: NULL argument ");
   return oldAverage;
  }

  float average = oldAverage;
  int listSize = inputList.size();
  if (listSize == 0) 
  {
   println("ERROR: Argument of computeAverage is an empty list. ");
   return oldAverage;
  } 
  else 
  {
   float sum = 0;

   for (int i = 0; i < listSize; i++) 
   {
    if (inputList.get(i) < MAX_FLOAT) 
    {
     sum += inputList.get(i);
    } 
    else 
    {
     inputList.set(i, oldAverage);
     sum += inputList.get(i);
     println("WARNING: corrupted float found during computeAverage. Index: " + i);
    }
   }
   average = (float) sum / listSize;
  }

  return average;

 }

 //TODO: move this into ECG class

 public void printDebug() 
 {
  int xOffset = marginSpace;
  int yOffset = interlineSpace * 2;
  if (sensorName == "ecg") 
  {
   yOffset = interlineSpace * 3;
   text(sensorName + " BPM: " + nf(getBpm(), 2, 0), xOffset, yOffset);
  } 
  else
   text(sensorName + " normalized : " + nf(getNormalized(), 2, 2) + "; variation: " + nf(getVariation(), 1, 2) + "; default value : " + nf(getDefault(), 1, 2) + "; not normalized: " + nf(getValue(), 1, 2), xOffset, yOffset);
    
  if (isCalibrating() && sensorName == "gsr")
   text("Calibration is running", xOffset, interlineSpace * 4);
 }

 //********* SET METHODS **********

 // set the sensor CURRENT VALUE
 // when setValue is called, every other info is updated ( normalized, variation,... )
 public void setValue(float val) 
 {
  value = val;

  setNormalized(normalizeValue(value));
  setVariation(getNormalized() / getDefault());

 }



 //UTILITIES
 public float[] squareArray(float[] a) 
 {
  //Squaring the signal to increase the peak
  for (int i = 0; i < a.length; i++) 
  {
   a[i] = a[i] * a[i];
  }
  return a;
 }

 public float[] differentiateArray(float[] a) 
 {
  // Differentiator
  for (int i = 0; i < a.length; i++) 
  {
   if (i > 3) 
   {
    a[i] = 0.1 * (2 * a[i] + a[i - 1] - a[i - 3] - 2 * a[i - 4]);
   }
  }
  return a;
 }


 public float computeStdDev(float[] tacogramma, int b) 
 {
  float StdDev, maxDev, maxAva, maxVar, VariateNorm;
  float a[] = new float[tacogramma.length];
  a = Arrays.copyOf(tacogramma, tacogramma.length);
  float sum = 0, sumSq = 0;
  float xisq;
  float xmsq;
  float avarage, Variate;
  float N = a.length;
  for (int i = 0; i < N; i++) 
  {
   sum = +a[i];
  }
  avarage = sum / N;

  for (int i = 0; i < N; i++) 
  {
   sumSq = + sq(a[i]);
  }
  xmsq = sq(avarage);
  xisq = sumSq / N;
  StdDev =(float) FastMath.sqrt(xisq - xmsq);
  maxAva = (1.9 - 0.28) / 2;
  maxDev = (float) FastMath.sqrt(((sq(1.9) - sq(0.48)) / 2) - sq(maxAva));
  maxVar = maxDev / maxAva;

  if (b == 1) 
  {
   Variate = StdDev / avarage;
   VariateNorm = maxVar / Variate;
   return VariateNorm;
  } 
  else 
  {
   return StdDev;
  }
 }

 /******************************************************************************************************/
 // when setValue is called, every other info is updated ( normalized, variation,... )
 public void setDefault(float def) 
 {
  defaultValue = def;
  return;
 }
 
 public void setVariation(float var) 
 {
  variation = var;
  return;
 }
 
 public void setNormalized(float abs) 
 {
  normalized = abs;
  return;
 }
 
 public void setBpm(float newBpm) 
 {
  bpm = newBpm;
  return;
 }
 
 public void setStDev(float stDev) 
 {
  StDev = stDev;
  return;
 }
 public void setVarEcg(float varEcg) 
 {
  VarEcg = varEcg;
  return;
 }
 
 public void setEmotionPar(float emoPar) 
 {
  EmoPar = emoPar;
  return;
 }
 
 public void setMaxBpm(float maxBpm) 
 {
  MaxBpm = maxBpm;
  return;
 }

 //********* GET METHODS ***********
 public float getMaxBpm() 
 {
  return MaxBpm;
 }
 
 public float getEmotionPar() 
 {
  return EmoPar;
 }
 
 public float getVarEcg() 
 {
  return VarEcg;
 }
 public float getStDev() 
 {
  return StDev;
 }

 public float getBpm() 
 {
  return bpm;
 }
 
 public float getPhysicalMin() 
 {
  return physicalMin;
 }
 
 public float getPhysicalMax() 
 {
  return physicalMax;
 }
 
 public float getDefault() 
 {
  return defaultValue;
 }
 
 public float getValue() 
 {
  return value;
 }
 
 public float getNormalized() 
 {
  return normalized;
 } // normalized value of the output, mapped to a 0-1 scale
  
 public float getVariation() 
 {
  return variation;
 } // percentage variation of the sensor with respect to the default value
 
 public String getID() 
 {
  return sensorName;
 }

 // the following methods depend on the SPECIFIC SENSOR
 //********* ABSTRACT METHODS ***********

 abstract void init();
 abstract void update(); // update() is called at FrameRate speed

 // abstract void storeFromText();
}
