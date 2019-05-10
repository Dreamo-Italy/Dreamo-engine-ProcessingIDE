class CaptureCamera extends Scene {
  private PApplet p;
  private Capture cam;
  private String[] cameras;
  private String camName;

  public CaptureCamera(PApplet _p, String cameraName) {
    this.p = _p;
    this.camName = cameraName;
    // cameras = Capture.list();
    // if (cameras == null) {
    //   println("Failed to retrieve the list of available cameras, will try the default...");
    //   cam = new Capture(p, 640, 480);
    // } else if (cameras.length == 0) {
    //   println("There are no cameras available for capture.");
    //   exit();
    // } else {
    //   println("Available cameras:");
    //   for (int i = 0; i < cameras.length; i++) {
    //     println(cameras[i]);
    //   }
    //   cam = new Capture(p, cameras[0]);
    //   cam.start();
    // }
  }

  public void init() {
    disableBackground();
    cam = new Capture(p, width, height, camName, global_fps);
    if (cam.available()) {
      cam.start();
    }
  }

  public void trace() {
    if (cam.available()) {
      cam.read();
    }
    set(0, 0, cam); //faster if not drawing on camera input
    // image(cam, 0, 0, width, height);
  }
}
