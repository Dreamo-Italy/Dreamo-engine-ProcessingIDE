//test class
class Circle extends Particle
{  
  color circleColor;
  float size;
  public void init()
  {
    size = 4;
    setGravity(new Vector(0.01, random(PI*2), true));
    circleColor = color(int(255*sin((frameCount%200)/200.0*2*PI)), int(abs(getPosition().getX() - width/2)/width*2*255), int(abs(getPosition().getY() - height/2)/height*2*255));
    setLifeTime(1000);
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
    size *= 1.01;
    setRotation(getRotation()+PI/30);
  }
  
  public void trace()
  {
    noFill();
    stroke(circleColor);
    ellipse(0, 0, size, size);
    ellipse(0, 0, 4, 4);
    line(2, 0, size/2, 0);
    line(0, 2, 0, size/2);
  }
}