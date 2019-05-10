class Lissajous2 extends Scene
{
  private Hysteresis centroidControl;

  // Originally inside LShape particle
  final int pointMax = 4000;
  int pointCount = pointMax;
  Vector2d[] lissajousPoints = new Vector2d[pointMax];

  float freqX = 3;
  float freqY = 4;
  
  int MAX_FREQ = 6;
  float MIN_FREQ = 0.3;
  float MIN_PARAM_VAL = 0.05;
  float phi = 0;

  float modFreqX = 1;
  float modFreqY = 0;

  float modFreq2X = 1.5;
  float modFreq2Y = 0;
  float modFreq2Strength = 0;

  boolean connectAllPoints = false;
  float connectionRadius = 110;
  int particleRadius = 500;
  int i1 = 0;

  float lineWeight = 11;
  float lineAlpha = 100;
  float lineAlphaWeight = 1;
  
  float newX, newY;


    int pointCountEnd;
    boolean raisingModFreq, raisingFreqX, raisingFreqY ;

    private float[] randomOffsets;

  // float randomOffset = 80; //600 default

  boolean invertBackground = false;

  public void init()
  {
    // Old init; general properties
    pal.initColors(0);

    // Originally in Lshape particle initial
    pointCountEnd = pointMax/2;
    randomOffsets = new float[pointMax];
    
    for (int j=0; j<pointMax; j++) {
      // randomOffsets[j] =
      LShape2 shape = new LShape2();
      shape.setPalette(pal);
      shape.enablePhysics();
      
      randomOffsets[j] = 30;
      lissajousPoints[j] = new Vector2d(0.0,0.0, false);
      addParticle(shape);
    }

    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    sceneMood.setMood(0,1);

    centroidControl = new Hysteresis(2950,3200,16);

    // Originally in Lshape particle initial
    //freqX = round ( random ( 1,1 ) ); //(1,3)
    //freqY = round ( random ( 1,1 ) );
    freqX = 0;
    freqY = 0;

    calculateLissajousPoints();

    for(int i = 0; i < pointCountEnd; i++)
      {
        particlesList[i].setPosition(lissajousPoints[i]); //<>//
      }
    println("Fine init");
  }

  public void update()
  {

   //example of usage
   //TODO: implement histeresis cycle to change status
   //TODO: implement reliable decision algorithm (na parola)

   colorFadeTo(new Palette(4),7,centroidControl.checkWindow(global_timbre.getCentroidHz()));
   colorFadeTo(new Palette(7),7,!centroidControl.checkWindow(global_timbre.getCentroidHz()));

    // Originally from particle Lshape
    if (pointCountEnd < pointMax && frameCount % 10 == 0)
      pointCountEnd = pointCountEnd + 1;

   for(int i = 0; i < pointCount; i++)
     { //<>//
       particlesList[i].setParameter(0,global_dyn.getRMS()); //<>//
       particlesList[i].setParameter(1, audio_decisor.getFeaturesVector()[10]*10);   //Roughness
       particlesList[i].setParameter(2, audio_decisor.getFeaturesVector()[8]);   //Complexity
       particlesList[i].setParameter(3, audio_decisor.getInstantFeatures()[6]*10);   //Complexity
       particlesList[i].setPalette(this.pal);
       
       // Gradual shift between current position and newly computed Lissajous points
       newX = particlesList[i].gradualShift(particlesList[i].getPosition().getX(), lissajousPoints[i].getX(), 0.1);
       newY = particlesList[i].gradualShift(particlesList[i].getPosition().getY(), lissajousPoints[i].getY(), 0.1);
       particlesList[i].setPosition(new Vector2d(newX, newY, false));
      
      particlesList[i].update();
      particlesList[i].updatePhysics();
     } //<>//
     
     if (particlesList[0].getParameter(0) < MIN_PARAM_VAL && particlesList[0].getParameter(1) < MIN_PARAM_VAL)
     {
       if (freqX > 0 && freqY > 0){ 
       freqX = particlesList[0].gradualShift(freqX, freqX-0.01, 0.5);
       freqY = particlesList[0].gradualShift(freqY, freqY-0.01, 0.5);
       }
       else{
         freqX = 0;
         freqY = 0;
       }
       
       raisingFreqX = false;
       raisingFreqY = false;
       raisingModFreq = false;
     }
     else if ( freqX < MAX_FREQ && raisingFreqX ){
       freqX = freqX + particlesList[0].getParameter(3)/1000; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
       raisingFreqX = true;
     }
     else{
       freqX -= particlesList[0].getParameter(3)/100;
       raisingFreqX = false;
       if(freqX< MIN_FREQ)
         raisingFreqX=true;
     }

     if ( freqY < MAX_FREQ && raisingFreqY ){
     freqY = freqY + particlesList[0].getParameter(0)/800;
     raisingFreqY = true;
     }
     
     else{
       freqY = particlesList[0].gradualShift(freqY, freqY-particlesList[0].getParameter(0)/80, 0.5);
       raisingFreqY = false;
       if(freqY < MIN_FREQ)
         raisingFreqY=true;
     }
    if ( modFreqY < 2 && raisingModFreq){
      modFreqY = (modFreqY+particlesList[0].getParameter(0)/100);
      modFreq2Strength = modFreq2Strength + particlesList[0].getParameter(0)/150;
      raisingModFreq = true;
    }
    else{
      modFreqY = (modFreqY-particlesList[0].getParameter(0)/100);
      modFreq2Strength = modFreq2Strength - particlesList[0].getParameter(0)/150;
      raisingModFreq = false;
     if ( modFreqY < MIN_FREQ)
      raisingModFreq = true;
    }


     // if (frameCount % 1 == 0) {println("particlesList[0].getParameter(1) "+ particlesList[0].getParameter(1));}
     calculateLissajousPoints();
  }

  public void trace()
  {
    sceneBackground.trace();
    if (!connectAllPoints) // Default choice
    {
      // if (frameCount % 30 == 0 ) {println("Don't connect all points");}
      for (int i=0; i<pointCountEnd; i++) {
        color colore = pal.getColor( (floor(i/64)%(pal.COLOR_NUM) ) );
        drawLine(particlesList[i], particlesList[i+1], colore);
        // drawLine(lissajousPoints[i], lissajousPoints[i+1], colore);
      }
   }
  }

  void calculateLissajousPoints()
  {
    randomSeed(0);

    float t, x, y, rx, ry;

    float angle, fmx, fmy;

    for (int i=0; i<pointCountEnd; i++) {
      angle = map(i, 0, pointCountEnd, 0, TWO_PI);

      randomOffsets[i] = particlesList[0].gradualShift(randomOffsets[i], 12+((i%6))*particlesList[0].getParameter((i%2)+1), 0.5);

      // an additional modulation of the osscillations
      fmx = sin(angle*modFreq2X) * modFreq2Strength + 1;
      fmy = sin(angle*modFreq2Y) * modFreq2Strength + 1;

      x = sin(angle * freqX * fmx + radians(phi)) * cos(angle * modFreqX);
      y = sin(angle * freqY * fmy) * cos(angle * modFreqY);

      rx = random(-randomOffsets[i], randomOffsets[i]);
      ry = random(-randomOffsets[i], randomOffsets[i]);

      x = (x * (width/2-30-randomOffsets[i]) + width/2) + rx;
      y = (y * (height/2-30-randomOffsets[i]) + height/2) + ry;

      lissajousPoints[i] = new Vector2d(x, y, false);
     }
 }

  public void drawLine(Particle p1, Particle p2, color colore)
  {
    float d, a;
    d = p1.getPosition().distance(p2.getPosition());
    a = pow(1/(d/connectionRadius+1), 8);

    float _hue;

    if (d <= connectionRadius && d > 2)
    {
      _hue = map(a, 0, 0.5, hue(colore), hue(colore)*1.5 )%360 ;
      stroke(_hue, saturation(colore), brightness(colore), a* lineAlphaWeight*lineAlpha*random(0.95,1.05));
      line(p1.getPosition().getX(), p1.getPosition().getY(), p2.getPosition().getX(), p2.getPosition().getY() );
    }
  }

}
