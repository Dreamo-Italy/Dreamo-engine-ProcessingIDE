class DotGenerator extends Particle
{
  public void init()
  {
    
  }
  
  public void update()
  {
    if(frameCount%2 == 0)
    {
      Dot tempDot = new Dot();
      tempDot.setPosition(new Vector2d(mouseX, mouseY, false));
      global_stage.getCurrentScene().addParticle(tempDot);
    }
  }
  
  public void trace()
  {
    
  }
}