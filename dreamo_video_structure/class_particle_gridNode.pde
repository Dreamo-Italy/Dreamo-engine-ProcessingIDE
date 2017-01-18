class GridNode extends Particle
{
  float kToCenter = 0.014;
  float kToNeighbour = 0.06;
  float damping = 1.31;
  float maximumDistanceFromCenter = 70;
  float maximumSpeed = 100;
  Vector2d centerPosition;
  GridNode[] neighbourGridNodes = {null, null, null, null}; //other GridNode which is at position right, up, left, down
  
  boolean destroying = false;
  
  void setNeighbour(GridNode toAdd, int direction) //direction 0->right, 1->up, 2->left, 3->down
  {
    if(direction < 4 && direction >= 0)
    {
      neighbourGridNodes[direction] = toAdd;
    }
    else
    {
      println("GridNode warning: bad direction value in setNeighbours.");
    }
  }
  
  Vector2d getCenterPosition()
  {
    return centerPosition;
  }
  
  void init()
  {
    setPersistence(true);
    centerPosition = getPosition();
  }
  
  void update()
  {
    //calculate elastic force due to neighbour nodes
    Vector2d elasticForceToNeighbours = new Vector2d(0, 0, false);
    for(int i = 0; i < 4; i++)
    {
      if(neighbourGridNodes[i]!=null)
      {
        float distanceBetweenCenters = neighbourGridNodes[i].getCenterPosition().distance(centerPosition);
        float distanceBetweenPoints = neighbourGridNodes[i].getPosition().distance(getPosition());
        elasticForceToNeighbours = elasticForceToNeighbours.sum(new Vector2d((distanceBetweenPoints-distanceBetweenCenters)*kToNeighbour, neighbourGridNodes[i].getPosition().subtract(getPosition()).getDirection(), true));
      }
    }
    //add elastic force due to the center of the node and set acceleration
    float distanceFromCenter = centerPosition.distance(getPosition());
    float directionToCenter = centerPosition.subtract(getPosition()).getDirection();
    setGravity(elasticForceToNeighbours.sum(new Vector2d(distanceFromCenter*kToCenter, directionToCenter, true)));
    
    getSpeed().setModulus(getSpeed().getModulus()/damping); //apply damping (or nodes will continue to oscillate till forever)
    
    if(distanceFromCenter > maximumDistanceFromCenter) //in case the system is diverging
    {
      setPosition(centerPosition);
      setSpeed(new Vector2d(0, 0, false));
    }
    
    if(getSpeed().getModulus() > maximumSpeed)
    {
      getSpeed().setModulus(maximumSpeed);
    }
    
    if(getSceneChanged()&&!destroying)
    {
      destroying = true;
      setLifeTimeLeft(60);
    }
  }
  
  void trace()
  {
  }
}