class ScenePlotter extends Scene
{
  
  void init()
  {
    PlotterGenerator temp = new PlotterGenerator();
    temp.setPosition(new Vector2d(0, 0, false));
    addParticle(temp);

    setBackground(new Background());
    enableBackground();
    
    sceneMood.setMood(-0.2,0.9);
  }


}
    