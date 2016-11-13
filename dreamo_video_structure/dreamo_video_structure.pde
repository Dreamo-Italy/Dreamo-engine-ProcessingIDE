void setup()
{
  fullScreen();
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
    CircleGenerator circGen = new CircleGenerator();
    circGen.setPosition(new Vector(width/2, height/2-50, false));
    circGen.setSpeed(new Vector(12, 0, true));
    global_activeScene.addParticle(circGen);
  }
  
  global_activeScene.update();
  global_activeScene.trace();
  global_activeScene.trashDeadInstances();
  
  println("particles: " + global_particlesCount + "; framerate: " + frameRate);
}