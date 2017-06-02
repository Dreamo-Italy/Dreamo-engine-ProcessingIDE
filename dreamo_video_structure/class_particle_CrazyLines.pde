class CrazyLines extends Particle
{

  // init form
  float centerX = width/2;
  float centerY = height/2;
  int formResolution = 3;
  float initRadius = 100;
  float[] x = new float[formResolution];
  float[] y = new float[formResolution];
  float par1;
  float par2;
  float par3;
  color colore;
  float count = 0;


  public void init()
  {
    float angle = radians(360/float(formResolution));
    
    for (int i=0; i<formResolution; i++){
    x[i] = cos(angle*i) * initRadius;
    y[i] = sin(angle*i) * initRadius;
    }
    
    //colore=pal.getColor();
   }

  public void update(){
      
      par1=audio_decisor.getFeturesVector()[0];
      par2=audio_decisor.getFeturesVector()[0];
      par3=audio_decisor.getFeturesVector()[0];
      //par3=getParameter(0);
 
      initRadius = 350;
      initRadius = 200*par1;
      centerX = 300 + random(100);
      //formResolution++;
      //color gradient = lerpColor(this.pal.getDarkest(), this.pal.getLightest(), i/count);
      //fill(gradient, i/count*200);
      //fill(gradient);
      //rotate(PI/10);
       if(par1*2 > 1) {
    //formResolution = 4;
  } else if(par1*2 > .5) {
    //formResolution = 3;
  } else {
    //formResolution = 2;
  }
      print("DUMB PARAM: " + par1);

  }

  public void trace()
  {
    
    strokeWeight(random(40));
    float angle = radians(360/float(formResolution));
    
    
    noFill();

    
    beginShape();
    //noStroke();
    //translate(width/2, height/2);
    scale(.3 + par2/2);
 
    // start controlpoint
    curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);
     curveVertex(random(50), random(50));
    // only these points are drawn
      //formResolution = 2 + int(par1*5);
    for (int i=0; i<formResolution; i++){
      //curveVertex(x[i]+centerX, y[i]+centerY);
      x[i] = cos(angle*i) * width + random(100);
      y[i] = sin(angle*i) * width + random(100);
    //curveVertex(x[i]+centerX, y[i]+centerY);
    color gradient = lerpColor(this.pal.getDarkest(), this.pal.getLightest(), i/par2);
      stroke(gradient);
      count = count + par3*2;
      rotate(count*.5);
    //curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);
    curveVertex(x[i]+centerX, y[i]+centerY);
    //curveVertex(x[0]+centerX, y[1]+centerY);
    }

    // end controlpoint
   // curveVertex(x[1]+centerX, y[1]+centerY);
    endShape();
  }

}