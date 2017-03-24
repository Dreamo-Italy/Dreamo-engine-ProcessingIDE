class simpleLShape extends Particle
{
  
// ------ initial parameters and declarations ------

  final private int pointMax = 180;
  final private int defaultRadius = 150;
  private int pointCount = pointMax;
  Vector2d[] lissajousPoints = new Vector2d[0];
  
  private float offset = 0; 
  private float radius = 150;
  
  private float lineWeight = 11;
  private float lineAlpha = 100;
  private float lineAlphaWeight = 1;
  
  private float connectionRadius = 110;
  private int i1 = 0;
  private float saturation;
  private float brightness;
  
  private int pointCountEnd;  
  
  private color myColor;
  private float hue;
    
  public void init()
  {
    pointCountEnd = pointMax/2;
    
    setPersistence(true);
     
    setColorIndex((int)random(0,5));
    myColor = pal.getColor(getColorIndex());     
    hue = hue(myColor);
    saturation = saturation(myColor);
    brightness = brightness(myColor);
   
    calculateLissajousPoints();  

   }
  
  public void update()
  {
    //update color if palette is changed
    myColor = pal.getColor(getColorIndex());     
    hue = hue(myColor);
    
    if (pointCountEnd < pointMax && frameCount % 1 == 0)
      pointCountEnd = pointCountEnd + 1;
    
    calculateLissajousPoints();
    
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
    for (int i=0; i<=pointCountEnd-1; i++) {
          color colore = pal.getColor( (floor(i/64)%(pal.COLOR_NUM) ) );
          drawLine(lissajousPoints[i], lissajousPoints[i+1], colore);
          i1++;
        }
    
  }//Trace() END
  
  void calculateLissajousPoints() 
  {
    radius = defaultRadius*(getParameter(0)+1);
    offset = getParameter(1)*radius;
    
    if (pointCount != lissajousPoints.length-1) 
    {
      lissajousPoints = new Vector2d[pointCount+1];
    }

    randomSeed( (frameCount%15)/5 );
  
    for (int i=0; i<=pointCountEnd; i++) 
    {
      float angle = map(i, 0, pointCountEnd, 0, TWO_PI);
      
      float rx = random(-offset,offset);
      float ry = random(-offset,offset);
      
      Vector2d pointPosition = new Vector2d(radius, angle, true); 
      pointPosition = pointPosition.sum( new Vector2d(width/2, height/2,false) );   // translate point to the center of the screen  
      pointPosition = pointPosition.sum( new Vector2d(rx,ry,false) ); // add offset
      
      lissajousPoints[i] = pointPosition;      
     }
 }
 
 public void connectParticles(int connectionRadius, int particleRadius)
  {    
    for(i1=0; i1<pointCount; i1++){
      
    int start_index = (i1 - particleRadius/2) > 0 ?  (i1 - particleRadius/2) : 0;
    int end_index = (i1 + particleRadius/2) < pointCount ? (i1 + particleRadius/2) : pointCount ;
    
    for (int i2 = start_index; i2 < end_index; i2++) {       
          Vector2d p1 = lissajousPoints[i1];
          Vector2d p2 = lissajousPoints[i2];
          drawLine(p1,p2);                 
        }            
     }        
  }
 
  public void drawLine(Vector2d p1, Vector2d p2, color colore)
  {
    float d, a;
    d = p1.distance(p2);
    a = pow(1/(d/connectionRadius+1), 8);
    
    if (d <= connectionRadius && d > 2) 
    {
      hue = map(a, 0, 0.5, hue(colore), hue(colore)*1.5 )%360 ;
      stroke(hue, saturation(colore), brightness(colore), a*lineAlphaWeight*lineAlpha*random(0.95,1.05));
      line(p1.getX(), p1.getY(), p2.getX(), p2.getY() );  
    }
  }
  public void drawLine(Vector2d p1, Vector2d p2)
  {
    float d, a;
    d = p1.distance(p2);
    a = pow(1/(d/connectionRadius+1), 6);
    
    if (d <= connectionRadius && d > 2) 
    {
      hue = map(a, 0, 0.5, hue(myColor), hue(myColor)*1.5 )%360 ;
      stroke(hue, saturation, brightness, a*lineAlphaWeight*lineAlpha);
      line(p1.getX(), p1.getY(), p2.getX(), p2.getY() );  
    }
  }
  
  

}