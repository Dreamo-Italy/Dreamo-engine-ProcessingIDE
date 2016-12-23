class NoiseDot extends Particle
{
  color colore;
  int alfa;
  
  void init()
  {
    setLifeTimeLeft(10);
    alfa = 255;
    setPersistence(true);
  }
  
  void update()
  {
    alfa -= 255/10;
  }
  
  void trace()
  {
    noStroke();
    colore = color(255, alfa);
    fill(colore);
    ellipse(-5, -5, 10, 10);
  }
}