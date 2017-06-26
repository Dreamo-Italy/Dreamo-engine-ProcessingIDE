class Palette 
{

  //********* CONSTANTS ***********

  private final int MAX_PALETTE_NUM = 10;
  private final int COLOR_NUM = 5;

  private final int COLD_PALETTES = 5;
  private final int WARM_PALETTES = 5;

  //********* TEMPORARY PALETTES***********
  private color[][] colorsInit= new color[MAX_PALETTE_NUM][COLOR_NUM];


  //********* PRIVATE MEMBERS ***********
  private int ID;
  private int index;
  private String name;
  private color[] colors = new color[COLOR_NUM];
  private boolean initialized=false;
  //private DSP dsp;

  private float[] hues;
  private float[] saturations;
  private float[] brightnesses;

  //********* CONTRUCTORS ***********
  public Palette() {


    hues=new float[COLOR_NUM];
    saturations=new float[COLOR_NUM];
    brightnesses=new float[COLOR_NUM];

    loadColors();

    initialized=false;
  }


  public Palette(int i)
  {
    hues=new float[COLOR_NUM];
    saturations=new float[COLOR_NUM];
    brightnesses=new float[COLOR_NUM];

    loadColors();  

    if(i>=MAX_PALETTE_NUM){println("WE ONLY HAVE"+MAX_PALETTE_NUM+"PALETTES");}
    
    else{initColors(i);}
  }
  
  
  public Palette(String type)
  {
    hues=new float[COLOR_NUM];
    saturations=new float[COLOR_NUM];
    brightnesses=new float[COLOR_NUM];
      
    loadColors(); 
    
    initColors(type);    
    
  }





  //********* PUBLIC METHODS ***********

  //set methods
  public void initColors()
  {       
    int r = (int)random(colorsInit.length);
    
    for (int i=0; i<COLOR_NUM; i++) {
      colors[i]=colorsInit[r][i];

      hues[i]=hue(colors[i]);
      saturations[i]=saturation(colors[i]);
      brightnesses[i]=brightness(colors[i]);
    }
       
    ID=r;
    name="random";
    initialized=true;
  }

  public void initColors(int idx)
  {
    for (int i=0; i<COLOR_NUM; i++) {
      colors[i]=colorsInit[idx][i];

      hues[i]=hue(colors[i]);
      saturations[i]=saturation(colors[i]);
      brightnesses[i]=brightness(colors[i]);
    }
    ID=idx;
    name="idx";

    initialized=true;
  }

  public void initColors(String type)
  {
    if(type.equals("cold"))
    {
      int r = (int)random(COLD_PALETTES);
    
      for (int i=0; i<COLOR_NUM; i++) {
      colors[i]=colorsInit[r][i];

      hues[i]=hue(colors[i]);
      saturations[i]=saturation(colors[i]);
      brightnesses[i]=brightness(colors[i]);
    }
       
    ID=r;
    name="cold";
    initialized=true;
    }
    
    else if (type.equals("warm"))
    {
      int r = (int)random(COLD_PALETTES,WARM_PALETTES+COLD_PALETTES);
    
      for (int i=0; i<COLOR_NUM; i++) {
      colors[i]=colorsInit[r][i];

      hues[i]=hue(colors[i]);
      saturations[i]=saturation(colors[i]);
      brightnesses[i]=brightness(colors[i]);
    }
       
    ID=r;
    name="warm";
    initialized=true;
    }
    
  }


  //get methods
  
  public int getColorsNumber()
  {
    return COLOR_NUM; 
  }
  
  //random color
  public color getColor()
  {
    int r = (int)random(COLOR_NUM);
    if (initialized) {
      return colors[r];
    } else {
      println("ERROR: getColor: not initialized.");
      return color(360, 100, 100);
    }
  }

  public color getNextColor()
  {
    if (index<COLOR_NUM-1) index++;
    else index = 0;   
    return colors[index++];
  }

  //color idx
  public color getColor(int idx)
  {

    if (initialized && idx<COLOR_NUM && idx>=0) {
      return colors[idx];
    } else {
      if (!initialized)
        println("ERROR: getColor: not initialized");
      else
        println("ERROR: getColor: index out of range.");

      return color(360, 100, 100);
    }
  }

  //return the darkest color in the Palette
  public color getDarkest()
  { 
    if (initialized)
    {
      float[] b= new float[COLOR_NUM];
      for (int i=0; i<COLOR_NUM; i++)
      {
        b[i]=brightness(colors[i]);
      }
      return colors[DSP.argmin(b)];
    } else
    {
      println("ERROR: getColor: not initialized.");
      return color(360, 100, 100);
    }
  }

  //return the lightest color in the Palette
  public color getLightest()
  {
    if (initialized)
    {
      float[] b= new float[COLOR_NUM];
      for (int i=0; i<COLOR_NUM; i++)
      {
        b[i]=brightness(colors[i]);
      }
      return colors[DSP.argmax(b)];
    } else
    {
      println("ERROR: getColor: not initialized.");
      return color(360, 100, 100);
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
    if (initialized && idx<COLOR_NUM && idx>=0) {
      colors[idx]=c;
    }
  }

  public void setID(int i)
  {
    ID=i;
  }



  public void influenceColors(float h, float s, float b)
  {
    //create a new color with the same H and S buu with a new B
    color newColor;

    for (int i=0; i<COLOR_NUM; i++)
    {
      newColor=color(hues[i]+(h*10), saturations[i]+(s*60), brightnesses[i]+(b*30));
      colors[i]=newColor;
    }
  }

  public void influenceColors(float h, float s, float b, int coeff)
  {
    //create a new color with the same H and S buu with a new B
    color newColor;

    for (int i=0; i<COLOR_NUM; i++)
    {
      newColor=color(hues[i]+(h*coeff), saturations[i]+(s*coeff), brightnesses[i]+(b*coeff));
      colors[i]=newColor;
    }
  }



  public void desaturate(float amount)
  {
    //create a new color with the same H and S buu with a new B
    color newColor;
    
    for (int i=0; i<COLOR_NUM; i++)
    {
      newColor=color(hues[i], saturation(colors[i])-amount, brightnesses[i]);
      colors[i]=newColor;
    }
    
  }
  
  public void saturate(float amount)
  {
    //create a new color with the same H and S buu with a new B
    color newColor;
    
    for (int i=0; i<COLOR_NUM; i++)
    {
      newColor=color(hues[i], saturation(colors[i])+amount, brightnesses[i]);
      colors[i]=newColor;
    }
    
  }
  
  
  
  public void makeBrighter(float amount)
  {
    //create a new color with the same H and S buu with a new B
    color newColor;
    
    for (int i=0; i<COLOR_NUM; i++)
    {
      newColor=color(hues[i], saturations[i], brightness(colors[i])+amount);
      colors[i]=newColor;     
    }
  }

  public void makeDarker(float amount)
  {
    //create a new color with the same H and S buu with a new B
    color newColor;
    
    for (int i=0; i<COLOR_NUM; i++)
    {
      newColor=color(hues[i], saturations[i], brightness(colors[i])-amount);
      colors[i]=newColor;     
    }
  }


  private void loadColors()
  {    
    
    //GHIACCIO
    colorsInit[0][0] = color(219, 18, 61);
    colorsInit[0][1] = color(217, 47, 82);
    colorsInit[0][2] = color(290, 50, 74);
    colorsInit[0][3] = color(194, 35, 72);
    colorsInit[0][4] = color(216, 40, 74);

    //GREEN/BLUE/GRAY
    colorsInit[1][0] = #155656;
    colorsInit[1][1] = #306887;
    colorsInit[1][2] = #586F7C;
    colorsInit[1][3] = #8AB9B5;
    colorsInit[1][4] = #0B4E91;

    //LIGHT BLUE/VIOLET
    colorsInit[2][0] = #C9FBFF;
    colorsInit[2][1] = #C2FCF7;
    colorsInit[2][2] = #85BDBF;
    colorsInit[2][3] = #57737A;
    colorsInit[2][4] = #6F5284;

    //CARPENTIERE
    colorsInit[3][0] = #9CACA9;
    colorsInit[3][1] = #8DFCFC;
    colorsInit[3][2] = #314E57;
    colorsInit[3][3] = #77BECE;
    colorsInit[3][4] = #299961;

    //BLUE-VIOLET
    colorsInit[4][0] = #4EA2D3;
    colorsInit[4][1] = #FFFCFF;
    colorsInit[4][2] = #247BA0;
    colorsInit[4][3] = #8D2A99;
    colorsInit[4][4] = #2D7266;

    

    //WARM COLORS
    //RED
    colorsInit[5][0] = #6A041D;
    colorsInit[5][1] = #F4D06F;
    colorsInit[5][2] = #F4FF60;
    colorsInit[5][3] = #D35A21;
    colorsInit[5][4] = #DCBF85;

    //RED/YELLOW/SAND
    colorsInit[6][0] = #A63446;
    colorsInit[6][1] = #F6F4D2;
    colorsInit[6][2] = #E3C567;
    colorsInit[6][3] = #F19C79;
    colorsInit[6][4] = #A44A3F;

    //SAVANA
    colorsInit[7][0] = #CE7725;
    colorsInit[7][1] = #841B1B;
    colorsInit[7][2] = #7C3626;
    colorsInit[7][3] = #F5853F;
    colorsInit[7][4] = #FFCDBC;
    
    //RED/GREEN
    colorsInit[8][0] = color(135, 60, 95);
    colorsInit[8][1] = color(60, 64, 70);
    colorsInit[8][2] = color(18, 68, 100);
    colorsInit[8][3] = color(30, 30, 90);
    colorsInit[8][4] = color(350, 40, 73);
    
    colorsInit[9][0] = #EAF4D3;
    colorsInit[9][1] = #F6BD60;
    colorsInit[9][2] = #F7AF9D;
    colorsInit[9][3] = #F7E3AF;
    colorsInit[9][4] = #F3EEC3;

  }
  
  
}