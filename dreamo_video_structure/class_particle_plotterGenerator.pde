class PlotterGenerator extends Particle
{
    int i1 = 0;
    
    // lines will be drawn ONLY between a particle and the NEAREST PARTILCLE_RADIUS number of particles (e.g. the nearest 40 particles)
    // please use EVEN NUMBERS as the number will be divided by 2
    final int PARTICLE_RADIUS = 120; 
    
     // ------ initial parameters and declarations ------


    float connectionRadius = 300;
    float minHueValue = 155;
    float maxHueValue = 255;
    float saturationValue = 100;
    float brightnessValue = 100;
    float lineWeight = 1;
    float lineAlpha = 200;
    float lineAlphaWeight = 1;
    float imageAlpha = 30;
    float zoom = 1;
    
    boolean gravityCenterEnabled = true;
    
    int fromOneToTen = 1;
    
  
  public void init()
  {
     loadPointsFromTxt() ;
     setPersistence(true);
  }
  
  public void update()
  {      
      //pseudo random variations for the printed objects
      
      if(frameCount % 42 == 0)  lineWeight *= 2.5;
      //if(frameCount % 53 == 0)  zoom = 0.8;
       if(frameCount % 5 == 0)  {connectionRadius = 50; zoom = 1;}
       if(frameCount % 7 == 0)  lineWeight = 1.5;
       if(frameCount % 11 == 0)  lineWeight = 5;    
       //if(frameCount % 40 == 0)  minHueValue = 0;
       //if(frameCount % 50 == 0)  minHueValue = 0;
       if(frameCount % 60 == 0) {connectionRadius = 100; lineWeight = 15;}
     //  if(frameCount % 80 == 0) {loadPointsFromTxt();}

       
    if(getSceneChanged() && !isDestroying() )
    {
      assertDestroying();
      setLifeTimeLeft(60);
    }
    
    if( isDestroying() )
    {
      lineAlphaWeight -= 1.0/50.0;
    }
  }
  
  public void trace()
  {    
    strokeWeight(lineWeight);
    stroke(255, lineAlphaWeight*lineAlpha);
    noFill();
    
    //tint(255, imageAlpha);

    colorMode(HSB, 360, 100, 100, 100);      
    
    final int particlesNumber = global_stage.getCurrentScene().getParticlesNumber() -1;
    
    // automatic offset variation
    if ( frameCount % 32 == 0 ){
      if ( fromOneToTen < 10 )
        fromOneToTen++;
      else fromOneToTen = 0;
    }  
    
    // The classic "Fixed DREAMO logo" is still available:
    // just set indexOffset = 0, timeSpentDrawing = 10
    
    // "INDEX OFFSET". Range: 1 - 10 ( drawing start - drawing end )
    
    float indexOffset = fromOneToTen ;
    
    // "TIME SPENT DRAWING". Range: 1 - 10 ( short time - long time )
    
    float timeSpentDrawing = 7 ;
    
    // indexOffset MAPPING
    indexOffset = map (indexOffset, 10.0, 0.0, 1, particlesNumber ); 
    i1 = int ( particlesNumber - ceil(indexOffset) );
    
    // timeSpentDrawing MAPPING
    timeSpentDrawing = map (timeSpentDrawing, 10.0, 0.0, 1, 20 ); 
    
    // draw lines just for the next period/N milliseconds
    int period = int ( 1000 * (1.0/30) );
    int drawEndTime = millis() + period/round(timeSpentDrawing);
        
    while (i1 < particlesNumber && millis () < drawEndTime) 
    {
      int start_index = (i1 - PARTICLE_RADIUS/2) > 0 ?  (i1 - PARTICLE_RADIUS/2) : 0;
      int end_index = (i1 + PARTICLE_RADIUS/2) < particlesNumber ? (i1 + PARTICLE_RADIUS/2) : particlesNumber ;
      
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
   colorMode(RGB, 255);

  }
  
  public void drawLine(Vector2d p1, Vector2d p2)
  {
    float d, a, h;
    d = p1.distance(p2);
    a = pow(1/(d/connectionRadius+1), 6);
    
    if (d <= connectionRadius && d > 2) 
    {
      h = map(a, 0, 1, minHueValue, maxHueValue) % 360;
      stroke(h, saturationValue, brightnessValue, a*lineAlphaWeight*lineAlpha + (i1%2 * 2));
      line(p1.getX(), p1.getY(), p2.getX(), p2.getY() );  
    }
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
  String path = new String( dataPath("coordinate_dreamo2.txt") );
  File incomingFile = new File(path);  
  loadPointsFromFile(incomingFile);  
 } 
 
}

boolean sameSceneParticles(int i1, int i2, boolean destroying)

// the result is TRUE if:
// the scene HAS NOT CHANGED  and both particles are from CURRENT SCENE
// or if
// the scene HAS CHANGED  and both particles are from PREVIOUS SCENE

{
  return( 
          (
          !(global_stage.getCurrentScene().getParticleByListIndex(i1).getSceneChanged()&&
          global_stage.getCurrentScene().getParticleByListIndex(i2).getSceneChanged() )
          &&!destroying
          
          )
            ||
          (
          (global_stage.getCurrentScene().getParticleByListIndex(i1).getSceneChanged()&&
           global_stage.getCurrentScene().getParticleByListIndex(i2).getSceneChanged() )
           && destroying
           )
           //with this condition, programs checks whether the particle is from the correct scene
      );
}