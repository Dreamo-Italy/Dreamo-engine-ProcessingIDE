class SceneFireworks extends Scene
{
  void init()
  {
    pal.initColors();
    LineGenerator generator = new LineGenerator();
    generator.setPalette(pal);
    addParticle(generator);
    
    setHorizontalReflection(true);

    generator.setPosition(new Vector2d(width/2, height/2, false));
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    
    sceneMood.setMood(0.5,0.1);
  }
}