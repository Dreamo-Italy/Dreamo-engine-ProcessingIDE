class HShape extends Particle
{
  
  color colore;
  
  int nSides=0;
  float radius = 0;
  float angle = 0;
  float lineWeightDefault;
  float lineWeight = lineWeightDefault = 5;
  
  int NSIDES=0;
  float RAD=0;
  //float ANG=0;
  
  //changing mode means cheangind update rules --> graphic behaviour
  final int MODE;
  
  int I=0;
  int alpha;
  
  HShape(int m, int intensity)
  {  
    MODE=m;
    I=intensity;
  }
  
  HShape(int ns, float r, float a, int m)
  {
    nSides=ns;
    radius=r;
    angle=a;
    MODE=m;
  }
  
  
  public void init()
  {
    setColorIndex((int)random(0,5));
    colore=this.pal.getColor(getColorIndex());
    
    if(MODE>=0 && MODE<=6){
    switch(MODE) {
      case 0:
        nSides=(int)random(4,5);
        radius=random(110,120);
        break;
      case 1:
        nSides=(int)random(3,4);
        radius=random(90,140);
        break;
      case 2:
        nSides=5;
        radius=random(110,160);
        break;
      case 3:
        nSides=3;
        radius=random(150,200);
        break;
      case 4:
        nSides=(int)random(3,6);
        radius=random(200,250);
        break; 
      case 5:
        nSides=5;
        radius=random(250,300);
        break; 
      case 6:
        nSides=(int)random(4,7);
        radius=random(320,370);
        break; 
    }
   }
   else{
     nSides=3;
     radius=random(650,760);     
   }
   
   NSIDES=nSides;
   RAD=radius;   
   setMaxAlpha((int)random(20));
  }
  
  public void update()
  {
    noiseSeed(0);
    
    lineWeight = lineWeightDefault + global_timbre.getCentroid()*15;
    setMaxAlpha(50*(int)global_timbre.getComplexity()+15);
    alpha = getFadingAlpha();
    
    if(MODE>=0 && MODE<=6){
    switch(MODE) {
      case 0:
        nSides=NSIDES+(int)(I*getParameter(0));
        radius=RAD+I*getParameter(0);
        break;
      case 1:
        radius=RAD-I*getParameter(0);
        break;
      case 2:
        radius=RAD-I*getParameter(0);
        angle=0.9;
        break;
      case 3:
        radius=RAD+I*getParameter(0);
        angle=1.4;
        break;
      case 4:
        radius=RAD-I*getParameter(0);
        break;
      case 5:
        //nSides=NSIDES+(int)(I/2*getParameter(0));
        radius=RAD+I*getParameter(0);
        break;
      case 6:      
        radius=RAD-I*getParameter(0);
        break;
    }
   }
   else{
     
   }
     
      //alpha=(int)(255*getParameter(0))+(int)(30*getParameter(0));
     
  }
  
  public void trace()
  {  
    colore = this.pal.getColor(getColorIndex());
    translate(width/2,height/2);
    noFill();
    //int circleResolution = (int)map(mouseY+100,0,height,2, 10);
    //float radius = mouseX-width/2 + 0.5;
    float angle = TWO_PI/nSides;
    
    strokeWeight(lineWeight);
    stroke(colore,alpha);
    
    beginShape();
    
    for (int i=0; i<=nSides; i++)
    {
      float x = 0 + cos(angle*i) * radius;
      float y = 0 + sin(angle*i) * radius;
      vertex(x, y);
    }
    endShape();  
  }  
}