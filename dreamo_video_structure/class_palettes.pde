class Palette 
{
  
 //********* CONSTANTS ***********
 
 private final int PALETTE_NUM = 10;
 private final int COLOR_NUM = 5;
 
 
 //********* TEMPORARY PALETTES***********
  private color[][] colorsInit= new color[PALETTE_NUM][COLOR_NUM];
  

 //********* PRIVATE MEMBERS ***********
  private int ID;
  private String name;
  private color[] colors = new color[COLOR_NUM];
  private boolean initialized=false;
  //private DSP dsp;

 
 //********* CONTRUCTORS ***********
 public Palette(){
 

  
 
 //first palette - ghiaccio
 colorsInit[0][0] = color(219,18,61);
 colorsInit[0][1] = color(217,47,82);
 colorsInit[0][2] = color(230,8,14);
 colorsInit[0][3] = color(194,8,42);
 colorsInit[0][4] = color(216,28,74);
 
 //second palette orange/blue
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
 
 
 //7 - savana
 colorsInit[4][0] = #130303;
 colorsInit[4][1] = #2D080A;
 colorsInit[4][2] = #7C3626;
 colorsInit[4][3] = #F5853F;
 colorsInit[4][4] = #FFCDBC;

 //8 - green-blue
 colorsInit[5][0] = #C4F1BE;
 colorsInit[5][1] = #A2C3A4;
 colorsInit[5][2] = #869D96;
 colorsInit[5][3] = #525B76;
 colorsInit[5][4] = #201E50;
 
 //9 - romania
 colorsInit[6][0] = #264653;
 colorsInit[6][1] = #2A9D8F;
 colorsInit[6][2] = #E9C46A;
 colorsInit[6][3] = #F4A261;
 colorsInit[6][4] = #E76F51;
 
 //10 - super gray
 colorsInit[7][0] = #D2D4C8;
 colorsInit[7][1] = #E0E2DB;
 colorsInit[7][2] = #B8BDB5;
 colorsInit[7][3] = #889696;
 colorsInit[7][4] = #5F7470;
 
 
 initialized=false;
 }
 
 
 public Palette(int i){
  
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
 
 //7 - savana
 colorsInit[6][0] = #130303;
 colorsInit[6][1] = #2D080A;
 colorsInit[6][2] = #7C3626;
 colorsInit[6][3] = #F5853F;
 colorsInit[6][4] = #FFCDBC;

 //8 - green-blue
 colorsInit[7][0] = #C4F1BE;
 colorsInit[7][1] = #A2C3A4;
 colorsInit[7][2] = #869D96;
 colorsInit[7][3] = #525B76;
 colorsInit[7][4] = #201E50;
 
 //9 - romania
 colorsInit[8][0] = #264653;
 colorsInit[8][1] = #2A9D8F;
 colorsInit[8][2] = #E9C46A;
 colorsInit[8][3] = #F4A261;
 colorsInit[8][4] = #E76F51;
 
 //10 - super gray
 colorsInit[9][0] = #D2D4C8;
 colorsInit[9][1] = #E0E2DB;
 colorsInit[9][2] = #B8BDB5;
 colorsInit[9][3] = #889696;
 colorsInit[9][4] = #5F7470;
 
 initColors(i);
 
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
     
     // initialized=true;
    
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
    println("ERROR: getColor: not initialized.");
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
      if (!initialized)
        println("ERROR: getColor: not initialized");
      else
        println("ERROR: getColor: index out of range.");
  
      return color(360,100,100);
      }
  }
  
  //return the darkest color in the Palette
  public color getDarkest()
  { 
    if(initialized)
    {
      float[] b= new float[COLOR_NUM];
      for(int i=0;i<COLOR_NUM;i++)
        {
          b[i]=brightness(colors[i]);
        }
      return colors[DSP.argmin(b)];
    }
    else
    {
      println("ERROR: getColor: not initialized.");
      return color(360,100,100);
    }
  }
  
  //return the lightest color in the Palette
  public color getLightest()
  {
    if(initialized)
    {
      float[] b= new float[COLOR_NUM];
      for(int i=0;i<COLOR_NUM;i++)
        {
          b[i]=brightness(colors[i]);
        }
      return colors[DSP.argmax(b)];
    }
    else
    {
      println("ERROR: getColor: not initialized.");
      return color(360,100,100);
    }
  }
  
  public int paletteSize()
  {
    return COLOR_NUM;
  }
  
  public int getID()
  {
    return ID;
  }
  
    //********* SET METHODS **********
  
  public void setColor(color c, int idx)
  {
    if(initialized && idx<COLOR_NUM && idx>=0){colors[idx]=c;}
  }
  
  public void setID(int i)
  {
    ID=i;
  }
  
}