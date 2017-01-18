
class Palette {
  
 //********* CONSTANTS ***********
 
 private final int PALETTE_NUM = 6;
 private final int COLOR_NUM = 5;
 
 
 //********* TEMPORARY PALETTES (only for initial development) ***********
  private color[][] colorsInit= new color[PALETTE_NUM][COLOR_NUM];
  

 //********* PRIVATE MEMBERS ***********
private int ID;
private String name;
private color[] colors = new color[COLOR_NUM];
private boolean initialized=false;

 
 //********* CONTRUCTORS ***********
 public Palette(){
 
 colorMode(HSB, 360, 100, 100);
 //first palette - ghiaccio
 colorsInit[0][0] = color(219,18,61);
 colorsInit[0][1] = color(217,47,82);
 colorsInit[0][2] = color(230,8,14);
 colorsInit[0][3] = color(194,8,42);
 colorsInit[0][4] = color(216,28,74);
 
 //second palette
 colorsInit[1][0] = color(204, 100, 47);
 colorsInit[1][1] = color(0, 100, 64);
 colorsInit[1][2] = color(28, 100, 100);
 colorsInit[1][3] = color(42, 41, 94);
 colorsInit[1][4] = color(182, 100, 71);
 
 //third palette
 colorsInit[2][0] = color(152, 48, 100);
 colorsInit[2][1] = color(180, 64, 45);
 colorsInit[2][2] = color(18, 68, 100);
 colorsInit[2][3] = color(0, 0, 90);
 colorsInit[2][4] = color(240, 2, 23);
 
 //fourth palette - carpentiere
 colorsInit[3][0] = color(44, 16, 76);
 colorsInit[3][1] = color(39, 41, 81);
 colorsInit[3][2] = color(240, 3, 94);
 colorsInit[3][3] = color(295, 13, 82);
 colorsInit[3][4] = color(342, 6, 39);
 
 //fifth palette - focolare
 colorsInit[4][0] = color(9, 93, 61);
 colorsInit[4][1] = color(20, 100, 60);
 colorsInit[4][2] = color(12, 74, 54);
 colorsInit[4][3] = color(4, 79, 54);
 colorsInit[4][4] = color(120, 9, 89);
 
 //sixth palette - giallo
 colorsInit[5][0] = #db8300;
 colorsInit[5][1] = #eaa001;
 colorsInit[5][2] = #f9c700;
 colorsInit[5][3] = #ffe11d;
 colorsInit[5][4] = #030300;
 
 
 initialized=false;
 }
   
 
 //********* PUBLIC METHODS ***********
 
 //set methods
  public void initColors()
  {       
    int r = (int)random(PALETTE_NUM);
    for(int i=0;i<COLOR_NUM;i++){
       colors[i]=colorsInit[r][i];
     }
     ID=r;
     name="random";
     
     initialized=true;
  }
  
  public void initColors(int idx)
  {
     for(int i=0;i<COLOR_NUM;i++){
       colors[i]=colorsInit[idx][i];
      }
     ID=idx;
     name="idx";
     
     initialized=true;
    
  }
  
    public void initColors(String name)
  {
     //confronta nome palette con "name"
     
     initialized=true;
    
  }
  
  
  //get methods
  //random color
    public color getColor()
  {
    int r = (int)random(COLOR_NUM);
    if(initialized){
      return colors[r];   
    }
    
  else{
    println("ERROR");
    return color(360,100,100);
    }
  }
  
  //color idx
  public color getColor(int idx)
  {
    
    if(initialized && idx<COLOR_NUM && idx>=0){
      return colors[idx];   
    }
    
  else{
    println("ERROR");
    return color(360,100,100);
    }
  }
  

  
}