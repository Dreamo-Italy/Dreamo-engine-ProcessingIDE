class Particle_Example extends Particle
{
 //Variabili
 float posX;
 float posY;
 float rectSize;
 float distCoeff;
 
 float nCrossedX, nCrossedY;

 float noiseScale;
 float noiseStrength;
 
 float initDistX1;
 float initDistY1;
 float initDistX2;
 float initDistY2;
 float initDistX3;
 float initDistY3;
 float initDistX4;
 float initDistY4;
 
 int indexShifting;
 
 float transparency;
 

 //INIT
 public void init()
 {
  posX = 0;
  posY = 0;
  rectSize = 80;
  distCoeff = 0;
  
  nCrossedX = 0;
  nCrossedY = 0;
  
  noiseStrength = 1;
  noiseScale = 300;
  
  initDistX1 = int(random(-20,21));
  initDistY1 = int(random(-20,21));
  initDistX2 = int(random(-20,21));
  initDistY2 = int(random(-20,21));
  initDistX3 = int(random(-20,21));
  initDistY3 = int(random(-20,21));
  initDistX4 = int(random(-20,21));
  initDistY4 = int(random(-20,21));
  
  indexShifting = 0;
  transparency = 63;
  
 }
 
 //UPDATE 
 public void update()
 {
  setParameter(0, audio_decisor.getInstantFeatures()[0]); //RMS istantaneo
  setParameter(1, audio_decisor.getInstantFeatures()[10]); // Roughness istantaneo
  setParameter(2, audio_decisor.getStatusVector()[1]); // Dyn index status
  setParameter(3, audio_decisor.getStatusVector()[4]);// Rhythm str status;
  
  noiseScale = getParameter(5); // chooseVibration from audio
  noiseStrength = getParameter(6); // choose elasticity from audio
  setParameter( 4 , noise((getPosition().getX() + nCrossedX * width) / noiseScale, (getPosition().getY() + nCrossedY * height) / noiseScale) * noiseStrength ); //angolo movimento
  
  setParameter(7, audio_decisor.getStatusVector()[3]); //Spec complex
  setParameter(8, audio_decisor.getStatusVector()[7]); // EBF status
 
  //DIMENSIONE 
  if (global_rhythm.isEnergyOnset()) 
  { 
   if ( getParameter(2) == 0 ) { rectSize -= 1; } 
   else if (getParameter(2) == 1) { rectSize += (int(random(0,2) * 2 - 1)); }
   else { rectSize += 3; }
  }
  else if (rectSize > 125 || rectSize < 35 ) { rectSize = 80; }
  
  //DISTORSIONE LATI  / DISALLINEAMENTO VERTCI 
  distCoeff = getParameter(1) * 20; //20 si deve al fatto che la roughness controlla la dostorsione dell'immagine e quindi valori piccoli come quelli di getParam(1) devono essere amplificati per vederne un effetto sulla grafica.
  
  //COLORE 
  if (frameCount % 4 == 0 && indexShifting < getPalette().COLOR_NUM && FastMath.round(random(1)) == 1) indexShifting++;
  if (indexShifting >= getPalette().COLOR_NUM) indexShifting = 0;
  pal.influenceColors(0, mapForSaturation(getParameter(1), 0, 1), 0);
  
  if(getParameter(8) == 0) { transparency = 45; }
  else if(getParameter(8) == 1) { transparency = 127; }
  else { transparency = 191; }
  
  
  // KEEP THNGS INSIDE THE SCREEN 
  if(getParameter(3) != 3) { keepInsideTheScreen_1(); }
  else { keepInsideTheScreen_2(); }
 }
 
 //TRACE
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
  fill(pal.getColor(indexShifting), transparency);
  noStroke();
  beginShape();
   vertex(posX + initDistX1 + shiftX1 , posY + initDistY1 + shiftY1);
   vertex(posX + initDistX2 + rectSize + shiftX2, posY + initDistY2 + shiftY2);
   vertex(posX + initDistX3 + rectSize + shiftX3, posY + initDistY3 + rectSize + shiftY3);
   vertex(posX + initDistX4 + shiftX4, posY + initDistY4 + rectSize  + shiftY4);
  endShape();
 }
  
 void keepInsideTheScreen_1() 
 {
  if (getPosition().getX() > width) 
  {
   getPosition().setX(getPosition().getX() - width);
   nCrossedX++;
  }
  if (getPosition().getX() < 0) 
  {
   getPosition().setX(getPosition().getX() + width);
   nCrossedX--;
  } 
 }
 
 void keepInsideTheScreen_2() 
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