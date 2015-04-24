//General child geometry.
class Mesh
{
  PVector position;  //Position of the mesh.
  PShape mesh;       //PShape.
  float area;        //Area of the mesh.
  color colorFill;   //Color of the mesh.
  color colorStroke; //Color of the mesh border.
  int thickness;     //thickness of the mesh.
  
  //Constructor.
  Mesh(PVector p, color f, color s, int t)
  {
    area = 0;  //Area starts off at zero before mesh generation.
    mesh = createShape();
    position = p;
    
    colorFill = f;
    colorStroke = s;
    thickness = t;
  }
  
  //Generates a general mesh.
  void generate()
  {
    mesh = createShape(RECT, -50, -50, 50, 50);
    
    //calculate the initial area.
    this.calcArea();
  }
  
  //Display the PShape.
  void display()
  {
    pushMatrix();
      translate(position.x, position.y);
      shape(mesh);
      
      //Draw line across gap that appears in PShapes. WHY IS THERE A GAP IN PSHAPES?! >:(
      stroke(colorStroke);
      strokeWeight(3);
      line(
        mesh.getVertex(0).x,
        mesh.getVertex(0).y,
        mesh.getVertex(mesh.getVertexCount() - 1).x,
        mesh.getVertex(mesh.getVertexCount() - 1).y);
    popMatrix();
  }
  
  //Offset the mesh by given coordinates.
  void offset(PVector offset)
  {
     position.add(offset);
  }
  
  //Checks collision based on given x and y position.
  int collisionMesh(float gx, float gy)
  {
    //for every virtual triangle based on the mesh center and every pshape edge,
    //peform a barycentric comparison with the given point.
    for(int i = 0; i < mesh.getVertexCount(); i++)
    {
      float bx = mesh.getVertex(i).x;        //x coor of vertex b
      float by = mesh.getVertex(i).y;        //y coor of vertex b
      float cx = mesh.getVertex(             //x coor of vertex c
        i + 1 < mesh.getVertexCount() ?
        i + 1 :
        0).x;
      float cy = mesh.getVertex(             //y coor of vertex c
        i + 1 < mesh.getVertexCount() ?
        i + 1 :
        0).y;
      float px = gx - position.x;            //move px to relative position.
      float py = gy - position.y;            //move py to relative position.
      float div = bx * cy - cx * by;         //denominator of barycentric formula.
      float u = (px * cy - cx * py) / div;   //Barycentric coor u
      float v = (bx * py - px * by) / div;   //Barycentric coor v
      if( u > 0 && v > 0 && u + v < 1)       //Barycentric comparison for collision.
      {
        return i;  //Returns the index when a collision is detected.
      }
    }
    return -1;  //If no collision, returns 1.
  }
  
  //Wraps the geometry so it doesn't go off screen.
  void wrap(int offset)
  {
    //If beyond West border
    if(position.x < -offset)
      position.x = width + offset;
    
    //If beyond East border
    if(position.x > width + offset)
      position.x = -offset; 
    
    //If beyond North border
    if(position.y < -offset)
      position.y = height + offset;
     
    //If beyond South border 
    if(position.y > height + offset)
      position.y = -offset; 
  }
  
  //Sets area to equal the area of the geometry.
  void calcArea()
  {
    area = 0;
    for(int i = 0; i < mesh.getVertexCount(); ++i)
    {
      PVector temp = new PVector();
      PVector.cross(
        mesh.getVertex(i),
        mesh.getVertex(i + 1 < mesh.getVertexCount() ? i + 1 : 0), 
        temp);
      area += temp.mag() / 2;
    }
  }
}
