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
  float rotationCoeff=0.001;
  
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
    
   float angle = radians(360/float(formResolution));
    
   for (int i=0; i<formResolution; i++)
   {
     x.add(i, (cos(angle*i) * initRadius));
     y.add(i, (sin(angle*i) * initRadius));
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
    setParameter(1,pow(5,audio_decisor.getFeaturesVector()[2]/2500));
    setParameter(2,audio_decisor.getFeaturesVector()[0]);    
    setParameter(3,audio_decisor.getFeaturesVector()[3]); 
    setParameter(4,audio_decisor.getFeaturesVector()[2]);
    
      
    
    //**** DIRECT INFLUENCE of TIMBRE on colors SATURATION AND BRIGHTNESS
    pal.influenceColors(0,mapForSaturation(getParameter(3),0,40),mapForBrightness(getParameter(4),0,6000));
    
    //**** SHAPE RESOLUTION
    changeShape();
    
    //**** STROKE WEIGHT
    changeStrokeWeight();
    
  }

  public void trace()
  {
    noFill(); 
    
    //**** STROKE WEIGHT VIBRATION ****
    stroke(myColor);
            
    strokeWeight(weight); //<>//
   
    //**** SCALE PULSATION ****
    scale(0.5+getParameter(0)*elasticityCoeff); //DIRECT INFLUENCE of RMS (instantaneous value) on SCALE
        
    //**** SHAPE GENERATION ****
    float angle = radians(360/float(formResolution));
    
    beginShape();
    
    curveVertex(x.get(formResolution-1)*getParameter(1), y.get(formResolution-1)*getParameter(1)); //start controlpoint
    //curveVertex(x.get(formResolution-1)+centerX, y.get(formResolution-1)+centerY);
    //curveVertex(random(50), random(50));    
    
    //only these points are drawn   
    for (int i=0; i<formResolution; i++)
    {
        
        x.add(i, (cos(angle*i) * width/10));
        y.add(i, ( sin(angle*i) * width/10));
                     
        count = count + getParameter(2)*rotationCoeff; //DIRECT INFLUENCE of RMS (average) on ROTATION
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
      
      float angle = radians(360/float(formResolution));
     
      for (int i=0; i<formResolution; i++)
      { 
        x.add(i, (cos(angle*i) * initRadius));
        y.add(i, (sin(angle*i) * initRadius));
       }      
    }
    
    else if((targetResolution-formResolution)<0)
    {
      formResolution--;
      morphing=true;
      
      float angle = radians(360/float(formResolution));    
      for (int i=0; i<formResolution; i++)
      { 
        x.add(i, (cos(angle*i) * initRadius));
        y.add(i, (sin(angle*i) * initRadius));
       }  
    }    
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