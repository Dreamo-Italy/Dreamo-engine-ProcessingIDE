class NoiseDot extends Particle
{
  color colore;
  int alpha;
  
  void init()
  {
    setLifeTimeLeft(10);
    alpha = 255;
    setPersistence(true);
  }
  
  void update()
  {
    alpha -= 255/10;
  }
  
  void trace()
  {
    noStroke();
    colore = color(255, alpha);
    fill(colore);
    ellipse(-5, -5, 10, 10);
  }
  
    @Override
  public void setAlpha(int newAlfa)
  {
    alpha=newAlfa;
  }
 
}