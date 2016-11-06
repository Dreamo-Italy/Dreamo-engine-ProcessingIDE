//*************************************************
// class Square
// last modified: 21/08/16
//
// particella quadrata
//
//**************************************************

class Square extends Particle
{
  //PRIVATE MEMBERS
  private float side;
  private float tremble;
  
  //CONSTRUCTORS
  public Square(Vector position, float newSide)
  {
    super(position);
    setSide(newSide);    
    tremble = 0;
    rotation = new Vector(1, 0, true);
  }
  //copy contructor
  public Square(Square toCopy)
  {
    super(toCopy);
    side = toCopy.side;
    tremble = toCopy.tremble;
    rotation = new Vector(toCopy.rotation);
  }
  
  //PUBLIC METHODS
  //set methods
  public void setSide(float newSide)
  {
    side = newSide;
    if(side < 0)
    {
      println("warning: side set as negative number");
    }
  }
  
  public void setTremble(float newTremble)
  {
    tremble = newTremble;
  }
  
  //trace and update methods
  public void trace()
  {
    pushMatrix();
    position.applyTranslation();
    rotation.applyRotation();
    stroke(strokeColor);
    strokeWeight(strokeWidth);
    fill(fillColor);
    draw_square_tremble(side, tremble);
    popMatrix();
  }
}