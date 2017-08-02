class Mood 
{
  private float valence;
  private float arousal;
  
  //default constructor
  public Mood()
  {
    valence=0.0;
    arousal=0.0;
  }
  
  //parametric constructor
  public Mood(float v, float a)
  {
    valence=v;
    arousal=a;
  }
  
  //copy constructor
  public Mood(Mood toCopy)
  {
    valence=toCopy.valence;
    arousal=toCopy.arousal;
  
  }
  
  
  //set methods
  public void setValence(float v)
  {
    valence=v;
  }
  
  public void setArousal(float a)
  {
    arousal=a;
  }
  
  public void setMood(float v, float a)
  {
    valence=v;
    arousal=a;
  }
   
   
  //get methods
  public float getValence()
  {
    return valence;
  }
  
  public float getArousal()
  {
    return arousal;
  }

}