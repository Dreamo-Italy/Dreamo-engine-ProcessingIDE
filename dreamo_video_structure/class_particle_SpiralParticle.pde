class SpiralParticle extends Particle
{
  int count = 50;
  float alpha = 50;
  float [] alphaArray = new float[count];
  color colore;
  float tileWidth = width;
  float tileHeight = height;
    
  public void init()
  {
    setPersistence(true);
    
    for(int i=0; i< count; i++) 
    {
      alphaArray[i] = (float)i/count;
    }
    
  }

  public void update()
  {    
    if(getSceneChanged()&&!isDestroying())
    {
      assertDestroying();
      setLifeTimeLeft(9000);
    }
    
     if(isDestroying())
    {
      for(int i=0; i< count; i++) 
        {
          if(alphaArray[i]>0)
            alphaArray[i] -= 0.025;
        }
    }
    
  }
  
  public void trace()
  {
    
   rectMode(CENTER);
   translate(width/2, height/2);
   
   for(int i=0; i< count; i++) 
   {
      noStroke();
      color gradient = lerpColor(this.pal.getDarkest(), this.pal.getLightest(), alphaArray[i] );
      fill(gradient, alphaArray[i]*200);
      //fill(gradient);
      rotate(PI/4);     
      rect(0, 0, tileWidth, tileHeight);
      scale(1 - 3.0/count);
      rotate(getParameter(0)*1.5);
   }
   
   
  }
  
}