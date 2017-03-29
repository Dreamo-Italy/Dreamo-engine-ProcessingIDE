class CycloParticle extends Particle
{
  
  float t=0;
  float x=0;
  float y=0;
  float xp=0, xt=0;
  float yp=0, yt=0;
  int multi=0;
  float bg;
  int count=0,j=0; 
  int initTime=0;
  float multi2=1;
  //int mode;

  public void init(){
    
  }
  
  public void update()
  {
    if(getParameter(0)<80 && getParameter(0)>60) {
     xt=0;
    yt=0;
    } 
    if(getParameter(0)>80){
    
   
    xt=50*(-cos(3.174*t+3)-sin(t*10));
    yt=50*(-sin(3.174*t+3))+40*sin(8*3.174*t+3);
      
    }
    if(getParameter(0)<60){
    xt=50*cos(2*3.174*t)+20*sin(2*3.174*t+10);
    yt=(10*cos(2*3.174*t)-10*sin(2*3.174*t))/2;
    }
    
    t=frameCount;
    if(t%5000==1)
    {
      multi=1;
    }
     else{multi=0;}
     
    
    x=(2*(100*sin(2*3.174*t+10)+multi*10*cos(t))+xt*getParameter(4));
    y=2*(100*cos(2*3.174*t)+100*cos(4*3.174*t)+10*cos(8*3.174*t)+yt*getParameter(4));
     
     
  }
  
  public void trace()
  {
    setParameter(0,global_ecg.getBpm());
    setParameter(1,global_ecg.getValue());
    setParameter(2,global_dyn.getRMS());
    setParameter(3,global_gsr.getValue());
    setParameter(4,global_ecg.getEmotionPar());
    translate(width/2-(100*cos(t*0.001)), height/2-100*sin(t*0.001));
    stroke(pal.getColor());
  
    
    for(int i=10;i>0;i--)
    {
     rotate(t*0.005);
     //point(x+i,y+i);
     rotate(t/1000);
     line((xp-i)*getParameter(2)*10,(yp-i)*getParameter(2)*10,(x)*getParameter(2)*10,(y)*getParameter(2)*10);
     }
     yp=x;
     xp=y;
  }
  
  //public void setMode(int m) {mode=m;}
}