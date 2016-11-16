float fps = 0;

void setup()
{
  fullScreen(FX2D);
  //size(600, 400);
  frameRate(60);
  noSmooth();
  global_activeScene = new Scene();
  
  
}

void draw()
{
  
  background(0);
  
  if(global_particlesCount == 0)
  {
    for(int i = 0; i< 10; i++)
    {
    BirdGenerator circGen = new BirdGenerator();
    circGen.setPosition(new Vector(width/2, height/2-50, false));
    circGen.setSpeed(new Vector(12, TWO_PI/10*i, true));
    global_activeScene.addParticle(circGen);}
  }
  
  global_activeScene.update();
  global_activeScene.trace();
  global_activeScene.trashDeadInstances();
  
  if(frameCount%20 == 0)
  {
    fps = frameRate;
  }
  text("particles: " + global_particlesCount + "; framerate: " + fps, 10, 20);
}