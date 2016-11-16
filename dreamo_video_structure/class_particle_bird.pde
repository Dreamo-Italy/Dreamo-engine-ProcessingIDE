//test class
class Bird extends Particle
{  
  color circleColor;
  float size;
  float angle;
  
  public void init()
  {
    size = 6;
    setGravity(new Vector(0.01, random(PI*2), true));
    circleColor = color(int(255*sin((frameCount%200)/200.0*TWO_PI)), int(abs(getPosition().getX() - width/2)/width*2*255), int(abs(getPosition().getY() - height/2)/height*2*255));
    setLifeTimeLeft(1000);
  }
  
  public void update()
  {    
    float x = this.getPosition().getX();
    float y = this.getPosition().getY();
    if(x < 0)
    {
      instanceDestroy();
    }
    if(x > width)
    {
      instanceDestroy();
    }
    if(y < 0)
    {
      instanceDestroy();
    }
    if(y > height)
    {
      instanceDestroy();
    }
    size *= 1.004;
    angle = PI/4*sin((getLifeTime()%30)/30.0*TWO_PI) + PI/6;
  }
  
  public void trace()
  {
    noFill();
    stroke(circleColor);
    float x_wing = size*cos(angle);
    float y_wing = size*sin(angle);
    line(0, 0, x_wing, y_wing);
    line(0, 0, -x_wing, y_wing);
  }
}