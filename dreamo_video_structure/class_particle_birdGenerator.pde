//test class
class BirdGenerator extends Particle
{  
  public void init()
  {

  }
  
  public void update()
  {    
    setGravity(new Vector(0.4, atan2(height/2-getPosition().getY(), width/2-getPosition().getX()), true));
    if(getSpeed().getModulus() > 15) getSpeed().setModulus(15);
    if(global_particlesCount < 100000)
    {
      Bird newCircle = new Bird();
      newCircle.setPosition(this.getPosition());
      global_activeScene.addParticle(newCircle);
    }
    float x = this.getPosition().getX();
    float y = this.getPosition().getY();
    if(x < 0)
    {
      getPosition().setX(1);
      setSpeed(getSpeed().mirrorX());
    }
    if(x > width)
    {
      getPosition().setX(width-1);
      setSpeed(getSpeed().mirrorX());
    }
    if(y < 0)
    {
      getPosition().setY(1);
      setSpeed(getSpeed().mirrorY());
    }
    if(y > height)
    {
      getPosition().setY(height-1);
      setSpeed(getSpeed().mirrorY());
    }
  }
  
  public void trace()
  {

  }
}