class ParticleTracer extends Particle
{
  final float SPEED = 6;
  float noiseScale;
  float noiseStrength;
  float angle;
  float nCrossedX, nCrossedY;
  //int alpha;
  
  void init()
  {
    noiseScale = 300;
    noiseStrength = 100;
    setSpeed(new Vector2d(0, 0, true));
    nCrossedX = 0;
    nCrossedY = 0;
  }
    
  void update()
  {
    angle = noise((getPosition().getX() + nCrossedX*width)/noiseScale, (getPosition().getY()+nCrossedY*height)/noiseScale) * noiseStrength;
    getSpeed().setDirection(angle);
    getSpeed().setModulus(SPEED*getParameter(0));
    NoiseDot particleDot = new NoiseDot();
    particleDot.setPosition(getPosition());
    //particleDot.setPalette(pal);
    particleDot.setColor(pal.getColor());
    //particleDot.setAlpha(alpha);
    //particleDot.setParameter
    global_stage.getCurrentScene().addParticle(particleDot);
    
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
  
  void trace()
  {
  }
}