class NoiseDot extends Particle
{
  color colore;
  int alpha;
  
  void init()
  {
    setLifeTimeLeft(10);
    alpha=100;
    setPersistence(true);
    //colore=pal.getColor();
  }
  
  void update()
  {
    //alpha=(int)(255*getParameter(0))+(int)(30*getParameter(0));
    alpha -= 255/10;
  }
  
  void trace()
  {
    noStroke();
    colore = color(colore, alpha);
    fill(colore);
    ellipse(-5, -5, 9, 9);
  }
  
  
 public void setColor(color c)
 {  
   colore=c;
 
 }
 
}