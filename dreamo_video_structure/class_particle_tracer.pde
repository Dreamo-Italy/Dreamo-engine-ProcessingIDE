class ParticleTracer extends Particle
{
  final float SPEED = 6;
  float noiseScale;
  float noiseStrength;
  float angle;
  float nCrossedX, nCrossedY;
  int indexShifting;
  //int alpha;
  
  void init()
  {
    noiseScale = 300;
    noiseStrength = 100;
    setSpeed(new Vector2d(0, 0, true));
    nCrossedX = 0;
    nCrossedY = 0;
    indexShifting = 0;
  }
    
  // each ParticleTracer (little snake) creates a new NoiseDot particle at each update()
  // ParticleTracer particles vanish with time (see setLeftTimeLeft parameter)
  void update()
  {
    
    if ( frameCount % 4 == 0 && indexShifting < getPalette().COLOR_NUM && round(random(1)) == 1 )     indexShifting++;              
    if ( indexShifting >= getPalette().COLOR_NUM)         indexShifting = 0;

    angle = noise((getPosition().getX() + nCrossedX*width)/noiseScale, (getPosition().getY()+nCrossedY*height)/noiseScale) * noiseStrength;
    
    getSpeed().setDirection(angle);
    getSpeed().setModulus(SPEED*3*getParameter(0)); 
    
    keepInsideTheScreen();    
  }
  
  void trace()
  {
    NoiseDot particleDot = new NoiseDot();
    particleDot.setPosition(getPosition());
    
    //particleDot.setAlpha(alpha);
    //particleDot.setParameter
    
    particleDot.setColor(pal.getColor(indexShifting)); 
    global_stage.getCurrentScene().addParticle(particleDot);
    
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