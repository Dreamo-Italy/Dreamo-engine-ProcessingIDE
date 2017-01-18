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
      
      tempDot.setPalette(this.pal);
      float outputVar = global_gsr.getVariation() ; // CONDUCTANCE VALUE - DEBUG
      
      tempDot.setPosition ( (new Vector2d(mouseX, mouseY, false) ).mul(/*outputVar*/1) );
      global_stage.getCurrentScene().addParticle(tempDot);
    }
  }
  
  public void trace()
  {
    
  }
  

  
}