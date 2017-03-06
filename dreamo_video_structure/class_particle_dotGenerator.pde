class DotGenerator extends Particle
{


  public void init()
  {

  }

  public void update()
  {
    setParameter(0, global_gsr.getVariation());
    
    if(frameCount%8 == 0)
    {
      Dot tempDot = new Dot();
      tempDot.setPalette(this.pal);
      tempDot.setBounceAtBorders(true);
      tempDot.setPosition ( (new Vector2d(width/2, height/2, false) ).mul(getParameter(0)) );
      global_stage.getCurrentScene().addParticle(tempDot);
    }
  }

  public void trace()
  {
    //translate(-width/2, -height/2); //this line is not necessary since the DotGenerator has position (0,0, false)
    connectParticles(100,100);
  }



}