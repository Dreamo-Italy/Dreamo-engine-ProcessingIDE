class ScenePlotter extends Scene
{
  
  void init()
  {
    PlotterGenerator temp = new PlotterGenerator();
    temp.setPosition(new Vector2d(width/2, height/2, false));
    addParticle(temp);

    setBackground(new Background());
    enableBackground();
    
    setParameter(0, -200.0);
    setParameter(1, -1.0);
    setParameter(2, -4.0);
  }


}
    