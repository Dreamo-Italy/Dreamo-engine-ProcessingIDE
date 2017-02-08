class SpiralParticle extends Particle
{
  int count = 50;
  color colore;
  float tileWidth = width;
  float tileHeight = height;
  float para;
  
    
  public void init()
  {
    //colore=this.pal.getColor();
    //para=0.1;
  }
  
  public void update()
  {
    
    //smooth();
    //stroke(0);
    //noFill();
  
    //count = mouseX/10 + 10;
    //count=4;
    //para = (float)mouseY/height;
    para=getParameter(0);
    //println("SPIRAL PARAM:" + para);
    //println(para);
    //colore=pal.getColor();
  
  }
  public void trace()
  {
   rectMode(CENTER);
   translate(width/2, height/2);
   
   for(float i=0; i< count; i++) 
    {
      noStroke();
      color gradient = lerpColor(this.pal.getDarkest(), this.pal.getLightest(), i/count);
      fill(gradient, i/count*200);
      //fill(gradient);
      rotate(PI/4);     
      rect(0, 0, tileWidth, tileHeight);
      scale(1 - 3.0/count);
      rotate(para*1.5);
   }
  }
  
}