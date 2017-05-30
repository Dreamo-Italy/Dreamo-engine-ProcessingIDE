class PlotterGenerator extends Particle
{
     // ------ initial parameters and declarations ------

    // lines will be drawn ONLY between a particle and the NEAREST PARTILCLE_RADIUS number of particles (e.g. the nearest 40 particles)
    int particleConnectionRadius;

    float connectionRadius;
    float hueValue;
    float saturationValue;
    float brightnessValue;
    float lineWeight = 1;
    float lineAlpha = 200;
    float lineAlphaWeight = 1;
    float imageAlpha = 100;

    float zoom = 1;
    float rotation = 0;

    float timeSpentDrawing, indexOffset;
    int particlesNumber;
    float damping;
    boolean mode1, mode2;

    color myColor;
    boolean gravityCenterEnabled;
    int fromOneToTen;
    int i1;


  public void init()
  {
     setPersistence(true);

     myColor = pal.getLightest();
     hueValue = hue(myColor);
     saturationValue = saturation(myColor);
     brightnessValue = brightness(myColor);

     fromOneToTen = 0;
     i1 = 0;
     damping = 8;
     gravityCenterEnabled = true;
     mode1= true;
     mode2 = false;

     loadPointsFromTxt() ;

  }

  public void update()
  {
    if ( global_timbre.getCentroidAvg()>0.6 && global_timbre.getComplexityAvg()<0.2 ){
    //(frameCount % (global_fps*15) == 0){ // switch between mode1 and mode2, with different damping factors
        mode2 = mode1;
        mode1 = false;
      }
      println("mode1: "+mode1);
      setParameter(0, global_dyn.getRMS()*1.7 );

     // default values:

      if(mode1) damping = 0.2;
      else if(mode2) damping = 0.1;

      connectionRadius = 40;
      particleConnectionRadius = 200;
      zoom = 1;
      lineWeight = 2.5;
      setRotation(0);
      setPosition( new Vector2d (0 , 0 , false ) );


      //variations for the printed objects:
      if(frameCount % 15 == 0)
      {
        if(getParameter(0) > 0.45 )
           { setPosition( new Vector2d ( random(-width/6, width/6) , random(-height/6, height/6) , false ) ); damping = 0.001; }
        else if(getParameter(0) > 0.9 )
            {connectionRadius = 50; zoom = 1.05*getParameter(0);  lineWeight = 7; }
        if ( global_dyn.getDynamicityIndex() > 0.86)
          { lineWeight = 40; connectionRadius = 10; particleConnectionRadius = 500;  /*setRotation(random(PI)/8);*/ }
        //  if(frameCount % 80 == 0) {loadPointsFromTxt();}

     // index variation
        if ( fromOneToTen < 10 )
          { //fromOneToTen++;
          fromOneToTen += round(getParameter(0) * 4/7 + fromOneToTen/10);
          if (getParameter(0) < 0.14 )
            fromOneToTen = 0;
          }
        else fromOneToTen = 0;
      }

    // The classic "Fixed DREAMO logo" is still available:
    // just set indexOffset = 0, timeSpentDrawing = 10

    // "INDEX OFFSET". Range: 0 - 10 ( drawing start - drawing end )
    // *********
     indexOffset = fromOneToTen ;
    // *********
    // "TIME SPENT DRAWING". Range: 1 - 10 ( short time - long time )
    // *********
     timeSpentDrawing = getParameter(0)/2 * 10 + 7;
    // *********

    particlesNumber = global_stage.getCurrentScene().getParticlesNumber() -1;

    indexOffset = map (indexOffset, 10.0, 0.0, 0, particlesNumber );
    i1 = int ( particlesNumber - round(indexOffset) );

    // timeSpentDrawing MAPPING
    timeSpentDrawing = map (timeSpentDrawing, 10.0, 0.1, 1, 20 );
    if( timeSpentDrawing < 0 ) timeSpentDrawing = 0.1;

   for( int i3 = 0; i3 < particlesNumber; i3++)
   {
     global_stage.getCurrentScene().getParticleByListIndex(i3).setIntro(mode1);

     if ( mode1 == true ){
       global_stage.getCurrentScene().getParticleByListIndex(i3).setDamping(damping);
       global_stage.getCurrentScene().getParticleByListIndex(i3).perturbate(2.2*getParameter(0));
     }
     else if ( mode2 == true){
       if( frameCount % 6 == 0 ){ //500
        global_stage.getCurrentScene().getParticleByListIndex(i3).perturbate(30*(getParameter(0)-0.1));
       }
     }

   }
   
    if(getSceneChanged() && !this.isDestroying() )
    {
      assertDestroying();
      setLifeTimeLeft(200);
    }

    if( this.isDestroying() )
    {
      lineAlphaWeight -= 1.0/50.0;
    }
  }

  public void trace()
  {
    scale(zoom);
    strokeWeight(lineWeight);
    noFill();

    //tint(1, imageAlpha);

    // draw lines just for the next period/N milliseconds
    int period = int ( 1000 * (1.0/global_fps) );
    int drawEndTime = millis() + period/round(timeSpentDrawing +0.5);

    while (i1 < particlesNumber && millis () < drawEndTime)
    {
      int start_index = (i1 - particleConnectionRadius/2) > 0 ?  (i1 - particleConnectionRadius/2) : 0;
      int end_index = (i1 + particleConnectionRadius/2) < particlesNumber ? (i1 + particleConnectionRadius/2) : particlesNumber ;

      for (int i2 = start_index; i2 < end_index; i2++) {
        if(sameSceneParticles(i1,i2, this.isDestroying() ) )
        {
          Vector2d p1 = global_stage.getCurrentScene().getParticleByListIndex(i1).getPosition();
          Vector2d p2 = global_stage.getCurrentScene().getParticleByListIndex(i2).getPosition();
          drawLine(p1, p2);
        }
      }
      i1++;
    }
  }

  public void drawLine(Vector2d p1, Vector2d p2)
  {
    float d, a;
    d = p1.distance(p2);
    a = pow(1/(d/connectionRadius+1), 6);

    if (d <= connectionRadius && d > 2)
    {
      hueValue = map(a, 0, 0.5, hue(myColor), hue(myColor)*3 )%360 ; //<>// //<>// //<>// //<>// //<>//
      stroke(hueValue, saturationValue, brightnessValue, a*lineAlphaWeight*lineAlpha + (i1 %3 * 2));
      line(p1.getX(), p1.getY(), p2.getX(), p2.getY() );
    }
  }


  RadialDot instantiateNewParticle(Vector2d position)
  {
    RadialDot newParticle = new RadialDot();

   if (gravityCenterEnabled) // DEFAULT BEHAVIOUR
     newParticle.setGravityCenter(position);

   else if (!gravityCenterEnabled) // ALTERNATIVE BEHAVIOUR
   {
     float angle = radialDispersionAngle(position);
     float modulus = 3;
     Vector2d speed = new Vector2d ( modulus , angle, true);
     newParticle.setPosition( position );
     newParticle.setSpeed( speed );
   }

   return newParticle;
  }

  // USEFUL to implement RADIAL MOVEMENT FROM THE CENTER TO THE EDGES --- EVALUATE the ANGLE for RADIAL DISPERSION MOVEMENT
  float radialDispersionAngle(Vector2d position)
  {
    float angle = 0;

   // use different angle evaluation for each quarter of the screen

   if( position.getX()> width/2 && position.getY() < height/2)
     angle = - atan2(height - position.getY(), position.getX()) ;
   else if( position.getX() <  width/2 && position.getY() < height/2)
     angle = - atan2(height - position.getY(), -position.getX()) ;
   else if( position.getX() <  width/2 && position.getY() > height/2)
     angle = atan2( position.getY(), position.getX()) + PI/2 ;
   else if( position.getX() >  width/2 && position.getY() > height/2)
     angle = atan2( position.getY(), position.getX()) ;

    angle += random(-PI/5, PI/5);
    return angle;
  }

 void loadPointsFromTxt()
 {
  String path = new String( dataPath("coordinate_dreamo4.txt") );
  if ( path == null ) {println("ERROR: loadPointsFromTxt - txt file path is not valid"); return;}

  File incomingFile = new File(path);
  loadPointsFromFile(incomingFile);
 }


public void loadPointsFromFile(File inputFile)
  {
    if (inputFile == null ) {println("ERROR: loadPointsFromFile called with NULL argument - could not open the txt file"); return;}

    String filePath = inputFile.getAbsolutePath();
    String[] fileLines = loadStrings(filePath);

    for (int i=0; i<fileLines.length; i++)
    {
     String[] coordinateXY = fileLines[i].split(" ");

     if (coordinateXY.length == 3 )
        {
         Vector2d position = new Vector2d( float(coordinateXY[0]), float(coordinateXY[1]), false );
         RadialDot newParticle = instantiateNewParticle(position);

        // Add the new particle to the global_stage list
        global_stage.getCurrentScene().addParticle( newParticle );
        }
    }
  }
}

// GLOBAL FUNCTION

boolean sameSceneParticles(int i1, int i2, boolean destroying)
  {
  return(
          (
          // the scene HAS NOT CHANGED  and both particles are from CURRENT SCENE
          !(global_stage.getCurrentScene().getParticleByListIndex(i1).getSceneChanged()&&
          global_stage.getCurrentScene().getParticleByListIndex(i2).getSceneChanged() )
          &&!destroying

          )
            ||
          (
          // the scene HAS CHANGED  and both particles are from PREVIOUS SCENE
          (global_stage.getCurrentScene().getParticleByListIndex(i1).getSceneChanged()&&
           global_stage.getCurrentScene().getParticleByListIndex(i2).getSceneChanged() )
           && destroying
           )
           //with this condition, programs checks whether the particle is from the correct scene
      );
  }