//Child geometry for the player's ship.
class MeshShip extends Mesh
{
  MeshShip(PVector p)
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
      strokeWeight(thickness);
      line(
        mesh.getVertex(0).x,
        mesh.getVertex(0).y,
        mesh.getVertex(mesh.getVertexCount() - 1).x,
        mesh.getVertex(mesh.getVertexCount() - 1).y);
    popMatrix();
  }
  
  //Displays the PShape at a given position.
  void displayAt(PVector position)
  {
    pushMatrix();
      translate(position.x, position.y);
      shape(mesh);
      
      //Draw line across gap that appears in PShapes.
      stroke(colorStroke);
      strokeWeight(thickness);
      line(
        mesh.getVertex(0).x,
        mesh.getVertex(0).y,
        mesh.getVertex(mesh.getVertexCount() - 1).x,
        mesh.getVertex(mesh.getVertexCount() - 1).y);
    popMatrix();
  }
  
  //Generates the player's hardcoded ship.
  void generate()
  {
    //Construct the mesh.
    mesh.beginShape();
      mesh.vertex(20, 0);
      mesh.vertex(-10, -10);
      mesh.vertex(-10, 10);
    mesh.endShape();
    
    //Set colors and stroke weight.
    mesh.setFill(colorFill);
    mesh.setStroke(colorStroke);
    mesh.setStrokeWeight(thickness);
    
    //calculate the initial area.
    this.calcArea();
  }
}
