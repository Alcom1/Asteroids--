//Tracks the number used for perlin noise. Prevents repeated asteroids.
static class HandlerPerlin
{
  static float perlin = 0;  //Current value for perlin noise.
  
  //Increments and returns the value for perlin noise
  static float getPerlin(float increment)
  {
    float current = perlin;
    perlin += increment;
    return current;
  }
}
