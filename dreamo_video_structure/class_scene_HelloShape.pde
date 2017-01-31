class HelloShape extends Scene{
  
    void init()
  {

    pal.initColors();

    for(int i=0;i<1;i++){
    
    HShape sh = new HShape((int)(i/10),60); 
    //HShape sh = new HShape(6); 
    sh.setPalette(this.pal);
    //sh.setPosition(new Vector2d(width/2, height/2, false));   
    addParticle(sh);
   
    }
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    sceneMood.setMood(0,1);

  }
  
   public void update()
   {
     
   for(int i = 0; i < particlesNumber; i++)
     {
       particlesList[i].updatePhysics();
       particlesList[i].setParameter(0,global_dyn.getRMS());
       particlesList[i].update();
   }
  }
  
}