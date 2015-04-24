//Contains position and velocity for the purpose of better random handling.
class PosDir
{
  PVector position;  //Starting position of an object.
  PVector direction;  //Starting velocity of an object.
  
  //Default constructor.
  PosDir()
  {
    position = new PVector();
    direction = new PVector();
  }
  
  //Constructor with given position and velocity.
  PosDir(PVector p, PVector v)
  {
    position = p;
    direction = v;
  }
}
