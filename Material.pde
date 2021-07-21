class Material {
  float Min;
  float Max;
  color Color;
  
  //default setting
  Material()
  {
    Min = 0;
    Max = 0;
    Color = color(255);

  }
  
  //params
  Material(float min, float max, color col)
  {
    Min = min;
    Max = max;
    Color = col;
  }
}
