class SpiralParticle extends Particle
{
  
  
  int count = 50;
  float alpha = 50;
  float [] alphaArray = new float[count];
  final float [] alphaArrayOriginal  = new float[count];
  color colore;
  float tileWidth = width;
  float tileHeight = height;
  
  final float ALPHA_INCREMENT = 0.00125;
  final float ALPHA_DECREMENT = 0.025; 
  
  float centroidParam;  
    
  public void init()
  {
    setPersistence(true);
    
    for(int i=0; i< count; i++) 
    {
      alphaArrayOriginal[i] = (float)i/count;
      alphaArray[i] = 0;
    }
    
  }

  public void update()
  {    
    
    centroidParam=map(audio_decisor.getFeaturesVector()[2],0,6000,0,1);
    setParameter(1,centroidParam);
    setParameter(0,audio_decisor.getInstantFeatures()[0]);
    
    
    
    //FADE OUT/FADE IN
    for(int i=0; i< count; i++) 
    {
      if(alphaArray[i]<alphaArrayOriginal[i] )
        alphaArray[i] += ALPHA_INCREMENT;
    }
        
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
            alphaArray[i] -= ALPHA_DECREMENT;
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
      rect(0, 0, (tileWidth*getParameter(1))/0.5, tileHeight/getParameter(1));
      scale(1 - 3.0/count);
      rotate(getParameter(0));
   }
   
   
  }
  
}