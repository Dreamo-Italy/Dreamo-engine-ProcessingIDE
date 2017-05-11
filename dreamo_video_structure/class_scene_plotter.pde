class ScenePlotter extends Scene
{
  
  void init()
  {
    
    pal.initColors(2);
    
    PlotterGenerator newPlotter = new PlotterGenerator();
    
    newPlotter.setPalette(pal);
    newPlotter.setPosition(new Vector2d(0, 0, false));
    addParticle(newPlotter);


    setBackground(new Background());
    enableBackground();
    
    sceneMood.setMood(-0.2,0.9);
  }


}
    