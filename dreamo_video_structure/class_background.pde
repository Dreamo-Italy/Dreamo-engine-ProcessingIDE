class Background 
{
 private color backgroundColor;

 public Background()  { backgroundColor = color(0); }
 
 public Background(color newBackgroundColor) { backgroundColor = newBackgroundColor; }
 
 public void trace() { background(backgroundColor); }
}