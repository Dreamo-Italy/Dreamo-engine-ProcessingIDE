class BlackScene extends Scene
{
  void init()
  {
    Background bk = new Background();
    setBackground(bk);
    enableBackground();    
  }  
  
  public void trace()
  {
    sceneBackground.trace();
    noFill();
  }
  
}