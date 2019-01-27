class GhostFace extends Scene {

  GhostFaceMarker markers;
  Hysteresis volumeControl;
  boolean plotMarkers;

  void init() {
    getPalette().initColors("warm");
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    markers = new GhostFaceMarker();
    addParticle(markers);
    volumeControl = new Hysteresis(0.02, 0.08, 11);
  }

  public void update() {
    // check RMS
    // plotMarkers = !volumeControl.checkWindow(audio_decisor.getFeaturesVector()[0]);
    plotMarkers = !volumeControl.checkWindow(audio_decisor.getInstantFeatures()[0]);
    if (plotMarkers) {
      markers.fadeIn();
    } else {
      markers.fadeOut();
    }
    println("plot markers: " + plotMarkers);
    // update particles
    for(int i = 0; i < particlesNumber; i++) {
      particlesList[i].setPalette(getPalette());
      particlesList[i].update();
    }
    // text(mouseX, width / 2 - 92, height / 2 + 20);
    // text(mouseY, width / 2 - 92, height / 2 + 70);
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
    rect(0, 0, 1280, 234);
  }
}
