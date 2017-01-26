class HShape extends Particle
{
  
  color colore;
  
  int nSides=0;
  float radius=0;
  float angle=0;
  
  //changing mode means cheangind update rules --> graphic behaviour
  int MODE;
  
  HShape(int m)
  {  
    MODE=m;
  }
  
  HShape(int ns, float r, float a)
  {
    nSides=ns;
    radius=r;
    angle=a;
  }
  
  
  public void init()
  {
    colore=this.pal.getColor();
    
    if(MODE>0 && MODE<5){
    switch(MODE) {
      case 1:
        nSides=3;
        radius=400;
        angle=0.5;
        break;
      case 2:
        nSides=4;
        radius=180;
        angle=-0.5;
        break;
      case 3:
        nSides=5;
        radius=100;
        angle=0.9;
        break;
      case 4:
        nSides=6;
        radius=305;
        angle=1.4;
        break; 
    }
   }
   else{
     
   }
  }
  
  public void update()
  {
  }
  
  public void trace()
  {
    noFill();
    //int circleResolution = (int)map(mouseY+100,0,height,2, 10);
    //float radius = mouseX-width/2 + 0.5;
    float angle = TWO_PI/nSides;
    strokeWeight(2);
    stroke(colore);
    
    beginShape();
    
    for (int i=0; i<=nSides; i++){
      float x = 0 + cos(angle*i) * radius;
      float y = 0 + sin(angle*i) * radius;
      vertex(x, y);
    }
    endShape();
  }
  
}