class NoiseDot extends Particle
{
 float speed;
 float dotW;
 float dotH;
 float noiseScale;
 float noiseStrength;
 float angle;
 float sizeShiftPace;
 float nCrossedX, nCrossedY;
 int indexShifting;
 boolean nextColor;
 float opacity;

 void init()
 {
  opacity = 255;
  speed = 10;
  dotW = 9;
  dotH = 9;
  noiseStrength = 1;
  noiseScale = 300;
  nCrossedX = 0;
  nCrossedY = 0;
  indexShifting = 0;
  nextColor = false;
  sizeShiftPace = 0.05 ; //0 to 1; 0 never changes size; 1 changes immediately.
  getPalette().getNextColor(); // TRYING TO IMPLEMENT RANDOM COLOR AT THE BEGGINING
 }

 void update()
 {
  //**** PARAMETERS FOR DIRECT INFLUENCE
  setParameter(0, audio_decisor.getInstantFeatures()[0]); //RMS istantaneo
  setParameter(1, audio_decisor.getFeaturesVector()[0]); //RMS mediato (2 sec)

  //**** PARAMETERS FROM SCENE DECISIONS
  // dotW = getParameter(2);
  // dotH = getParameter(2);
  dotW = gradualShift(dotW, getParameter(2), sizeShiftPace);
  dotH = dotW;
  noiseScale = getParameter(3);
  noiseStrength = getParameter(4);

  //if (frameCount % 4 == 0 && indexShifting < getPalette().COLOR_NUM && FastMath.round(random(1)) == 1) indexShifting++;
  if (nextColor && indexShifting < getPalette().COLOR_NUM) {indexShifting++; nextColor = false;}
  if (indexShifting >= getPalette().COLOR_NUM) indexShifting = 0;

  angle = noise((getPosition().getX() + nCrossedX * width) / noiseScale, (getPosition().getY() + nCrossedY * height) / noiseScale) * noiseStrength;
  getSpeed().setDirection(angle);
  getSpeed().setModulus(speed * getParameter(0));

  opacity = map(getParameter(1), 0, 0.5, 10, 250);

  pal.influenceColors(0, mapForSaturation(getParameter(1), 0, 1), 0);

  keepInsideTheScreen();
 }

 public float getAngle()
 {
  return angle;
 }

 void trace()
 {

  noStroke();
  // fill(getPalette().getColor(indexShifting));
  fill(getPalette().getColor(indexShifting), opacity);
  ellipse(-5, -5, dotW, dotH);
  strokeWeight(1);
  connectParticles(50,10);

 }

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
 void toggleNextColor()
  { nextColor = !nextColor;}
}
