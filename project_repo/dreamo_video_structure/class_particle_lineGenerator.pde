class LineGenerator extends Particle
{
  public void init()
  {
    
  }
  
  public void update()
  {
    if(frameCount%1 == 0)
    {
      Vector2d LineGeneratorPosition = new Vector2d( getPosition() ) ;
      Line tempLine = new Line();
      tempLine.setPosition( LineGeneratorPosition ); // the LINE object is created where the LINE GENERATOR is
      
      //if(frameCount%1 == 0)
      /*{
        println("");
        println("Valore non normalizzato: " + global_gsr.lastValue() );
        println("Valore per cui vorrei dividere: " + global_gsr.outputAbsolute() );
        println( "x " + tempLine.getPosition().getX() + ", y " +tempLine.getPosition().getY() );
        tempLine.setPosition( (tempLine.getPosition().mul(4.0)).quot( global_gsr.outputAbsolute() ) ); // * global_gsr.outputAbsolute()
        println( "new x " + tempLine.getPosition().getX() + ", new y " +tempLine.getPosition().getY() );
        println("");
      }*/
      
      {
        //float outputVar = 1.0;
          float outputVar = global_gsr.getVariation() ;
                
                tempLine.setPosition( (tempLine.getPosition().mul( /*outputVar*/1 ) ) ); // tempLine.getPosition() MOLTIPLICATO PER global_gsr.getVariation()

    if( frameCount % 500 == 0){
        println("Valore per cui vorrei moltiplicare: " + outputVar );
        println( "x " + tempLine.getPosition().getX() + ", y " + tempLine.getPosition().getY() );
        println( "new x " + tempLine.getPosition().getX() + ", new y " +tempLine.getPosition().getY() );
        println("");}
      }
      
      global_stage.getCurrentScene().addParticle(tempLine);
    }
    
  }
  
  public void trace()
  {
    
  }
}