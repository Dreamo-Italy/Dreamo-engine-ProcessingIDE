class SceneFireworks extends Scene
{
  void init()
  {
    LineGenerator generator = new LineGenerator();
    addParticle(generator);
    generator.setPosition(new Vector2d(width/2, height/2, false));
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    
    setParameter(0, 200.0);
    setParameter(1, 300.0);
    setParameter(2, 400.0);
  }
}