class GhostFace extends Scene {
  // markers
  GhostFaceMarker markers;
  GhostFaceStage stage;
  Hysteresis volumeControl;
  boolean plotMarkers;
  // dots
  int change_col_number;
  int change_col_idx;
  int changed;
  // floor
  final int FLOOR = 245;

  void init() {
   // palette
   pal = new Palette(int(random(5.6,8.6)));
   pal.initColors();
   // markers
   markers = new GhostFaceMarker();
   markers.setPalette(pal);
   addParticle(markers);
   stage = new GhostFaceStage();
   addParticle(stage);
   volumeControl = new Hysteresis(0.02, 0.08, 11);
   // dots
   final int row = 9; //10
   final int column = 10; //11
   change_col_number = 7; // Specify how many particles change color at the same time (1-particlesNumber)
   change_col_idx = change_col_number; // Leave as it is.
   changed = 0;

   for (int i = 0; i < column; i++) {
     for (int j = 0; j < row; j++) {
       int x = FastMath.round(width / column * (i + 1));
       int y = FastMath.round(height / row * (j + 1));
       GhostNoiseDot temp = new GhostNoiseDot();
       temp.setFloor(FLOOR);
       temp.setPalette(pal);
       temp.setPosition(new Vector2d(x, y, false));
       addParticle(temp);
      }
     }
     // background
     setBackground(new Background());
     enableBackground();
 }

 public void update() {
   // markers
   // check RMS
   plotMarkers = !volumeControl.checkWindow(audio_decisor.getInstantFeatures()[0]);
   if (plotMarkers) {
     boolean fadeColor = ((frameCount % 60) == 0);
     println("fade markers color: " + fadeColor);
     markers.fadeIn();
     markers.colorFadeTo(new Palette("warm"), 1, fadeColor);
     stage.fadeOut();
   } else {
     markers.fadeOut();
     stage.fadeIn();
   }
   //println("plot markers: " + plotMarkers);
   // noise dots
   colorFadeTo(new Palette(choosePaletteFromAudio()), 2, audio_decisor.getPaletteChange()); //choose warm or cold palette
   changed = 0;

   for (int i = 0; i < particlesNumber; i++) {
     particlesList[i].updatePhysics();
     particlesList[i].setParameter(2, 10 + 1.4 * chooseThicknessFromAudio());
     particlesList[i].setParameter(3, 1200 / chooseVibrationFromAudio());
     particlesList[i].setParameter(4, 200 * chooseElasticityFromAudio());
     if (!plotMarkers) {
       particlesList[i].setPalette(this.pal);
     }

     // Change the color of 'change_col_number' particles at a time
     if ((audio_decisor.getChangesNumber() > 0) && (frameCount % 5 == 0 )) {
       if ((i < change_col_idx) && (i >= change_col_idx - change_col_number)) {
            particlesList[i].toggleNextColor();
            changed++;
        }
        // if enough particles changed color already
        if (changed == change_col_number) {
          change_col_idx = change_col_idx + change_col_number;
          if (change_col_idx >= particlesNumber) {
            change_col_idx = change_col_number;
          }
        }
      }
      particlesList[i].update();
    }
  }

  public void trace() {
    // trace background
    if (sceneBackground != null && backgroundEnabled) {
      sceneBackground.trace();
    }
    // trace particles
    for (int i = 0; i < particlesNumber; i++) {
      particlesList[i].beginTransformations();
      particlesList[i].trace();
      particlesList[i].endTransformations();
    }
    // trace ground marker
    fill(getPalette().getColor(1));
    stroke(getPalette().getColor(1));
    rect(0, 0, 1280, FLOOR);

    // text(mouseX, width/2, height/2);
    // text(mouseY, width/2, height/2 + 50);
  }
}
