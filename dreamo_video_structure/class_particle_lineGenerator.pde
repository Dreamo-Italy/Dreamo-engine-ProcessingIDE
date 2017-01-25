class LineGenerator extends Particle
{
  public void init()
  {
    
  }
  
  public void update()
  {

      Vector2d LineGeneratorPosition = new Vector2d( getPosition() ) ;
      Line tempLine = new Line();
      tempLine.setPalette(pal);
      tempLine.setPosition( LineGeneratorPosition ); // the LINE object is created where the LINE GENERATOR is
      global_stage.getCurrentScene().addParticle(tempLine);

  }
  
  public void trace()
  {
    
  }
}