class SceneDynamicGrid extends Scene
{
  void init()
  {
    addParticle(new GridPlotter());
    setBackground(new Background());
    enableBackground();
    
    sceneMood.setMood(-0.8,0.6);
    
  }
}