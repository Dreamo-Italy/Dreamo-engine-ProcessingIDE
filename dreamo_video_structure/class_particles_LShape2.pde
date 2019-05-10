class LShape2 extends Particle
{

// ------ initial parameters and declarations ------

  float lineWeight = 11;
float lineAlpha = 100;
float lineAlphaWeight = 1;

  float saturation;
  float brightness;
  boolean invertHue = false;

  float randomOffset;

  color myColor;
  float hue;

  public void init()
  {

    setPersistence(true);

    setColorIndex((int)random(0,5));
    myColor = pal.getColor(getColorIndex());
    hue = hue(myColor);
    saturation = saturation(myColor);
    brightness = brightness(myColor);

   }
 //<>// //<>//
  public void update()
  {
    //update color if palette is changed
    myColor = pal.getColor(getColorIndex());
    hue = hue(myColor); //<>// //<>//
     //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//


    if(getSceneChanged() && !this.isDestroying() )
    {
      assertDestroying();
      setLifeTimeLeft(60);
    }
    else if( this.isDestroying() )
    {
      lineAlphaWeight -= 1.0/50.0;
    }

  }

  public void trace()
  {
    strokeWeight(lineWeight);
    stroke(0, lineAlpha);
    strokeCap(ROUND);
    noFill();
  }//Trace() END


}
