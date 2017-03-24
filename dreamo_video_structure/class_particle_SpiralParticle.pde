class SpiralParticle extends Particle
{
  int count = 50;
  color colore;
  float tileWidth = width;
  float tileHeight = height;
    
  public void init(){}

  public void update(){}
  
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
      rotate(getParameter(0)*1.5);
   }
   
  }
  
}