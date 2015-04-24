//Parent class for rock with substraction behavior.
class RockSubtracting
{
  PVector velocity;          //Velocity vector.
  
  MeshRockSubtracting geometry;  //Geometry.
  
  //Constructor
  RockSubtracting(PVector p, PVector v, int edgeNum, int radius)
  {
    velocity = v;
    
    //Instantiate and generate mesh.
    geometry = new MeshRockSubtracting(
      p,
      edgeNum, //(int)(PI / asin(edgeLength / (2 * radius))),
      radius);
    geometry.generate();
  }
  
  //Overloaded constructor with speed and direction separate
  RockSubtracting(PVector p, PVector direction, float speed, int edgeNum, int radius)
  {
    direction.normalize();
    velocity = PVector.mult(direction, speed);
    
    //Instantiate and generate mesh.
    geometry = new MeshRockSubtracting(
      p,
      edgeNum, //(int)(PI / asin(edgeLength / (2 * radius))),
      radius);
    geometry.generate();
  }
  
  //Update position.
  void update()
  {
    geometry.offset(velocity);
    geometry.wrap(50);
    geometry.display();
  }
  
  //Check for collisions with geometry.
  boolean collisionProjectile(float x, float y)
  {
    if(geometry.shrink(geometry.collisionMesh(x, y)))
    {
      return true;
    }
    return false;
  }
  
  //Check for collisions with geometry.
  boolean collisionShip(float x, float y)
  {
    if(geometry.collisionMesh(x, y) > 0)
    {
      return true;
    }
    return false;
  }
}
