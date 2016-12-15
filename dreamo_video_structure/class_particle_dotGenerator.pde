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
      
      float outputVar = global_gsr.getVariation() ; // CONDUCTANCE VALUE - DEBUG
      
      tempDot.setPosition ( (new Vector2d(mouseX, mouseY, false) ).mul(outputVar) );
      global_stage.getCurrentScene().addParticle(tempDot);
    }
  }
  
  public void trace()
  {
    
  }
}