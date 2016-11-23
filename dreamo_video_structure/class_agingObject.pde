//package dreamo.display;

class AgingObject
{
  private int lifeTime;     // number of frames since initialization
  private int lifeTimeLeft;   // number of frames left before death
  private boolean lifeTimeIsUp; // is it dead?
  
  public AgingObject()
  {
    lifeTimeLeft = -1;
    lifeTime = 0;
    lifeTimeIsUp = false;
  }
  
  public void setLifeTimeLeft(int newLifeTimeLeft)
  {
    lifeTimeLeft = newLifeTimeLeft;
    lifeTimeIsUp = false;
  }
  
  public int getLifeTimeLeft()
  {
    return lifeTimeLeft;
  }
  
  public int getLifeTime()
  {
    return lifeTime;
  }
  
  public boolean getLifeTimeIsUp()
  {
    return lifeTimeIsUp;
  }
  
  public void updateTime()
  {
    lifeTime++;
    if(lifeTimeLeft > 0)
    {
      lifeTimeLeft--;
      if(lifeTimeLeft == 0)
      {
        lifeTimeIsUp = true;
      }
    }
  }
}
