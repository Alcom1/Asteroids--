//Child geometry for the player's ship.
class MeshDebris extends Mesh
{
  MeshDebris(PVector p)
  {
    super(
      p,
      color(13, 105, 171),
      color(5, 80, 140),
      3);
  }
  
  //Display the PShape.
  void display(PVector direction)
  {
    pushMatrix();
      translate(position.x, position.y);
      rotate(direction.heading());
      shape(mesh);
      
      //Draw line across gap that appears in PShapes.
      stroke(colorStroke);
      strokeWeight(3);
      line(
        mesh.getVertex(0).x,
        mesh.getVertex(0).y,
        mesh.getVertex(mesh.getVertexCount() - 1).x,
        mesh.getVertex(mesh.getVertexCount() - 1).y);
    popMatrix();
  }
  
  //Generates the player's ship.
  void generate(PVector a, PVector b, PVector c)
  {
    //Construct the mesh.
    mesh.beginShape();
      mesh.vertex(a.x, a.y);
      mesh.vertex(b.x, b.y);
      mesh.vertex(c.x, c.y);
    mesh.endShape();
    
    //Set colors and stroke weight.
    mesh.setFill(colorFill);
    mesh.setStroke(colorStroke);
    mesh.setStrokeWeight(thickness);
    
    //calculate the initial area.
    this.calcArea();
  }
}
