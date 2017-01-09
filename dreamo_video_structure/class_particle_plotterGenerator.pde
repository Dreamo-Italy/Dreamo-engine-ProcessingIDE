class PlotterGenerator extends Particle
{
  
    int pointCount = 0;
    ArrayList<Vector2d> pointList = new ArrayList<Vector2d>();
    float connectionRadius = 40;
    float minHueValue = 0;
    float maxHueValue = 100;
    float saturationValue = 100;
    float brightnessValue = 100;
    float lineWeight = 1;
    float lineAlpha = 200;
    int i1 = 0;
    
    // ------ initial parameters and declarations ------

    float imageAlpha = 30;
    float eraserRadius = 20;
    
    // minimum distance to previously set point
    float minDistance = 10;    
    
    float zoom = 1;
  
  public void init()
  {
     selectFileLoadPoints() ;
  }
  
  public void update()
  {      
      //pseudo random variations for the printed objects
      
      if(frameCount % 42 == 0)  zoom *= 3;
      if(frameCount % 53 == 0)  zoom = 0.8;
       if(frameCount % 5 == 0)  connectionRadius = random(70);
       if(frameCount % 7 == 0)  lineWeight = 1.5;
       if(frameCount % 11 == 0)  lineWeight = 5;    
       if(frameCount % 40 == 0)  minHueValue = 20;
       if(frameCount % 50 == 0)  minHueValue = 0;
       if(frameCount % 1000 == 0) zoom *= 5;
       
    
  }
  
  public void trace()
  {    
    //translate(width/6, height/4);
    scale(zoom);
    
    // ------ draw everything ------
    strokeWeight(lineWeight);
    stroke(255, lineAlpha);
    strokeCap(ROUND);
    noFill();
    //tint(255, imageAlpha);
 
    // drawing method where all points are connected with each other
    // alpha depends on distance of the points  

    colorMode(HSB, 360, 100, 100, 100);
    

    
    int particlesNumber = global_stage.getCurrentScene().getParticlesNumber();
    i1 = 0;
    while (i1 < particlesNumber ) 
    {
      for (int i2 = 0; i2 < i1; i2++) {
        Vector2d p1 = global_stage.getCurrentScene().getParticleByListIndex(i1).getPosition();
        Vector2d p2 = global_stage.getCurrentScene().getParticleByListIndex(i2).getPosition();
        drawLine(p1, p2);
      }
      i1++;        
    }   
    
     i1 = 0;
     while (i1 < pointCount) 
     {
      for (int i2 = 0; i2 < i1; i2++) 
      {       
        Vector2d p1 = pointList.get(i1);
        Vector2d p2 = pointList.get(i2);
        drawLine(p1, p2);     
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
    
     if (d <= connectionRadius) 
    {
      h = map(a, 0, 1, minHueValue, maxHueValue) % 360;
      stroke(h, saturationValue, brightnessValue, a*lineAlpha + (i1%2 * 2));
      
     // without popMatrix() and pushMatrix() there's a WRONG TRANSLATION in the plot
     popMatrix();
      line(p1.getX(), p1.getY(), p2.getX(), p2.getY() );  
      pushMatrix();
      
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
        String[] pt = pointStrings[i].split(" "); i = i+1;
        
       if (pt.length == 3 ) 
        {         
         Vector2d position = new Vector2d( float(pt[0]), float(pt[1]), false );
          
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
           
          
          float mod = 1;
          Vector2d speed = new Vector2d ( mod , angle, true);
          
          // Add the new particle to the list
                
          pointList.add( position );
          pointCount++;
          
          RadialDot newParticle = new RadialDot();
          newParticle.setPosition( position );
          newParticle.setSpeed( speed );
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
    
    String path = new String( dataPath("coordinate_dreamo.txt") );
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