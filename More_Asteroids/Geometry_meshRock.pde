//General child geometry for rocks.
class MeshRock extends Mesh
{
  int edgeNum;  //Number of edges for mesh generation.
  int radius;   //Average Radius of the rock for generation.
  
  //Constructor
  MeshRock(PVector p, int e, int r)
  {
    super(
      p,
      color(127),
      color(63),
      3);
    edgeNum = e;
    radius = r; 
  }
  
  //Generates a rock
  void generate()
  {
    float perlinD = 1;  //Perlin multiplier. Decreases to 0 as generation proceeds.
    
    //Construct the mesh.
    mesh.beginShape();
    for(int i = 0; i < edgeNum; i++)
    {
       mesh.vertex(
         sin(radians(i * 360 / edgeNum)) *
         radius *
         (1 + noise(HandlerPerlin.getPerlin(0.5)) * perlinD),
         
         cos(radians(i * 360 / edgeNum)) *
         radius *
         (1 + noise(HandlerPerlin.getPerlin(0.5)) * perlinD));
       perlinD -= 1 / edgeNum;
    }
    mesh.endShape();
    
    //Set colors and stroke weight.
    mesh.setFill(colorFill);
    mesh.setStroke(colorStroke);
    mesh.setStrokeWeight(thickness);
    
    //calculate the initial area.
    this.calcArea();
  }
}
