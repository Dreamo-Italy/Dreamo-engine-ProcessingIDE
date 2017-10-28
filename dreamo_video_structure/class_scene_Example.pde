class Scene_Example extends Scene
{
 //Variabili
 float direction;
 float speed;
 float freq;
 
 //init
 public void init()
 {
  direction = 0;
  speed = 10;
  freq = 0;
  
  for ( int i = 0; i < 9; i ++) 
  {
   for (int j = 0; j < 16; j ++) 
   {
    int x = width/16 * j ;
    int y = height/9 * i  ;
    
    Particle_Example temp = new Particle_Example();
    temp.setPosition(new Vector2d(x , y , false));
    addParticle(temp);
   }
  }
  setBackground(new Background());
  enableBackground();
 }
 
 //update 
 public void update()
 {
  
  for(int i = 0; i < particlesNumber; i ++)
  {
   particlesList[i].updatePhysics();
   
   if(particlesList[i].getParameter(7) == 0) {freq = 1000;}
   else if(particlesList[i].getParameter(7) == 1) {freq = 2000;}
   else {freq = 3000;}
   
   if ( (i >= 0 & i <= 15) || (i >= 32 & i <= 47) || (i >= 64 & i <= 79) || (i >= 96 & i <= 112) || (i >= 128 & i <= 143))
   {
    if( particlesList[i].getParameter(3) != 3)
    {
     float posX = particlesList[i].getPosition().getX();
     direction = (float) (FastMath.sin(radians(2 * PI * freq * posX)));
     particlesList[i].getSpeed().setDirection(direction);
     particlesList[i].getSpeed().setModulus(speed * particlesList[i].getParameter(0));
    }
    else
    {
     particlesList[i].setParameter(5, 1200 / chooseVibrationFromAudio());
     particlesList[i].setParameter(6, 200 * chooseElasticityFromAudio());
     
     particlesList[i].getSpeed().setDirection(particlesList[i].getParameter(4));
     particlesList[i].getSpeed().setModulus(speed * particlesList[i].getParameter(0));
    }
   }
   else
   {
    if( particlesList[i].getParameter(3) != 3)
    {
     float posX = particlesList[i].getPosition().getX();
     direction = (float) (FastMath.cos(radians(2 * PI * freq * posX)));
     particlesList[i].getSpeed().setDirection(direction);
     particlesList[i].getSpeed().setModulus(-speed * particlesList[i].getParameter(0));
    }
    else
    {
     particlesList[i].setParameter(5, 1200 / chooseVibrationFromAudio());
     particlesList[i].setParameter(6, 200 * chooseElasticityFromAudio());
     
     particlesList[i].getSpeed().setDirection(particlesList[i].getParameter(4));
     particlesList[i].getSpeed().setModulus(speed * particlesList[i].getParameter(0));
    }
   }
   
   particlesList[i].update();
  }
 }

 //Eventuali altri metodi a seguire. 
 
}