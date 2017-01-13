class PlotterGenerator extends Particle
{
  
    ArrayList<Vector2d> pointList = new ArrayList<Vector2d>();

    int pointCount = 0;
    int i1 = 0;
    
    boolean destroying = false;
    
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
    
  
  public void init()
  {
     selectFileLoadPoints() ;
     setPersistence(true);
  }
  
  public void update()
  {      
      //pseudo random variations for the printed objects
      
      if(frameCount % 42 == 0)  lineWeight *= 2;
      //if(frameCount % 53 == 0)  zoom = 0.8;
       if(frameCount % 5 == 0)  {connectionRadius = 50; zoom = 1;}
       if(frameCount % 7 == 0)  lineWeight = 1.5;
       if(frameCount % 11 == 0)  lineWeight = 5;    
       //if(frameCount % 40 == 0)  minHueValue = 0;
       //if(frameCount % 50 == 0)  minHueValue = 0;
       if(frameCount % 60 == 0) {connectionRadius = 100; lineWeight = 15;}
     //  if(frameCount % 80 == 0) {selectFileLoadPoints();}

       
    if(getSceneChanged() && !destroying)
    {
      destroying = true;
      setLifeTimeLeft(60);
    }
  }
  
  public void trace()
  {    
    //pushMatrix();
   // translate(-width/2, -height/2);
   
    scale(zoom);
    
    // ------ draw everything ------
    strokeWeight(lineWeight);
    if(destroying)
    {
      lineAlphaWeight -= 1.0/50.0;
    }
    stroke(255, lineAlphaWeight*lineAlpha);
    
    //strokeCap(ROUND);
    noFill();
    //tint(255, imageAlpha);
 
    // drawing method where all points are connected with each other
    // alpha depends on distance of the points  

    colorMode(HSB, 360, 100, 100, 100);  
    
    
    // MOVING LINES
    final int particlesNumber = global_stage.getCurrentScene().getParticlesNumber() -1;
    
    i1 = 0;
    
    // draw lines not all at once, just the next 100 milliseconds to keep performance
    int drawEndTime = millis() + 100;
        
    while (i1 < particlesNumber && millis () < drawEndTime) 
    {
      int start_index = (i1 - PARTICLE_RADIUS/2) > 0 ?  (i1 - PARTICLE_RADIUS/2) : 0;
      int end_index = (i1 + PARTICLE_RADIUS/2) < particlesNumber ? (i1 + PARTICLE_RADIUS/2) : particlesNumber ;
      
      for (int i2 = start_index; i2 < end_index; i2++) {
        if(
          (!(global_stage.getCurrentScene().getParticleByListIndex(i1).getSceneChanged()&&global_stage.getCurrentScene().getParticleByListIndex(i2).getSceneChanged())&&!destroying)
          ||(global_stage.getCurrentScene().getParticleByListIndex(i1).getSceneChanged()&&global_stage.getCurrentScene().getParticleByListIndex(i2).getSceneChanged()&&destroying)
          ) //with this condition, programs checks whether the particle is from the correct scene
        {
          Vector2d p1 = global_stage.getCurrentScene().getParticleByListIndex(i1).getPosition();
          Vector2d p2 = global_stage.getCurrentScene().getParticleByListIndex(i2).getPosition();
          drawLine(p1, p2);
        }
      }
      i1++;        
    }   
    /*
     // STEADY LINES
     i1 = 0;
     drawEndTime = millis() + 100;
     final int pointListSize = pointList.size() -1;
     while (i1 < pointCount && millis () < drawEndTime) 
     {
        int start_index = (i1 - PARTICLE_RADIUS/2) > 0 ?  (i1 - PARTICLE_RADIUS/2) : 0;
        int end_index = (i1 + PARTICLE_RADIUS/2) < pointListSize ? (i1 + PARTICLE_RADIUS/2) : pointListSize ;

      for (int i2 = start_index; i2 < end_index; i2++) 
      {       
        Vector2d p1 = pointList.get(i1);
        Vector2d p2 = pointList.get(i2);
        drawLine(p1, p2);     
      }
      i1++;        
    }*/
    
   colorMode(RGB, 255);
   //popMatrix();

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

    
    
   public void loadPointPathSelected(File selection)
  {  
    if (selection != null) 
    {
      String loadPointsPath = selection.getAbsolutePath(); 
      String[] pointStrings = loadStrings(loadPointsPath);
      pointCount = 0;
      pointList.clear();
      
      for (int i=0; i<pointStrings.length; i++) 
      {
       String[] pt = pointStrings[i].split(" "); 
        
       if (pt.length == 3 ) 
        {         
         Vector2d position = new Vector2d( float(pt[0]), float(pt[1]), false );
          
         float angle = 0;
         
         // use different angle evaluation for each quarter of the screen
         // USEFUL to implement RADIAL MOVEMENT FROM THE CENTER TO THE EDGES
         
         if( position.getX()> width/2 && position.getY() < height/2)
           angle = - atan2(height - position.getY(), position.getX()) ;
         else if( position.getX() <  width/2 && position.getY() < height/2)
           angle = - atan2(height - position.getY(), -position.getX()) ;
         else if( position.getX() <  width/2 && position.getY() > height/2)
           angle = atan2( position.getY(), position.getX()) + PI/2 ;
         else if( position.getX() >  width/2 && position.getY() > height/2)
           angle = atan2( position.getY(), position.getX()) ;
           
           angle += random(-PI/5, PI/5);
           
          
          float mod = 1;
          Vector2d speed = new Vector2d ( mod , angle, true);
          
          // Add the new particle to the TWO LISTS: pointList and the global_stage list
                
          pointList.add( position );
          pointCount++;
          
          RadialDot newParticle = new RadialDot();
          newParticle.setGravityCenter(position);
          //newParticle.setPosition( position );
          //newParticle.setSpeed( speed );
          global_stage.getCurrentScene().addParticle( newParticle ); 
          
        }
      }
  }
    else
      println("WARNING: loadPointsPathSelected called with NULL ARGUMENT - could not open the txt file");
      return;
  }
  
    void selectFileLoadPoints() 
    {
    // opens file chooser
    //selectInput("Select Text File with Point Information", "loadPointPathSelected");
    
    String path = new String( dataPath("coordinate_dreamo2.txt") );
    File incomingText = new File(path);
    loadPointPathSelected(incomingText);
    
    }   
 
  
  
  public void drawLine(PVector p1, PVector p2) 
  {

    float d, a, h;
    d = PVector.dist(p1, p2);
    a = pow(1/(d/connectionRadius+1), 6);
  
    if (d <= connectionRadius) 
    {
     // h = map(a, 0, 1, minHueValue, maxHueValue) % 360;
     // stroke(h, saturationValue, brightnessValue, a*lineAlpha + (i1%2 * 2));
      stroke(255);
      line(p1.x, p1.y, p2.x, p2.y);
    }
  }
}