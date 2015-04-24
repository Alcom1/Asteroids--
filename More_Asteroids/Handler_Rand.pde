//Provides positions for random asteroid generation.
class HandlerRand
{
  //Constructor
  HandlerRand()
  {
    //Nothing to see here.
  }
  
  //Get the position and velocity of an asteroid.
  PosDir getSpawn()
  {
    PosDir spawn = new PosDir();
    int side = (int)random(1,5);
    switch(side)
    {
      //North
      case 1:
        spawn.position = new PVector(random(0, width), 0);
        break;
      //South
      case 2:
        spawn.position  = new PVector(random(0, width), height);
        break;
      //West
      case 3:
        spawn.position  = new PVector(0, random(0, height));
        break;
      //East
      case 4:
        spawn.position  = new PVector(width, random(0, height));
        break;
    }
    
    //Form velocity direction of an asteroid.
    spawn.direction = new PVector(random(200, width - 200), random(200, height - 200));
    spawn.direction.sub(spawn.position);
    
    return spawn;
  }
}
