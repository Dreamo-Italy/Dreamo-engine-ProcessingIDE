class CycloParticle2 extends Particle
{
  
  float t=0;
  float x=0,y=0,z=0,k=0,xp=0, yp=0;
  int multi=0, i=0;
  float bg;
  int count=0; 
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
     
    
    x=100*cos(t/1000)+60*cos(t/100)+30*cos(t/50)+10*cos(t/5);
    y=100*sin(t/1000)+60*sin(t/100)+30*sin(t/50)+10*sin(t/5);
     
    if(global_ecg.BPM>60){
    k=100*sin(t/1000)+60*sin(t/900)+30*sin(t/700)+10*sin(t/600);
    
    }else k=0;
    
    if(global_ecg.BPM<60){
    z=-100*cos(t/1000+10)+60*cos(t/900+100)+30*cos(t/700)+10*cos(t/600);
    
    }else z=0;
     
     
     
  }
  
  public void trace()
  {
   setParameter(0,global_dyn.getRMS());
   setParameter(1,global_bioMood.getArousal());
   stroke(pal.getColor(3),getParameter(1)*100);
   for(int i=0;i<40;i=i+4){
      
     line((xp+i)+z,yp+k,(x+i)+z,y+k);

    }
     yp=x;
     xp=y;
  }
  
  //public void setMode(int m) {mode=m;}
}