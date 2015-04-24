//Projectile.
class Projectile
{
  PVector position;  //Projectile position.
  PVector velocity;  //Projectile velocity.
  float distance;    //Distance the projectile has travelled.
  float MaxDistance; //Maximum distance the projectile can travel.
  float radius;      //Radius of the projectile
  
  //Constructor.
  Projectile(PVector p, PVector direction, float speed, float m, float r)
  {
    direction.normalize();
    position = p;
    velocity = PVector.mult(direction, speed);
    distance = 0;
    MaxDistance = m;
    radius = r;
  }
  
  //Moves the projectile.
  //Returns true of the projectile has travelled its maximum distance.
  boolean update()
  {
     fill(255, 255, 200, 255);
     stroke(255, 255, 0, 128);
     strokeWeight(2);
     position.add(velocity);
     this.wrap();
     distance += velocity.mag();
     if(distance > MaxDistance)
     {
       return true; 
     }
     ellipse(position.x, position.y, radius, radius);
     return false;
  }
  
  //Wraps the projectile.
  void wrap()
  {
    //If beyond West border
    if(position.x < 0)
      position.x = width;
    
    //If beyond East border
    if(position.x > width)
      position.x = 0; 
    
    //If beyond North border
    if(position.y < 0)
      position.y = height;
     
    //If beyond South border 
    if(position.y > height)
      position.y = 0; 
  }
}
