class StaticVideo extends Scene {
  private PApplet p;
  private Movie movie;
  private String moviePath;

  public StaticVideo(PApplet _p, String path) {
    this.p = _p;
    this.moviePath = path;
  }

  public void init() {
    //disablePhysics();
    // disableBackground();
    movie = new Movie(p, moviePath);
    movie.play();
    //movie.loop();
    movie.volume(0);
  }

  public void trace() {
    // sceneBackground.trace();
    image(movie, 0, 0, width, height);
  }
}
