class GhostFaceMarker extends Particle {
  // color
  int indexShifting;
  boolean nextColor;
  //fading
  float opacity;
  final int INIT_OPACITY = 250;
  final int FINAL_OPACITY = 20;
  final int FADE_DURATION = 60; // ~= 2 seconds
  private boolean isFading;
  private int endFading;

 void init() {
   opacity = 255;
   indexShifting = 0;
   nextColor = false;
   isFading = false;
   endFading = 0;
 }

 void update() {
  //**** PARAMETERS FOR DIRECT INFLUENCE
  setParameter(0, audio_decisor.getInstantFeatures()[0]); //RMS istantaneo

  //**** COLORS
  if (nextColor && indexShifting < getPalette().COLOR_NUM) {indexShifting++; nextColor = false;}
  if (indexShifting >= getPalette().COLOR_NUM) indexShifting = 0;
  // **** OPACITY
  println("RMS: " + getParameter(0));
  // opacity = map(getParameter(0), 0, 0.8, 0, 255);
  println("opacity: " + opacity);
  }


 void trace() {
  noStroke();
  fill(getPalette().getColor(indexShifting), opacity);

  // eye left
  beginShape();
  vertex(719, 310);
  vertex(734, 310);
  vertex(733, 304);
  vertex(720, 304);
  endShape();
  // eye right
  beginShape();
  vertex(579, 307);
  vertex(564, 307);
  vertex(564, 299);
  vertex(579, 299);
  endShape();
  // ear right
  beginShape();
  vertex(469, 594);
  vertex(455, 592);
  vertex(480, 340);
  vertex(492, 343);
  endShape();
  // ear left
  beginShape();
  vertex(850, 601);
  vertex(833, 598);
  vertex(804, 346);
  vertex(813, 346);
  endShape();
 }

 public void fadeIn() {
   // if not already fading
   if (!isFading) {
     // set ending frames
     endFading = frameCount + FADE_DURATION;
     isFading = true; //now scene is fading
   } else {
     //continue fading
     if (frameCount <= endFading && opacity < INIT_OPACITY) {
       // fading not finished
       // increment opacity
       println("fading in");
        opacity += (INIT_OPACITY - FINAL_OPACITY) / FADE_DURATION;
      } else {
       // fading finished
       isFading = false;
     }
   }
 }

 public void fadeOut() {
   // if the scene is not already fading
   if (!isFading) {
     //setending frames
     endFading = frameCount + FADE_DURATION;
     isFading = true; //now scene is fading
   } else {
     //continue fading
     if (frameCount <= endFading && opacity > FINAL_OPACITY ) {
       // fading not finished
       // increment opacity
       println("fading out");
       opacity -= (INIT_OPACITY - FINAL_OPACITY) / FADE_DURATION;
     } else {
       // fading finished
       isFading = false;
     }
   }
 }
}
