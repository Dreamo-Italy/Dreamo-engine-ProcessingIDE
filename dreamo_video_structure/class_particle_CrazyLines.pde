import java.util.List;
import java.util.ArrayList;

class CrazyLines extends Particle
{

  // init form
  float centerX = 0;
  float centerY = 0;
  
  int formResolution;
  int targetResolution;
  boolean morphing=false;
  
  float initRadius = 50;
  
  //POINT ARRAYS
  List<Float> x = new ArrayList<Float>();
  List<Float> y = new ArrayList<Float>();
  
  //CONTROL PARAMETERS
  float par1;
  float par2;
  float par3;
  color myColor;
  
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
 


  int colorIDX;

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


  //PARAMTERI DA CONTROLLARE:
  //strokeWeigth
  //scale
  //rotate
  //curveVertex position
  
  //l'effetto che ottengo ora quanto RMS è a zero lo voglia quanto centroide e complexity sono alte!
  //quando l'rms è basso e/o non cè ritmo voglio forme larghe e una leggera rotazione. pulsazione quasi nulla 
  //quando la denistà di ritmo è alta voglio una vibrazione rapida dello spessore delle linee

  public void update()
  {  
    //**** COLORS
    myColor = pal.getColor(getColorIndex());        
    pal.influenceColors(0,mapForSaturation(audioFeatures[3],0,40),mapForBrightness(audioFeatures[2],0,6000)); //DIRECT INFLUENCE
    
    //**** SHAPE DISTORTION
    par1=instantFeatures[0];
    par2=pow(5,audioFeatures[2]/2500);
    par3=audioFeatures[0];
    
    //randomize

    //**** SHAPE RESOLUTION
    changeShape();
    
  }

  public void trace()
  {
    noFill(); 
    
    //**** STROKE WEIGHT VIBRATION ****
    stroke(myColor);
    
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
            
    strokeWeight(weight); //<>//

   
    //**** SCALE PULSATION ****
    scale(0.5+instantFeatures[0]*elasticityCoeff); //DIRECT INFLUENCE
    
    
    //**** SHAPE DISTORTION ****
    float angle = radians(360/float(formResolution));
   
    beginShape();
 
    //start controlpoint
    
    //IDEA: QUANDO C'E' UN CAMBIO DI STATUS IMPORTANTE CAMBIA RANDOMICAMENTE L'ASSEGNAZIONE DEI PARAMETRI AI VERTICI
    //in questo modo cambiano le forme ma il comportamento rimane coerente alle feaatures
    //meccanismo simile al cambio di palette
    
    curveVertex(x.get(formResolution-1)*par2+centerX, y.get(formResolution-1)*par2+centerY);
    //curveVertex(x.get(formResolution-1)+centerX, y.get(formResolution-1)+centerY);
    //curveVertex(random(50), random(50));
    
    //formResolution = 2 + int(para*5);
    
    //only these points are drawn   
    for (int i=0; i<formResolution; i++)
    {
        //curveVertex(x[i]+centerX, y[i]+centerY);
        x.add(i, (cos(angle*i) * width/10));// + random(10);
        y.add(i, ( sin(angle*i) * width/10));// + random(10);
        //curveVertex(x[i]+centerX, y[i]+centerY);
        
        //color gradient = lerpColor(this.pal.getDarkest(), this.pal.getLightest(), map(i/par2,0,3,0,1));
      
        count = count + audioFeatures[0]*rotationCoeff; //DIRECT INFLUENCE
        rotate(count);
        
        curveVertex(x.get(formResolution-1)*par3+centerX, y.get(formResolution-1)*par3+centerY);
        curveVertex(x.get(i)*par2+centerX, y.get(i)*par2+centerY);
        //curveVertex(x.get(0)*par3+centerX, y.get(1)*par3+centerY);
    }

    //end controlpoint
    curveVertex(x.get(1)*par2+centerX, y.get(1)*par2+centerY);
    endShape();    
    
    
  }
  
  
  
  public void changeShape()
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
  
  
  /*
  private void calcVibrationParameters()
  {
    if(vibrationCoeff<=1)
    {
      vibrationFreq=vibrationCoeff*2;
      //weightSeed=map(1/vibrationCoeff,0.2,2.5,2,50);
      //vibrationRange=weightSeed;
    }
    else if(vibrationCoeff>1)
    {
     vibrationFreq=vibrationCoeff;
     //weightSeed=map(1/vibrationCoeff,0.2,2.5,2,50);
     //vibrationRange=weightSeed/1.5;
     println(weightSeed);   
    }
    
  }*/
  
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