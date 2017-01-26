class HelloShape extends Scene{
  
    void init()
  {

    pal.initColors();

    for(int i=0;i<40;i++){
    
    HShape sh = new HShape((int)(i/10+1));  
    sh.setPalette(this.pal);
    sh.setPosition(new Vector2d(width/2, height/2, false));   
    addParticle(sh);
   
    }
    
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    sceneMood.setMood(0,1);

  }
  
}