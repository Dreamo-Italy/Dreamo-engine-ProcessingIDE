//*************************************************
// class Particle
// last modified: 21/08/16
//
//  descrive l'oggetto base della visualizzazione
//
//**************************************************

abstract class Particle
{
  //PROTECTED MEMBERS
  protected Vector position;
  protected Vector speed;
  protected Vector gravity;
  protected Vector rotation;
  protected float strokeWidth;
  protected color strokeColor;
  protected color fillColor;
  
  //CONTRUCTORS
  public Particle(Vector position)
  {
    speed = new Vector(0, 0, false);
    gravity = new Vector(0, 0, false);
  }
  //copy constructor
  public Particle(Particle toCopy)
  {
    position = new Vector(toCopy.position);
    speed = new Vector(toCopy.speed);
    gravity = new Vector(toCopy.gravity);
  }
  
  //PUBLIC METHODS
  //get methods
  public Vector getPosition()
  {
    return position;
  }
  
  public Vector getSpeed()
  {
    return speed;
  }
  
  public Vector getGravity()
  {
    return gravity;
  }
  
  public Vector getRotation()
  {
    return rotation;
  }
  
  public float getStrokeWidth()
  {
    return strokeWidth;
  }
  
  public color getStrokeColor()
  {
    return strokeColor;
  }
  
  public color getFillColor()
  {
    return fillColor;
  }
  
  //set methods  
  public void setPosition(Vector newPosition)
  {
    position = new Vector(newPosition);
  }
  
  public void setSpeed(Vector newSpeed)
  {
    speed = new Vector(newSpeed);
  }
  
  public void setGravity(Vector newGravity)
  {
    gravity = new Vector(newGravity); 
  }
  
  public void setRotation(float newRotation)
  {
    rotation = new Vector(1, newRotation, true);
  }
  
  public void setStrokeWidth(float newStrokeWidth)
  {
    strokeWidth = newStrokeWidth;
    if(strokeWidth < 0)
    {
      println("warning: strokeWidth set as negative number");
    }
  }
  
  public void setStrokeColor(color newStrokeColor)
  {
    strokeColor = newStrokeColor;
  }
  
  public void setFillColor(color newFillColor)
  {
    fillColor = newFillColor;
  }
  
  //update and trace methods
  public void update_physics()
  {
    position = position.sum(speed);
    speed = speed.sum(gravity);
  }
  
  public abstract void trace();
}