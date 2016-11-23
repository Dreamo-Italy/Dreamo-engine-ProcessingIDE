class LineGenerator extends Particle
{
  public void init()
  {
    
  }
  
  public void update()
  {
    if(frameCount%1 == 0)
    {
      Line tempLine = new Line();
      tempLine.setPosition(new Vector2d(getPosition()));
      global_stage.getCurrentScene().addParticle(tempLine);
    }
  }
  
  public void trace()
  {
    
  }
}
