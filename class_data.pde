//***********************************************************************************
// class Vector
// last modified: 21/08/16
//
// salva tutte le particelle, le scene e gli sfondi che vengono utilizzati
// !per ogni particella visualizzata sullo schermo è necessario salvare un oggetto
//
//***********************************************************************************

final int MAX_DATA_PARTICLES = 1000;
final int MAX_DATA_BACKGROUND = 10;
final int MAX_DATA_SCENES = 10;

class Data
{
  //PRIVATE MEMBERS
  private int particlesPointer;
  private Particle[] dataParticles;
  private int backgroundsPointer;
  private Background[] dataBackground;
  private int scenesPointer;
  private Scene[] dataScene;
  
  //CONSTRUCTORS
  public Data()
  {
    dataParticles = new Particle[MAX_DATA_PARTICLES];
    dataBackground = new Background[MAX_DATA_BACKGROUND];
    dataScene = new Scene[MAX_DATA_SCENES];
  }
  
  //PUBLIC METHODS
  //push/pop methods
}