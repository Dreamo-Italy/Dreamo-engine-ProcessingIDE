class LineLine1 extends Scene{


  public void init(){
    
    pal.initColors(3);
    lineLine ln = new lineLine();
    ln.setPalette(pal);
    ln.disablePhysics();
    addParticle(ln);
  
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
  }

}