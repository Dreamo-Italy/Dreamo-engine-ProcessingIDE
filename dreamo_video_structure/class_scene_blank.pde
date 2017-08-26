class BlankScene extends Scene 
{
 void init() 
 {
  Background bk = new Background();
  setBackground(bk);
  enableBackground();
 }

 public void trace() 
 {
  sceneBackground.trace();
  noFill();
  strokeWeight(20);
  stroke(color(360, 10, 100));
  ellipse(width / 2, height / 2, 250, 250);
  fill(color(360, 10, 100));
  textSize(23);
  text("DREAMO", width / 2 - 46, height / 2 - 5);
  textSize(12);
  text("press N for the next graphic scene", width / 2 - 92, height / 2 + 20);
 }
}