class lineLine extends Particle{
   float t=0,x=0,y=0;
   color myColor, myColor2;
   int alpha=100;
  public void init(){
  myColor =  pal.getColor();  
  myColor2 =  pal.getColor(); 
    setPersistence(true);
  
  }
  public void update(){
   alpha = getFadingAlpha();
    
    t=frameCount; 
   x=cos((t/100));
   y=sin((t/100));
   
     if(getSceneChanged() && !this.isDestroying() )
    {
      assertDestroying();
      setLifeTimeLeft(30);
    } 
   
  }
  public void trace(){
    
  setParameter(0, global_dyn.getRMS());
  setParameter(1, global_bioMood.getArousal());
  setParameter(2, global_ecg.getBpm());
  translate(width/2,height/2);
 
  
  stroke(myColor,alpha*sqrt(getParameter(1)));
  for(int i=0; i<getParameter(2);i=i+2){

  line((-width/2)*y,(-50)*x,width/2*y,(-50+i)*x*getParameter(0)*100);
  }
  stroke(myColor2,alpha*sqrt(getParameter(1)));
  
  for(int i=0; i<getParameter(2);i=i+2){ 
  line(width/2*x,(-50)*y,width/2*y,(-50+i)*x*getParameter(0)*100);
  }
  
  // stroke(pal.getColor(3));
  //for(int i=0; i<100;i=i+4){
  // noFill();
  //  bezier((-width/2)*global_dyn.getRMS()*y,(-50)*x,i*x,-i*y,+i*y,-i+x,width/2*global_dyn.getRMS()*x,(-50)*y);
  //}
  //for(int i=0; i<100;i=i+4){
  //bezier(width/2*global_dyn.getRMS()*x,(-50)*y,width/2*global_dyn.getRMS()*y,(-50+i)*x,width/2*global_dyn.getRMS()*y,(-50+i)*x,(-width/2)*global_dyn.getRMS()*y,(-50)*x);
  //}
   noFill();
  //for(int i=0;i<360;i=i+2){
  //   stroke(pal.getColor()); 
  //  bezier(0,0,100*x,100*y,200*x,200*y,300*cos(i),300*sin(i));
  // }
  
}}