//Child geometry for a rock with dividing behavior.
class MeshRockSubtracting extends MeshRock
{
  //Constructor.
  MeshRockSubtracting(PVector p, int e, int r)
  {
    super(p, e, r);
  }
  
  //Shrinks the mesh, reducing an edge to a vertex.
  //A vertex is selected. That vertex is moved to the center of the line, and the vertex after it is deleted.
  //index == index of the point to be deleted.
  //Returns true if shrink occured.
  boolean shrink(int index)
  {
    //Do nothing if the index is less than zero.
    if(index < 0)
    {
      return false;
    }
    
    //Delete and return if the mesh is a triangle before shrinking.
    //There's some weird logic in here with ifs and a ternary. I could try to replace it with modulus shenanigans, but it already works.
    if(mesh.getVertexCount() < 4)
    {
      mesh = createShape();
      this.calcArea();  //Area = 0. Ensures that a triangle asteroid is destroyed.
      return true; 
    }
    
    //Establish temporary vertex.
    boolean specialCase = false;            //True if the selected index is the last vertex in the mesh.
    float tempX = 0;                        //X positon of the point to be moved.
    float tempY = 0;                        //Y position of the point to be moved.
    if(index + 1 < mesh.getVertexCount())   //If index is not the last vertex in the mesh.
    {
      tempX = (mesh.getVertex(index).x + mesh.getVertex(index + 1).x) / 2;
      tempY = (mesh.getVertex(index).y + mesh.getVertex(index + 1).y) / 2;
    }
    else                                    //If index is the last vertex in the mesh.
    {
      specialCase = true;
      tempX = (mesh.getVertex(index).x + mesh.getVertex(0).x) / 2;
      tempY = (mesh.getVertex(index).y + mesh.getVertex(0).y) / 2;
    }
    
    //Form temp mesh for shrinking. Cannot remove verticies from main mesh directly.
    PShape tempMesh = createShape();  //new mesh to replace the old mesh.
    tempMesh.beginShape();
    for(int i = specialCase ? 1 : 0; i < mesh.getVertexCount(); i++)  //Ternary deletes first vertex in the special case.
    {
      if(i == index)  //Move vertex at index and skip the next vertex.
      {
        tempMesh.vertex(
          tempX,
          tempY);
        i++;
      }
      else            //Copy all other verticies to the tempMesh.
      {
        tempMesh.vertex(
          mesh.getVertex(i).x,
          mesh.getVertex(i).y);
      }
    }
    tempMesh.endShape();
    
    //Set mesh to be the new tempMesh and recalculate the center.
    mesh = tempMesh;
    
    //Fix colors.
    mesh.setFill(colorFill);
    mesh.setStroke(colorStroke);
    mesh.setStrokeWeight(thickness);
    
    //Reevaluate the center of the new mesh.
    this.recalcCenter();
    
    //Calculate the area of the new mesh.
    this.calcArea();
    
    return true;
  }
  
  //Recalculates the center of the mesh and repositions the mesh so that the mesh doesn't move.
  void recalcCenter()
  {
    float offX = 0;  //x offset.
    float offY = 0;  //y offset.
    
    //Calculate the new center of the mesh.
    for(int i = 0; i < mesh.getVertexCount(); i++)
    {
      offX += mesh.getVertex(i).x;
      offY += mesh.getVertex(i).y;
    }
    offX = offX / mesh.getVertexCount();
    offY = offY / mesh.getVertexCount();
    
    //Move the Mesh center to the new position.
    position.x += offX;
    position.y += offY;
    
    //Move the geometry so that the mesh doesn't move.
    for(int i = 0; i < mesh.getVertexCount(); i++)
    {
      mesh.setVertex(
        i,
        mesh.getVertex(i).x - offX,
        mesh.getVertex(i).y - offY);
    }
  }
}
