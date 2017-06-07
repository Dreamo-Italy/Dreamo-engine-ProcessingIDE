class CrazyLines extends Particle
{

  // init form
  float centerX = width/2;
  float centerY = height/2;
  int formResolution;
  float initRadius = 100;
  float[] x;
  float[] y;
  float par1;
  float par2;
  float par3;
  color myColor;
  float count = 0;
  //changing mode means changing update rules --> graphic behaviour
  int MODE=0;
  //float strokeW;
  
  //STROKE WEIGTH CONTROL
  
  float vibrationFreq=2;
  float vibrationRange=2;
  float startingWeight;
  float targetWeight;
  float weight; 
  float weightSeed;

  int colorIDX;

  public CrazyLines()
  {
    formResolution = 5;
    x = new float[formResolution];
    y = new float[formResolution];
  }
  
  public CrazyLines(int res)
  {
    formResolution=res;   
    x = new float[formResolution];
    y = new float[formResolution];
  }
  
  public void init()
  {

    setColorIndex((int)random(0,5));
   
    
    float angle = radians(360/float(formResolution));
    
    for (int i=0; i<formResolution; i++)
    {
      x[i] = cos(angle*i) * initRadius;
      y[i] = sin(angle*i) * initRadius;
    }
    
    
    startingWeight=random(30);//dipenderò dal range di vibrazione
    //targetWeight=random(30);
    targetWeight=startingWeight+vibrationRange;
    //vibrationRange=startingWeight-targetWeight;
    
    weight=startingWeight;
   
   
  }

  public void update()
  {  
    
    myColor = pal.getColor(getColorIndex());
    //color gradient = pal.getColor();
    
    //println(saturation(pal.getColor(getColorIndex())));
    pal.influenceColors(0,mapForSaturation(audioFeatures[3],audio_decisor.getComplexityStatusLowerBound(),audio_decisor.getComplexityStatusUpperBound()),mapForBrightness(audioFeatures[2],audio_decisor.getCentroidStatusLowerBound(),audio_decisor.getCentroidStatusUpperBound()));
    
    //par1=audioFeatures[0];
    par1=instantFeatures[0];
    par2=instantFeatures[0];
    par3=audioFeatures[2];
    //par1=0.5;
    par3=1;
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

  }

  public void trace()
  {
    
    //strokeWeight(random(4)); //QUESTO PARAMETRO CONTROLLA LO SPESSORE DELLE LINEE! UTILE!        
    stroke(myColor);
    
    if(abs(vibrationRange) >= abs(weight-targetWeight))
    {
       weight+=(vibrationFreq);       
    }
        
    else 
    {
      startingWeight=random(30); //dipender dal range di vibrazione
      targetWeight=startingWeight+vibrationRange;
      //targetWeight=random(30);
      //vibrationRange=startingWeight-targetWeight;
      weight=startingWeight;
    }
    
    strokeWeight(weight); //<>//
    
   
    
    float angle = radians(360/float(formResolution));

    noFill();
    beginShape();
    //noStroke(); 
    scale(.5 + par1*0.4); //PARAMETRO UTILE CHE REGOLA LA SCALATURA DELLA FORMA
    //translate(width/2, height/2);
 
    //start controlpoint
    curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);
    //curveVertex(random(50), random(50));
    //only these points are drawn
    //formResolution = 2 + int(para*5);
    
    
    
    
    for (int i=0; i<formResolution; i++)
    {
        //curveVertex(x[i]+centerX, y[i]+centerY);
        x[i] = cos(angle*i) * width/6;// + random(10);
        y[i] = sin(angle*i) * width/6;// + random(10);
        //curveVertex(x[i]+centerX, y[i]+centerY);
        
        //color gradient = lerpColor(this.pal.getDarkest(), this.pal.getLightest(), map(i/par2,0,3,0,1));
      
        count = count + par1*2;
        //rotate(count*.5);
        curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);
        curveVertex(x[i]+centerX, y[i]+centerY);
        curveVertex(x[0]+centerX, y[1]+centerY);
    }

    //end controlpoint
    curveVertex(x[1]+centerX, y[1]+centerY);
    endShape();
  }

}