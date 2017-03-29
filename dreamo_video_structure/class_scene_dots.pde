class SceneDots extends Scene
{
  void init()
  {

    pal.initColors();

    DotGenerator generator = new DotGenerator();

    generator.setPalette(this.pal);
    generator.setPosition(new Vector2d(0, 0, false));
    
    //setVerticalReflection(true);
    
    addParticle(generator);
    Background bk = new Background();
    setBackground(bk);
    enableBackground();

    sceneMood.setMood(0,1);

  }
  
  
  //public void trace()
  //{
  //  if(sceneBackground != null && backgroundEnabled)
  //  {
  //    sceneBackground.trace();
  //  }

  //  for(int i = 0; i < particlesNumber; i++)
  //  {
  //    particlesList[i].beginTransformations();
  //    particlesList[i].trace();
  //    connectParticles(i,10);
  //    particlesList[i].endTransformations();
  //  }
  //}
  
  
}