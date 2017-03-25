class CycloParticle extends Particle
{
  
  float t=0;
  float x=0;
  float y=0;
  float xp=0;
  float yp=0;
  int multi=0;
  float bg;
  int count=0,j=0; 
  int initTime=0;
  float multi2=1;
  //int mode;

  public void init(){}
  
  public void update()
  {
      
    t=frameCount;
    if(t%5000==1)
    {
      multi=1;
    }
     else{multi=0;}
     
    
    x=(100*sin(2*3.174*t+10)+multi*10*cos(t));
    y=100*cos(2*3.174*t)+50*cos(4*3.174*t)+10*cos(8*3.174*t);
     
     
  }
  
  public void trace()
  {
 
    setParameter(0,global_ecg.getValue());
    setParameter(1,global_gsr.getValue());
    setParameter(2,global_dyn.getRMS());
    translate(width/2-100*cos(t/100)*noise(t/1000), height/2-noise(t/1000)*100*sin(t/100));
    stroke(pal.getColor());
    if(getParameter(0)<80 && getParameter(0)>60)
       j++;
    for(int i=10;i>0;i--)
    {
     rotate(t*0.005);
     //point(x+i,y+i);
     rotate(t/1000);
     line((xp-i+j)*getParameter(2)*10,(yp-i+j)*getParameter(2)*10,(x+j)*getParameter(2)*10,(y+j)*getParameter(2)*10);
     }
     yp=x;
     xp=y;
  }
  
  //public void setMode(int m) {mode=m;}
}