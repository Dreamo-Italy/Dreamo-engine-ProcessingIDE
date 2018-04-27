//package dreamo.display;

class Vector2d 
{
 //PRIVATE MEMBERS
 private float x, y;
 private float modulus, direction;

 //CONSTRUCTORS
 public Vector2d(float newX_Mod, float newY_Dir, boolean polar) 
 {
  if (polar) 
  {
   setModDir(newX_Mod, newY_Dir);
  } 
  else 
  {
   setXY(newX_Mod, newY_Dir);
  }
 }

 //copy constructor
 public Vector2d(Vector2d toCopy) 
 {
  x = toCopy.x;
  y = toCopy.y;
  modulus = toCopy.modulus;
  direction = toCopy.direction;
 }

 //PUBLIC METHODS
 //get methods
 public float getX() { return x; }

 public float getY() { return y; }

 public float getModulus() { return modulus; }

 public float getDirection() { return direction; }

 //set methods
 public void setXY(float newX, float newY) 
 {
  x = newX;
  y = newY;
  direction = (float)FastMath.atan2(y, x);
  modulus = dist(0, 0, x, y);
 }

 public void setX(float newX) { setXY(newX, y); }

 public void setY(float newY) { setXY(x, newY); }

 public void setModDir(float newModulus, float newDirection) 
 {
  modulus = newModulus;
  direction = newDirection;
  if (modulus < 0) 
  {
   direction -= PI;
   modulus = -modulus;
  }
  while (direction > TWO_PI) direction -= TWO_PI;
  while (direction < 0) direction += TWO_PI;
  x = (float) (modulus * FastMath.cos(direction));
  y = (float) (modulus * FastMath.sin(direction));
 }

 public void setModulus(float newModulus) { setModDir(newModulus, direction); }

 public void setDirection(float newDirection) { setModDir(modulus, newDirection); }
 
 //apply methods
 public void applyTranslation() { translate(x, y); }

 public void applyRotation() { rotate(direction); }

 //functions 
 public Vector2d mul(float parameter) { return new Vector2d(getX() * parameter, getY() * parameter, false); }   //multiplies
 
 public Vector2d quot(float parameter) { return new Vector2d(getX() / parameter, getY() / parameter, false); }  // quotient
 
 public float distance(Vector2d other) { return dist(x, y, other.getX(), other.getY()); }
 
 public Vector2d sum(Vector2d other)  { return new Vector2d(x + other.getX(), y + other.getY(), false); }
 
 public Vector2d subtract(Vector2d other)  { return new Vector2d(x - other.getX(), y - other.getY(), false); }
 
 public Vector2d mirrorX()  { return new Vector2d(-x, y, false); }

 public Vector2d mirrorY() { return new Vector2d(x, -y, false); }
}