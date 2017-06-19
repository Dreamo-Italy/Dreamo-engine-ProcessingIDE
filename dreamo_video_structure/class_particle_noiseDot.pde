class NoiseDot extends Particle
{
  final float SPEED = 28;
  float noiseScale;
  float noiseStrength;
  float angle;
  float nCrossedX, nCrossedY;
  int indexShifting;
  
  color colore;
  int alpha;
  
  void init()
  {
    noiseScale = 300;
    noiseStrength = 100;
    setSpeed(new Vector2d(0, 0, true));
    nCrossedX = 0;
    nCrossedY = 0;
    indexShifting = 0;
    
    //setLifeTimeLeft(10);
    alpha=100;
    //¢setPersistence(true);
    
  }


  void update()
  {
    
    if ( frameCount % 4 == 0 && indexShifting < getPalette().COLOR_NUM && round(random(1)) == 1 )     indexShifting++;              
    if ( indexShifting >= getPalette().COLOR_NUM)         indexShifting = 0;

    angle = noise((getPosition().getX() + nCrossedX*width)/noiseScale, (getPosition().getY()+nCrossedY*height)/noiseScale) * noiseStrength;
    
    getSpeed().setDirection(angle);
    getSpeed().setModulus(SPEED*getParameter(0)); 
    
    keepInsideTheScreen();    
    
    //alpha -= 255/10;
    
  }
  
  void trace()
  {
    
    noStroke();
    colore=pal.getColor(indexShifting);
    fill(colore);
    ellipse(-5, -5, 9, 9);
    
  }
  
  void keepInsideTheScreen()
  {
     if(getPosition().getX() > width)
    {
      getPosition().setX(getPosition().getX() - width);
      nCrossedX++;
    }
    if(getPosition().getY() > height)
    {
      getPosition().setY(getPosition().getY() - height);
      nCrossedY++;
    }
    if(getPosition().getX() < 0)
    {
      getPosition().setX(getPosition().getX() + width);
      nCrossedX--;
    }
    if(getPosition().getY() < 0)
    {
      getPosition().setY(getPosition().getY() + height);
      nCrossedY--;
    }
  }
}