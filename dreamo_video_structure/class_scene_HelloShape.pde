class HelloShape extends Scene
{
  private int index;
  private final int INTENSITY = 180;
  private final int SHAPE_NUM = 10;
  private int mode=0;
  
  HelloShape(int M)
  {
    mode=M;
  }
  
  public void init()
  {
    pal.initColors();
    index = 0;  
    
    if(mode==0)
    {
      for(int i=0;i<SHAPE_NUM;i++)
      {
        instantiatePolygon((int)i/10,INTENSITY);
      }
    }
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    sceneMood.setMood(0,1);
    
  }
  
  public void update()
  {
   
    if(mode==1)
    {
      if (index < SHAPE_NUM && frameCount % 60 == 0)
      {
      int mode = round( map(index, 0, SHAPE_NUM, 0, 6));
      instantiatePolygon(mode, INTENSITY);
      index++;   
      }
     /*
     else if(index >= SHAPE_NUM){
     disableBackground();
     if (global_dyn.getRMS() > 0.5d)
         enableBackground();
     }*/
    }
    
    
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