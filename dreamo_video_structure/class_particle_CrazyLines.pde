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
  
  float initRadius = 100;
  //float[] x;
  List<Float> x = new ArrayList<Float>();
  //float[] y;
  List<Float> y = new ArrayList<Float>();
  float par1;
  float par2;
  float par3;
  color myColor;
  float count = 0;
  //changing mode means changing update rules --> graphic behaviour
  int MODE=0;
  //float strokeW;
  
  //STROKE WEIGTH CONTROL 
  float vibrationFreq=1;
  float vibrationRange=10;
  float weightSeed=20;
  
  //stroke weigth vibration controls
  float startingWeight;
  float targetWeight;
  float weight; 
  float oldWeight;
 
 
 float distortionCoeff;
 float elasticityCoeff=1;
 float rotationCoeff=0;

  int colorIDX;

  public CrazyLines()
  {
    formResolution = 5; //DEFAULT RESOLUTION
    targetResolution=formResolution;
    //x = new float[formResolution];
    //y = new float[formResolution];
  }
  
  public CrazyLines(int res)
  {
    formResolution=res;   
    targetResolution=formResolution;
    //x = new float[formResolution];
    //y = new float[formResolution];
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
    
    myColor = pal.getColor(getColorIndex());
    //color gradient = pal.getColor();
    
    //println(saturation(pal.getColor(getColorIndex())));
    pal.influenceColors(0,mapForSaturation(audioFeatures[3],audio_decisor.getComplexityStatusLowerBound(),audio_decisor.getComplexityStatusUpperBound()),mapForBrightness(audioFeatures[2],audio_decisor.getCentroidStatusLowerBound(),audio_decisor.getCentroidStatusUpperBound()));
    
    //par1=audioFeatures[0];
    par1=instantFeatures[0];
    par2=instantFeatures[0];
    par3=audioFeatures[0];
    //par1=0.5;
 
    initRadius = 50;
    //initRadius = 200*par1;
    //centerY = width;// + random(20);
    //formResolution++;
    //color gradient = lerpColor(this.pal.getDarkest(), this.pal.getLightest(), i/count);
    //fill(gradient, i/count*200);
    //fill(gradient);
    //rotate(PI/10);
    if(par1*2 > 1) 
    {
      //formResolution = 4;
    } 
    else if(par1*2 > .5) 
    {
      //formResolution = 3;
    } 
    else 
    {
      //formResolution = 2;
    }
    
    //print("DUMB PARAM: " + par1);
    
    changeShape();
    
    //weightSeed=map(1/audioFeatures[0],1,100,1,50);
    //println(map(1/audioFeatures[0],1,100,1,50));
  }

  public void trace()
  {
    
    //strokeWeight(random(4)); //QUESTO PARAMETRO CONTROLLA LO SPESSORE DELLE LINEE! UTILE!        
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

   
    float angle = radians(360/float(formResolution));

    noFill();
    //scale(1 + audio_decisor.getElasticityIndicator()*par1*0.5); //PARAMETRO UTILE CHE REGOLA LA SCALATURA DELLA FORMA
    
    scale(0.5+par1*elasticityCoeff); //influnzare il parametro che moltiplica l'RMS in base all'indice di elasticità
    
    beginShape();
    //noStroke(); 

 
    //start controlpoint
    curveVertex(x.get(formResolution-1)/par3+centerX, y.get(formResolution-1)/par3+centerY);
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
      
        count = count + par1*rotationCoeff;
        rotate(count);
        curveVertex(x.get(formResolution-1)*par3+centerX, y.get(formResolution-1)*par3+centerY);
        curveVertex(x.get(i)/par3+centerX, y.get(i)/par3+centerY);
        curveVertex(x.get(0)*par3+centerX, y.get(1)*par3+centerY);
    }

    //end controlpoint
    curveVertex(x.get(1)/par3+centerX, y.get(1)/par3+centerY);
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
  
  public void setFormResolution(int res)
  {    
    if(!morphing)targetResolution=res; //if not morphing, assign new target   
  }
  
  public void setElasticityCoeff(float coeff)
  {
    elasticityCoeff=coeff;
  }
  
 public void setVibrationFreq(float freq)
 {
   vibrationFreq=freq;
 }

}