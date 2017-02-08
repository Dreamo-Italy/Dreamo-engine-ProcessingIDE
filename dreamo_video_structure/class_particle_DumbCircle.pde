class DumbCircle extends Particle
{
  
  // init form
  float centerX = width/2; 
  float centerY = height/2;
  int formResolution = 3;
  float initRadius = 250;
  float[] x = new float[formResolution];
  float[] y = new float[formResolution];
  
  public void init()
  {
    float angle = radians(360/float(formResolution));
    for (int i=0; i<formResolution; i++){
    x[i] = cos(angle*i) * initRadius;
    y[i] = sin(angle*i) * initRadius;  
    }
   }
  
  public void update(){}
  
  public void trace()
  {
      strokeWeight(0.75);

   noFill();

 
    beginShape();
    // start controlpoint
    curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);

    // only these points are drawn
    for (int i=0; i<formResolution; i++){
      curveVertex(x[i]+centerX, y[i]+centerY);
    }
    curveVertex(x[0]+centerX, y[0]+centerY);

    // end controlpoint
    curveVertex(x[1]+centerX, y[1]+centerY);
    endShape();
  }

}