//*************************************************
// class Vector
// last modified: 21/08/16
//
// descrive lo sfondo
//
//**************************************************

class Background
{
  //PRIVATE MEMBERS
  private color backgroundColor;
  
  //CONSTRUCTORS
  public Background(color newBackgroundColor)
  {
    backgroundColor = newBackgroundColor;
  }
  //copy contructor
  public Background(Background toCopy)
  {
    backgroundColor = toCopy.backgroundColor;
  }
  
  //PUBLIC METHODS
  //trace methods
  public void trace()
  {
    background(backgroundColor);
  }
}