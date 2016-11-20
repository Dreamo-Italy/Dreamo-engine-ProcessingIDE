float fps = 0;

void setup()
{
  //fullScreen(FX2D);
  size(800, 600, FX2D);
  frameRate(60);
  noSmooth();
  global_stage = new Stage();
  
  Background bk1 = new Background(color(0));
  Scene scene1 = new Scene();
  for(int i = 0; i < 5; i++)
  {
    LineGenerator tempLine = new LineGenerator();
    Vector2d tempPos = new Vector2d(width/2, height/2, false);
    tempPos = tempPos.sum(new Vector2d(200, TWO_PI/5*i, true));
    tempLine.setPosition(tempPos);
    scene1.addParticle(tempLine);
  }
  scene1.setBackground(bk1);
  scene1.enableBackground();
  
  Scene scene2 = new Scene();
  for(int i = 0; i < 5; i++)
  {
    DotGenerator tempDot = new DotGenerator();
    scene2.addParticle(tempDot);
  }
  scene2.setBackground(bk1);
  scene2.enableBackground();
  
  global_stage.addScene(scene1);
  global_stage.addScene(scene2);
}

void draw()
{
  global_stage.updateAndTrace();
  
  fill(255);
  stroke(255);
  if(frameCount%20 == 0)
  {
    fps = frameRate;
  }
  text("particles: " + global_particlesCount + "; framerate: " + fps, 10, 20);
}

void mouseClicked()
{
  global_stage.nextScene();
}