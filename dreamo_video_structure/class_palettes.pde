
class Palette {
 //********* TEMPORARY PALETTES (only for initial development) ***********
  private color[][] colorsInit= new color[5][5];
  
//color[0][0] = new color(45, 100, 48, 1);
//$color2: hsla(39%, 100%, 49%, 1);
//$color3: hsla(32%, 97%, 46%, 1);
//$color4: hsla(23%, 100%, 50%, 1);
//$color5: hsla(15%, 98%, 49%, 1);

 //********* PRIVATE MEMBERS ***********
private int ID;
private String name;
private color[] colors = new color[5];
private boolean initialized=false;

 
 //********* CONTRUCTORS ***********
 public Palette(){
 
 colorMode(HSB);
 //first palette
 colorsInit[0][0] = color(39,100,49,0.5);
 colorsInit[0][1] = color(32,97,46,0.5);
 colorsInit[0][2] = color(23,100,50,0.5);
 colorsInit[0][3] = color(15,98,49,0.5);
 colorsInit[0][4] = color(45,100,48,0.5);
 
 //second palette
 colorsInit[1][0] = color(39,100,49);
 colorsInit[1][1] = color(32,97,46);
 colorsInit[1][2] = color(23,100,50);
 colorsInit[1][3] = color(15,98,49);
 colorsInit[1][4] = color(45,100,48);
 
 initialized=false;
 }
   
 
 //********* PUBLIC METHODS ***********
 
 //set methods
  public void setPalette()
  {       
    int r = (int)random(1);
    for(int i=0;i<5;i++){
       colors[i]=colorsInit[r][i];
     }
     ID=r;
     name="random";
     
     initialized=true;
  }
  
  public void setPalette(int idx)
  {
     for(int i=0;i<5;i++){
       colors[i]=colorsInit[idx][i];
      }
     ID=idx;
     name="idx";
     
     initialized=true;
    
  }
  
    public void setPalette(String name)
  {
     //confronta nome palette con "name"
     
     initialized=true;
    
  }
  
  
  //get methods
  //random color
    public color getColor()
  {
    int r = (int)random(4);
    if(initialized){
      return colors[r];   
    }
    
  else{
    println("ERROR");
    return color(255,255,255,0);
    }
  }
  
  //color idx
  public color getColor(int idx)
  {
    
    if(initialized && idx<5 && idx>=0){
      return colors[idx];   
    }
    
  else{
    println("ERROR");
    return color(255,255,255,0);
    }
  }
  

  
}