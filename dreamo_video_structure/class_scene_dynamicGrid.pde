class SceneDynamicGrid extends Scene
{
  void init()
  {
    addParticle(new GridPlotter());
    setBackground(new Background());
    enableBackground();
    
    setParameter(0, 0.0);
    setParameter(1, 120.0);
    setParameter(2, -20.0);
  }
}