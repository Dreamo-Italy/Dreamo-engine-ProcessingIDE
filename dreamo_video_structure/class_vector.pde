//*************************************************
// class Vector
// last modified: 12/11/16
//
//**************************************************

class Vector
{
  //PRIVATE MEMBERS
  private float x, y;
  private float modulus, direction;
  
  //CONSTRUCTORS
  public Vector(float newX_Mod, float newY_Dir, boolean polar)
  {
    if(polar)
    {
      setModDir(newX_Mod, newY_Dir);
    } 
    else
    {
      setXY(newX_Mod, newY_Dir);
    }  
  }
  
  //copy constructor
  public Vector(Vector toCopy)
  {
    x = toCopy.x;
    y = toCopy.y;
    modulus = toCopy.modulus;
    direction = toCopy.direction;
  }
  
  //PUBLIC METHODS
  //get methods
  public float getX()
  {
    return x;
  }
  
  public float getY()
  {
    return y;
  }
  
  public float getModulus()
  {
    return modulus;
  }
  
  public float getDirection()
  {
    return direction;
  }
  
  //set methods
  public void setXY(float newX, float newY)
  {
    x = newX;
    y = newY;
    direction = atan2(y, x);
    modulus = dist(0, 0, x, y);
  }
  
  public void setX(float newX)
  {
    setXY(newX, y);
  }
  
  public void setY(float newY)
  {
    setXY(x, newY);
  }
  
  public void setModDir(float newModulus, float newDirection)
  {
    modulus = newModulus;
    if(modulus < 0)
    {
      println("warning: modulus set as negative number");
    }
    direction = newDirection;
    while(direction > TWO_PI) direction-=TWO_PI;
    while(direction < 0) direction+=TWO_PI;
    x = modulus*cos(direction);
    y = modulus*sin(direction);
  }
  
  public void setModulus(float newModulus)
  {
    setModDir(newModulus, direction);
  }
  
  public void setDirection(float newDirection)
  {
    setModDir(modulus, newDirection);
  }
  
  //apply methods
  public void applyTranslation()
  {
    translate(x, y);
  }
  
  public void applyRotation()
  {
    rotate(direction);
  }
  
  //functions  
  public float distance(Vector other)
  {
    return dist(x, y, other.getX(), other.getY());
  }
  
  public Vector sum(Vector other)
  {
    return new Vector(x+other.getX(), y+other.getY(), false);
  }
  
  public Vector mirrorX()
  {
    return new Vector(-x, y, false);
  }
  
  public Vector mirrorY()
  {
    return new Vector(x, -y, false);
  }
}