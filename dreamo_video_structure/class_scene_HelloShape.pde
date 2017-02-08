class HelloShape extends Scene
{
  int index, intensity;
  final int SHAPE_NUM = 14;
  
  void init()
  {
    pal.initColors();
    index = 0;  
    intensity = 20;
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    sceneMood.setMood(0,1);
    
  }
  
  public void update()
  {
    if (index < SHAPE_NUM && frameCount % 60 == 0){
      int mode = round( map(index, 0, SHAPE_NUM, 0, 6));
      instantiatePolygon(mode, intensity);
      index++;   
    } 
    /*else if(index >= SHAPE_NUM){
     disableBackground();
     if (global_dyn.getRMS() > 0.5d)
         enableBackground();
     }*/
    
    for(int i = 0; i < particlesNumber; i++){
      particlesList[i].updatePhysics();
      particlesList[i].setParameter(0,global_dyn.getRMS());
      particlesList[i].update();
       }
     
     
   
  }
  
  private void instantiatePolygon(int mode, int intensity)
  {
    HShape sh = new HShape(mode,intensity); 
    sh.disablePhysics();
    sh.setPalette(this.pal);
    addParticle(sh);  
  }
}