class Particle_Example extends Particle
{
 //Variabili
 float posX;
 float posY;
 float rectSize;
 float distCoeff;
 
 float noiseScale;
 float noiseStrength;
 float nCrossedX, nCrossedY;
 float angle;
 float speed;
 
 float initDistX1;
 float initDistY1;
 float initDistX2;
 float initDistY2;
 float initDistX3;
 float initDistY3;
 float initDistX4;
 float initDistY4;

 //init
 public void init()
 {
  posX = 0;
  posY = 0;
  rectSize = 80;
  distCoeff = 0;
  
  noiseStrength = 1;
  noiseScale = 300;
  nCrossedX = 0;
  nCrossedY = 0;
  angle = 0;
  speed = 10;
  
  initDistX1 = int(random(-20,21));
  initDistY1 = int(random(-20,21));
  initDistX2 = int(random(-20,21));
  initDistY2 = int(random(-20,21));
  initDistX3 = int(random(-20,21));
  initDistY3 = int(random(-20,21));
  initDistX4 = int(random(-20,21));
  initDistY4 = int(random(-20,21));
 }
 
 //update 
 public void update()
 {
  setParameter(0, audio_decisor.getInstantFeatures()[0]); //RMS istantaneo
  setParameter(1, audio_decisor.getInstantFeatures()[10]); // Roughness istantaneo
  setParameter(2, audio_decisor.getStatusVector()[1]); // Dyn index status
  
  //dimensione 
  if (global_rhythm.isEnergyOnset()) 
  { 
   if(getParameter(2) == 0) {rectSize -= 1;} 
   else if (getParameter(2) == 1) {rectSize += (int(random(0,2) * 2 - 1));}
   else if (getParameter(2) == 3 ) { rectSize += 3;}
  }
  else if (rectSize > 125 || rectSize < 35 ) {rectSize = 80; }
  
  //distorsione lati / disallineamento vertici
  distCoeff = getParameter(1) * 15; //15 si deve al fatto che la roughness controlla la dostorsione dell'immagine e quindi valori piccoli come quelli di getParam(1) devono essere amplificati per vederne un effetto sulla grafica.
 
  keepInsideTheScreen();
 }
 //trace 
 public void trace()
 {
  
  float shiftX1 = distCoeff * (int(random(0,2) * 2 - 1));  
  float shiftY1 = distCoeff * (int(random(0,2) * 2 - 1));
  float shiftX2 = distCoeff * (int(random(0,2) * 2 - 1));
  float shiftY2 = distCoeff * (int(random(0,2) * 2 - 1));
  float shiftX3 = distCoeff * (int(random(0,2) * 2 - 1));
  float shiftY3 = distCoeff * (int(random(0,2) * 2 - 1));
  float shiftX4 = distCoeff * (int(random(0,2) * 2 - 1));
  float shiftY4 = distCoeff * (int(random(0,2) * 2 - 1));
  
  
  colorMode(HSB, 360, 100, 100, 100);
  fill(99,100,64,60);
  noStroke();
  beginShape();
   vertex(posX + initDistX1 + shiftX1 , posY + initDistY1 + shiftY1);
   vertex(posX + initDistX2 + rectSize + shiftX2, posY + initDistY2 + shiftY2);
   vertex(posX + initDistX3 + rectSize + shiftX3, posY + initDistY3 + rectSize + shiftY3);
   vertex(posX + initDistX4 + shiftX4, posY + initDistY4 + rectSize  + shiftY4);
  endShape();
 }
 
 //eventuali altri metodi a seguire , ad esempio get / set  
 void keepInsideTheScreen() 
 {
  if (getPosition().getX() > width) 
  {
   getPosition().setX(getPosition().getX() - width);
   nCrossedX++;
  }
  if (getPosition().getY() > height) 
  {
   getPosition().setY(getPosition().getY() - height);
   nCrossedY++;
  }
  if (getPosition().getX() < 0) 
  {
   getPosition().setX(getPosition().getX() + width);
   nCrossedX--;
  }
  if (getPosition().getY() < 0) 
  {
   getPosition().setY(getPosition().getY() + height);
   nCrossedY--;
  }
 }
}