class LShape extends Particle
{

// ------ initial parameters and declarations ------

  final int pointMax = 2000;
  int pointCount = pointMax;
  Vector2d[] lissajousPoints = new Vector2d[0];

  float freqX = 3;
  float freqY = 4;
  float phi = 0;

  float modFreqX = 1;
  float modFreqY = 0;

  float modFreq2X = 1.5;
  float modFreq2Y = 0;
  float modFreq2Strength = 0;

  // float randomOffset = 80; //600 default

  boolean invertBackground = false;
  float lineWeight = 11;
  float lineAlpha = 100;
  float lineAlphaWeight = 1;

  boolean connectAllPoints = false;
  float connectionRadius = 110;
  int particleRadius = 500;
  int i1 = 0;
  float saturation;
  float brightness;
  boolean invertHue = false;

  int pointCountEnd;
  boolean raisingModFreq, raisingFreqX, raisingFreqY ;

  private float[] randomOffsets;


  color myColor;
  float hue;

  public void init()
  {
    pointCountEnd = pointMax/2;
    randomOffsets = new float[pointMax+1];
    for (int j=0; j<=pointMax; j++) {
      randomOffsets[j] = 30;
    }

    freqX = round ( random ( 1,1 ) ); //(1,3)
    freqY = round ( random ( 1,1 ) );

    setPersistence(true);

    setColorIndex((int)random(0,5));
    myColor = pal.getColor(getColorIndex());
    hue = hue(myColor);
    saturation = saturation(myColor);
    brightness = brightness(myColor);

    calculateLissajousPoints();


   }
 //<>// //<>//
  public void update()
  {
    //update color if palette is changed
    myColor = pal.getColor(getColorIndex());
    hue = hue(myColor); //<>// //<>//
     //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
    if (pointCountEnd < pointMax && frameCount % 1 == 0)
      pointCountEnd = pointCountEnd + 1;

    if ( freqX < 6 && raisingFreqX ){
    freqX = freqX + getParameter(3)/1000; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
    raisingFreqX = true;
  }
    else{
      freqX -= getParameter(3)/100;
      raisingFreqX = false;

      if(freqX<1.3)
        raisingFreqX=true;
    }

    if ( freqY < 6 && raisingFreqY ){
    freqY = freqY + getParameter(0)/800;
    raisingFreqY = true;
  }
    else{
      freqY = gradualShift(freqY, freqY-getParameter(0)/80, 0.5);
      raisingFreqY = false;

      if(freqY < 1.3)
        raisingFreqY=true;
    }



    // if(randomOffset < 200)
      // {
        if ( modFreqY < 2 && raisingModFreq){
         modFreqY = (modFreqY+getParameter(0)/100);
         modFreq2Strength = modFreq2Strength + getParameter(0)/150;
         raisingModFreq = true;
        }
        else{
          modFreqY = (modFreqY-getParameter(0)/100);
          modFreq2Strength = modFreq2Strength - getParameter(0)/150;
          raisingModFreq = false;

          if ( modFreqY < 1.2)
            raisingModFreq = true;
        }
    // }

    // else if (randomOffset < 30)
    // {
    //   phi += getParameter(0)/500;
    //   randomOffset += 0.01*getParameter(1);
    // }
    // else{
    //   randomOffset = randomOffset + 0.01*randomOffset*getParameter(1);
    // }

      //randomOffset *= 1.5*(0.5+getParameter(0));
      //modFreqX = (modFreqX-getParameter(0)/580);


    if (frameCount % 1 == 0) {println("getParameter(1) "+ getParameter(1));}
    // if (frameCount % 30 == 0) {println("getParameter(2) "+ getParameter(2));}
    // if (frameCount % 30 == 0) {println("getParameter(3) "+ getParameter(3));}
    //if (frameCount % 30 == 0) {println("Offset "+ randomOffset);}

    calculateLissajousPoints();

    if(getSceneChanged() && !this.isDestroying() )
    {
      assertDestroying();
      setLifeTimeLeft(60);
    }
    else if( this.isDestroying() )
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


      if (!connectAllPoints) // Default choice
      {
        // if (frameCount % 30 == 0 ) {println("Don't connect all points");}
        for (int i=0; i<=pointCountEnd-1; i++) {
          color colore = pal.getColor( (floor(i/64)%(pal.COLOR_NUM) ) );
          drawLine(lissajousPoints[i], lissajousPoints[i+1], colore);
          // i1++;
        }
     }
      else {
         // if (frameCount % 30 == 0 ) {println("Connect all points");}
         connectParticles(round(connectionRadius), particleRadius);
       }

  }//Trace() END

  void calculateLissajousPoints()
  {
    if (pointCount != lissajousPoints.length-1) {
      lissajousPoints = new Vector2d[pointCount+1];
    }

    randomSeed(0);

    float t, x, y, rx, ry;

    for (int i=0; i<=pointCountEnd; i++) {
      float angle = map(i, 0, pointCountEnd, 0, TWO_PI);

      // an additional modulation of the osscillations
      float fmx = sin(angle*modFreq2X) * modFreq2Strength + 1;
      float fmy = sin(angle*modFreq2Y) * modFreq2Strength + 1;


      // if(randomOffsets[i] > 1 ){
        randomOffsets[i] = gradualShift(randomOffsets[i], 5+((i%6))*getParameter((i%2)+1), 0.5);
        // randomOffset = gradualShift(randomOffset, 10+100*getParameter(2), 0.9);
        // randomOffset = randomOffset - randomOffset*getParameter(2) + randomOffset*getParameter(1);
      // }
      // else{
      //   randomOffsets[i] = gradualShift(randomOffsets[i], randomOffsets[i]+1000*getParameter(1), 0.9);
      // }

      x = sin(angle * freqX * fmx + radians(phi)) * cos(angle * modFreqX);
      y = sin(angle * freqY * fmy) * cos(angle * modFreqY);

      rx = random(-randomOffsets[i], randomOffsets[i]);
      ry = random(-randomOffsets[i], randomOffsets[i]);

      x = (x * (width/2-30-randomOffsets[i]) + width/2) + rx;
      y = (y * (height/2-30-randomOffsets[i]) + height/2) + ry;

      lissajousPoints[i] = new Vector2d(x, y, false);
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
