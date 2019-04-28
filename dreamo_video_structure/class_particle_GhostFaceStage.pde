class GhostFaceStage extends Particle {
  // color
  int indexShifting;
  boolean nextColor;
  //fading
  float opacity;
  final int INIT_OPACITY = 40;
  final int FINAL_OPACITY = 5;
  final int FADE_DURATION = 90; // ~= 3 seconds
  private boolean isFading;
  private int endFading;

 void init() {
   opacity = 5;
   indexShifting = 0;
   nextColor = false;
   isFading = false;
   endFading = 0;
 }

 void update() {

 }

 void trace() {
  noStroke();
  fill(#fffce6, opacity);
  ellipse(650, 450, 410, 490);
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
       println("stage fading in");
        opacity += (float)(INIT_OPACITY - FINAL_OPACITY) / FADE_DURATION;
      } else {
       // fading finished
       isFading = false;
       println("stage final opacity: " + opacity);
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
       opacity -= (float)(INIT_OPACITY - FINAL_OPACITY) / FADE_DURATION;
     } else {
       // fading finished
       isFading = false;
     }
   }
 }
}
