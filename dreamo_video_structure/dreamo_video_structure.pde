float fps = 0;

void setup()
{
  //fullScreen(FX2D);
  size(800, 600, FX2D);
  frameRate(60);
  noSmooth();
  
  global_connection = new Connection( this );
  global_gsr = new Gsr();
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
     long initTimeT = System.nanoTime();
     
     println("");
     println("***************************************");
     println("*****************START*****************");
     println("");

   

   fps = frameRate;
   global_connection.update();
   
   long conT = System.nanoTime() - initTimeT;
    
   global_gsr.update();

   long gsrT = (System.nanoTime() - conT -initTimeT );
    
   global_stage.updateAndTrace();
   
   long viT = (System.nanoTime() - gsrT - conT -initTimeT) ;
   
  
  fill(120); // for the DEBUG text
  stroke(120); // for the DEBUG text
    if(frameCount%1 == 0) // print the DEBUG TEXT every 20 frames
  {
    global_gsr.printDebug();
  }
   text("particles: " + global_particlesCount + "; framerate: " + fps + " \n", 10, 20);
   
   
   long loopT = (System.nanoTime()  - initTimeT) ;
   
   
   println("    Connection update duration: "+ conT/1000 + " us");
   println("    GSR update duration: "+ gsrT/1000 + " us");
   println("    Video update duration: "+ viT/1000 + " us");
   println("");
   println("    LOOP duration: "+ loopT/1000 + " us");
   println("    MAX duration for framerate "+ int(frameRate) +": "+(1/frameRate*1000000)+" us");
   println("");
   println("*******************END*****************");
   println("***************************************");
   println("");

 
}

void mouseClicked()
{
  global_stage.nextScene();
}