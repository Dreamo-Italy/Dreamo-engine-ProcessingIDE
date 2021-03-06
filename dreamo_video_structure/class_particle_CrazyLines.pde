import java.util.List;
import java.util.ArrayList;

class CrazyLines extends Particle
{

  int formResolution;
  int targetResolution;
  boolean morphing=false;

  float initRadius = 50;

  //POINT ARRAYS
  List<Float> x = new ArrayList<Float>();
  List<Float> y = new ArrayList<Float>();

  //COLOR
  color myColor;
  int colorIDX;

  //ROTATION
  float count = 0;

  float distortionCoeff;
  float elasticityCoeff=1;
  float rotationCoeff=0.009;

  //STROKE WEIGTH CONTROL
  float vibrationFreq=1;
  float vibrationRange=10;
  float weightSeed=10;

  //stroke weigth vibration controls
  float startingWeight;
  float targetWeight;
  float weight;
  float oldWeight;


  public CrazyLines()
  {
   formResolution = 5; //DEFAULT RESOLUTION
   targetResolution=formResolution;
  }


  public CrazyLines(int res)
  {
   formResolution=res;
   targetResolution=formResolution;
  }


  public void init()
  {
   setColorIndex((int)random(0,5));

   float angle = (float) FastMath.toRadians(360/float(formResolution));

   for (int i=0; i<formResolution; i++)
   {
     x.add(i, (float)(FastMath.cos(angle*i) * initRadius));
     y.add(i, (float)(FastMath.sin(angle*i) * initRadius));
   }


   startingWeight=random(weightSeed-vibrationRange/2,weightSeed+vibrationRange/2);
   targetWeight=random(weightSeed-vibrationRange/2,weightSeed+vibrationRange/2);

   weight=startingWeight;
   oldWeight=weight;

  }

  //TODO: QUANDO C'E' UN CAMBIO DI STATUS IMPORTANTE CAMBIA RANDOMICAMENTE L'ASSEGNAZIONE DEI PARAMETRI AI VERTICI
  //in questo modo cambiano le forme ma il comportamento rimane coerente alle feaatures
  //meccanismo simile al cambio di palette

  public void update()
  {
    //**** COLOR
    myColor = pal.getColor(getColorIndex());

    //**** PARAMETERS FOR DIRECT INFLUENCE
    setParameter(0,audio_decisor.getInstantFeatures()[0]);
    setParameter(1, (float) FastMath.pow( 5, audio_decisor.getFeaturesVector()[2] / 2500 ) );
    setParameter(2,audio_decisor.getFeaturesVector()[0]);
    setParameter(3,audio_decisor.getFeaturesVector()[3]);
    setParameter(4,audio_decisor.getFeaturesVector()[2]);

    /*
    //**** PARAMETERS COMING FROM SCENE DECISIONS
    formResolution=(int)getParameter(5);
    elasticityCoeff=getParameter(6);
    vibrationFreq=getParameter(7);
    weightSeed=getParameter(8);
    vibrationRange=getParameter(9);
    rotationCoeff=getParameter(10);
    */

    //**** DIRECT INFLUENCE of TIMBRE on colors SATURATION AND BRIGHTNESS
    pal.influenceColors(0,mapForSaturation(getParameter(3),0,40),mapForBrightness(getParameter(4),0,6000));

    //**** SHAPE RESOLUTION
    changeShape();

    //**** STROKE WEIGHT
    changeStrokeWeight();

    setSpeed(chooseSpeedFromAudio());

  }

  public void trace()
  { //<>// //<>// //<>//
    noFill();

    //**** STROKE WEIGHT VIBRATION ****
    stroke(myColor);

    strokeWeight(weight);  //<>// //<>// //<>// //<>//

    //**** SCALE PULSATION ****
    scale(0.5+getParameter(0)*elasticityCoeff); //DIRECT INFLUENCE of RMS (instantaneous value) on SCALE

    //**** SHAPE GENERATION ****
    float angle = (float) FastMath.toRadians(360/float(formResolution));

    beginShape();

    curveVertex(x.get(formResolution-1)*getParameter(1), y.get(formResolution-1)*getParameter(1)); //start controlpoint
    //curveVertex(x.get(formResolution-1)+centerX, y.get(formResolution-1)+centerY);
    //curveVertex(random(50), random(50));

    //only these points are drawn
    for (int i=0; i<formResolution; i++)
    {

        x.add(i, ((float) FastMath.cos(angle*i) * width/10));
        y.add(i, ((float) FastMath.sin(angle*i) * width/10));

        count = count + (float) FastMath.toRadians(getParameter(2)*rotationCoeff); //DIRECT INFLUENCE of RMS (average) on ROTATION
        rotate(count);

        curveVertex(x.get(formResolution-1)*getParameter(2), y.get(formResolution-1)*getParameter(2));
        curveVertex(x.get(i)*getParameter(1), y.get(i)*getParameter(1));
        //curveVertex(x.get(0)*par3+centerX, y.get(1)*par3+centerY);
    }

    curveVertex(x.get(1)*getParameter(1), y.get(1)*getParameter(1)); //end controlpoint

    endShape();

  }

  private void changeShape()
  {

    if(targetResolution==formResolution)
    {
      morphing=false;
    }

    else if((targetResolution-formResolution)>0)
    {
      formResolution++;
      morphing=true;

      float angle = (float) FastMath.toRadians(360/float(formResolution));

      for (int i=0; i<formResolution; i++)
      {
        x.add(i, (float)(FastMath.cos(angle*i) * initRadius));
        y.add(i, (float)(FastMath.sin(angle*i) * initRadius));
       }
    }

    else if((targetResolution-formResolution)<0)
    {
      formResolution--;
      morphing=true;

      float angle = radians(360/float(formResolution));
      for (int i=0; i<formResolution; i++)
      {
        x.add(i, (float) (FastMath.cos(angle*i) * initRadius));
        y.add(i, (float) (FastMath.sin(angle*i) * initRadius));
      }
    }
  }

  private Vector2d chooseSpeedFromAudio()
  {
    float x=0;
    float y=0;
    float damping = 1; //to slow down speed
    float signMultiplier;
    Vector2d currentSpeed;
    Vector2d speedChange;

    currentSpeed = new Vector2d(x, y, false);
    currentSpeed = this.getSpeed();

    // Speed direction depends on Spectral Complexity in relation to its average
    if(audio_decisor.getInstantFeatures()[3]<audio_decisor.getFeaturesVector()[3])
      {signMultiplier = 1;}
    else
      {signMultiplier = -1;}

    if(audio_decisor.getStatusVector()[4]==0 || audio_decisor.getStatusVector()[4]==-1)
    {
      if(audio_decisor.getFeaturesVector()[4]<3 || audio_decisor.getFeaturesVector()[0]<0.01 ) x=1; //basic shape when silence or very smooth sound
      else if(audio_decisor.getFeaturesVector()[4]<9) x=2; //basic shape for smooth sounds
      else x=3;
      y = -x/4;
      damping = 1.01;
    }
    else if(audio_decisor.getStatusVector()[4]==1)
    {
      x = -5;
      y = -x/2;
      damping = 1.001;
    }
    else if (audio_decisor.getStatusVector()[4]==3)
    {
      x = audio_decisor.getInstantFeatures()[10]*audio_decisor.getInstantFeatures()[3]*audio_decisor.getFeaturesVector()[4]*4;
      y = audio_decisor.getStatusVector()[3]/audio_decisor.getFeaturesVector()[9]*x/3;

      //Math.signum(currentSpeed.getX()) is to avoid inverting the direction of movement in case setWarpAtBorders(false) and setBounce = true
      //x = x * (float)Math.signum(currentSpeed.getX());
      //y = y * (float)Math.signum(currentSpeed.getY());
      damping = 1;

    }
    speedChange = new Vector2d(signMultiplier*x/1000, y/1000, false);

    if (currentSpeed.getModulus() > 10)
      {damping = 1.08;}

    currentSpeed = currentSpeed.quot(damping);

    return currentSpeed.sum(speedChange);
  }

  private void changeStrokeWeight()
  {

    if((oldWeight-targetWeight)*(weight-targetWeight)<0) //zero crossing -> target reached!
    {
      startingWeight=weight;
      oldWeight=weight;
      targetWeight=random(weightSeed-vibrationRange/2,weightSeed+vibrationRange/2);
    }

    else if((weight-targetWeight)<0)
    {
      oldWeight=weight;
      weight+=(vibrationFreq);

    }

    else if((weight-targetWeight)>0)
    {
      oldWeight=weight;
      weight-=(vibrationFreq);
    }

  }


  public void setFormResolution(int res)
  {
    if(!morphing)targetResolution=res; //if not morphing, assign new target
  }

  public void setElasticityCoeff(float coeff)
  {
    elasticityCoeff=coeff;
  }

 public void setVibrationFreq(float f)
 {
   vibrationFreq=f;
 }

 public void setThickness(float t)
 {
   weightSeed=t;
 }

 public void setVibrationRange(float r)
 {
   vibrationRange=r;
 }

 public void setRotationCoeff(float rot)
 {
   rotationCoeff=rot;
 }



}
