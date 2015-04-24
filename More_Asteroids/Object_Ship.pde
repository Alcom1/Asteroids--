//Parent class for player ship.
class Ship
{
  PVector velocity;                  //Velocity vector.
  PVector direction;                 //Direction the ship faces.
  MeshShip geometry;                 //Geometry.
  ArrayList<MeshDebris> debris;      //Debris from a destroyed ship.
  ArrayList<PVector> debrisVelocity; //Velocity of each piece of debris;
  
  int lives;
  boolean active;
  
  //Constructor
  Ship()
  {
    velocity = new PVector(0, 0);
    direction = new PVector(1,0);
    geometry = new MeshShip(new PVector(width / 2, height / 2));
    debris = new ArrayList<MeshDebris>();
    debrisVelocity = new ArrayList<PVector>();
    
    geometry.generate();
    
    for(int i = 0; i < geometry.mesh.getVertexCount(); ++i)
    {
      debris.add(new MeshDebris(new PVector(width / 2, height / 2)));
      debris.get(i).generate(
        geometry.mesh.getVertex(i % geometry.mesh.getVertexCount()),
        geometry.mesh.getVertex((i + 1) % geometry.mesh.getVertexCount()),
        new PVector(0, 0));
      debrisVelocity.add(new PVector(random(-2,2), random(-2,2)));
    }
    
    lives = 3;
    active = true;
  }
  
  //Update position.
  void update()
  {
    velocity.limit(7);
    
    //If active, draw ship.
    if(active)
    {
      geometry.offset(velocity);
      geometry.wrap(0);
      this.calcDirection();
      geometry.display(direction);
      
      //Move debris along with ship so they spawn where the ship was.
      for(int i = 0; i < debris.size(); ++i)
      {
        debris.get(i).offset(velocity);
        debris.get(i).wrap(0);
      }
    }
    
    //If inactive, draw debris.
    else
    {
      for(int i = 0; i < debris.size(); ++i)
      {
        debris.get(i).offset(debrisVelocity.get(i));
        debris.get(i).wrap(0);
        debris.get(i).display(direction);
      }      
    }
    
    //Display lives counter;
    for(int i = 0; i < lives; ++i)
    {
      geometry.displayAt(new PVector(30 + i * 45, 30)); 
    }
  }
  
  //Kills the ship, reducing the lives count by 1.
  boolean kill()
  {
    if(active)
    {
      active = false;  //Deactivate ship.
      lives -= 1;
    }
    if(lives == 0)
    {
      return true; 
    }
    return false;
  }
  
  //Resets the ship to the center of the screen.
  //Returns true if lives reached zero.
  boolean reset()
  {
    //Check if the player is inactive, just to be sure.
    if(!active)
    {
      //Reset position of player and debris.
      velocity = new PVector(0,0);
      active = true;
      geometry.position = new PVector(width / 2, height / 2);
      for(int i = 0; i < debris.size(); ++i)
      {
        debris.get(i).position = new PVector(width / 2, height / 2);
      }
      
      if(lives == 0)
      {
        lives = 3;
        return true;
      }
    }
    return false; 
  }
  
  //Caculates the direction the player's ship faces based on mouse coordinates.
  void calcDirection()
  {
    direction = new PVector(mouseX - geometry.position.x, mouseY - geometry.position.y);
  }
  
  //gets the point from which projectiles spawn.
  PVector getFiringPoint()
  {
    PVector tempPoint = geometry.mesh.getVertex(0);    //Temporary point at
    tempPoint.rotate(direction.heading());             //Turn temporary to match ship.
    return PVector.add(geometry.position, tempPoint);  //Add local position to geometry position and return that.
  }
  
  //Check for collisions with geometry.
  boolean collision(int x, int y)
  {
    return false;
  }
}
