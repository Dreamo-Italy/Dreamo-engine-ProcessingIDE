class Scene_Example extends Scene
{
 //Variabili
 float angle = 0;
 float speed = 10;
 
 //init
 public void init()
 {
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
   if ( (i >= 0 & i <= 15) || (i >= 32 & i <= 47) || (i >= 64 & i <= 79) || (i >= 96 & i <= 112) || (i >= 128 & i <= 143))
   {
    float posX = particlesList[i].getPosition().getX();
    angle = sin(2 * PI * 500 * posX);
    particlesList[i].getSpeed().setDirection(angle);
    particlesList[i].getSpeed().setModulus(speed * particlesList[i].getParameter(0));
   }
   else
   {
    float posX = particlesList[i].getPosition().getX();
    angle =  cos(2 * PI * 500 * posX) ;
    particlesList[i].getSpeed().setDirection(angle);
    particlesList[i].getSpeed().setModulus(- speed * particlesList[i].getParameter(0));
   }
   particlesList[i].update();
  }
  
  
  
 }

 //Eventuali altri metodi a seguire. 
  
}