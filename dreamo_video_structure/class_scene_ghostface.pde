class GhostFace extends Scene
{
  void init()
  {
    Background bk = new Background();
    setBackground(bk);
    enableBackground();
    pal.initColors();
  }

  public void trace()
  {
    sceneBackground.trace();
    noFill();
    fill(pal.getColor(1));
    stroke(pal.getColor(1));
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
    // ground
    rect(0, 0, 1280, 234);
    // text(mouseX, width / 2 - 92, height / 2 + 20);
    // text(mouseY, width / 2 - 92, height / 2 + 70);
  }

}
