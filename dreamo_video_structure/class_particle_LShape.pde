class LShape extends Particle
{
  
// ------ initial parameters and declarations ------

  int pointCount = 200;
  Vector2d[] lissajousPoints = new Vector2d[0];
  
  int freqX = 7;
  int freqY = 4;
  float phi = 97;
  
  int modFreqX = 1;
  int modFreqY = 0;
  
  int modFreq2X = 11;
  int modFreq2Y = 17;
  float modFreq2Strength = 0.5;
  
  float randomOffset = 2;
  
  boolean invertBackground = false;
  float lineWeight = 3;
  float lineAlpha = 40;
  float lineAlphaWeight = 1;
  
  boolean connectAllPoints = true;
  float connectionRadius = 110;
  int particleRadius = 500;
  int i1 = 0;
  float saturation = 80;
  float brightness = 0;
  boolean invertHue = false;
  
  
  color myColor;
  float hue;
    
  public void init()
  {
    
    freqX = round ( random ( 10 ) );
    freqY = round ( random ( 10 ) );
    
    setPersistence(true);
     
    myColor = pal.getLightest();          
    hue = hue(myColor);
    saturation = saturation(myColor);
    brightness = brightness(myColor);
   
    calculateLissajousPoints();
    

   }
  
  public void update()
  {
    if ( frameCount % 30 == 0 )
      freqX = round(freqX+getParameter(0));
    if ( frameCount % 1 == 0 ){
    modFreq2Strength = getParameter(0)/2;  
    modFreqY = round(modFreqY+getParameter(0)+0.4); 
    randomOffset = round(randomOffset+getParameter(0));
    }
    
    
    if(getSceneChanged() && !this.isDestroying() )
    {
      assertDestroying();
      setLifeTimeLeft(60);
    }
    
    if( this.isDestroying() )
    {
      lineAlphaWeight -= 1.0/50.0;
    }

  }
  
  public void trace()
  {
    strokeWeight(lineWeight);
    stroke(0, lineAlpha);
    strokeCap(ROUND);
    noFill();
    
    calculateLissajousPoints();
  
      if (!connectAllPoints) 
      {
        for (int i=0; i<=pointCount-1; i++) {
          drawLine(lissajousPoints[i], lissajousPoints[i+1]);
          i1++;
        }
     } 
      else 
         connectParticles(round(connectionRadius), particleRadius);  
    
  }//Trace() END
  
  void calculateLissajousPoints() 
  {
  if (pointCount != lissajousPoints.length-1) {
    lissajousPoints = new Vector2d[pointCount+1];
  }

  randomSeed(0);

  float t, x, y, rx, ry;

  for (int i=0; i<=pointCount; i++) {
    float angle = map(i, 0, pointCount, 0, TWO_PI);

    // an additional modulation of the osscillations
    float fmx = sin(angle*modFreq2X) * modFreq2Strength + 1;
    float fmy = sin(angle*modFreq2Y) * modFreq2Strength + 1;

    x = sin(angle * freqX * fmx + radians(phi)) * cos(angle * modFreqX);
    y = sin(angle * freqY * fmy) * cos(angle * modFreqY);

    rx = random(-randomOffset, randomOffset);
    ry = random(-randomOffset, randomOffset);

    x = (x * (width/2-30-randomOffset) + width/2) + rx;
    y = (y * (height/2-30-randomOffset) + height/2) + ry;

    lissajousPoints[i] = new Vector2d(x, y, false);
   }
 }
 
 public void connectParticles(int connectionRadius, int particleRadius)
  {
    float d, a, h;
    
    for(int i1=0;i1<pointCount;i1++){
      
    int start_index = (i1 - particleRadius/2) > 0 ?  (i1 - particleRadius/2) : 0;
    int end_index = (i1 + particleRadius/2) < pointCount ? (i1 + particleRadius/2) : pointCount ;
    
    for (int i2 = start_index; i2 < end_index; i2++) {
       
          Vector2d p1 = lissajousPoints[i1];
          Vector2d p2 = lissajousPoints[i2];
          drawLine(p1,p2);       
          
        }            
     }        
  }
 
  public void drawLine(Vector2d p1, Vector2d p2)
  {
    float d, a;
    d = p1.distance(p2);
    a = pow(1/(d/connectionRadius+1), 6);
    
    if (d <= connectionRadius && d > 2) 
    {
      hue = map(a, 0, 0.5, hue(myColor), hue(myColor)*3 )%360 ;
      stroke(hue, saturation, brightness, a*lineAlphaWeight*lineAlpha + (i1 %2 * 2));
      line(p1.getX(), p1.getY(), p2.getX(), p2.getY() );  
    }
  }
  
  

}