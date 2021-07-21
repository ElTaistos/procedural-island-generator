//Import
import controlP5.*; //GUI
ControlP5 cp5;

//Perlin Noise Option
float increment = 0.02;
float detail = 0.2;
float FadeDistance = 1.2;
String seed = "35982";
String LastSeed = "";

//Buffer
PImage PerlinNoise;
PImage MaterialMap;

//Setup Materials
ArrayList<Material> Materials = new ArrayList<Material>();

//GUI
//Button
Button BT_Mode;
Button BT_Preview;
Button BT_RDSeed;
Button BT_OpendJs;
Button BT_SaveJs;

//Knob
Knob K_Increment;
Knob K_Detail;
Knob K_Fade;
Knob K_Radius;

//Field
Textfield T_Seed;

//Area
Textarea TA_LastSeed;

//Save Island Parameter
JSONObject Preset;

//Toggle
boolean IsPerlinActive;
boolean IsKeyResset;

void setup() {
  size(640, 640);
   //size(340, 340);
  
  //Materials Setup
  Materials.add(new Material(0.0,0.05, color(29, 180, 240) )); //water
  Materials.add(new Material(0.05,0.1, color(247, 214, 0) )); //sand
  Materials.add(new Material(0.1,0.2, color(224, 194, 0) )); //Darksand
  Materials.add(new Material(0.2,0.4, color(0, 181, 12) )); //Grass
  Materials.add(new Material(0.4,1.2, color(12, 125, 0) )); //HighGrass
  
  //Scaling Factor
  int SideFactor = int(width/width*1.1);
  
  //Generate All Image
  PerlinNoise = GeneratePerlinNoise();
  MaterialMap = ApplyMaterial(PerlinNoise);
  
  //Json
  Preset = new JSONObject();
  
  //GUI Input
  cp5 = new ControlP5(this);
  
  
  //Button
  BT_Mode = cp5.addButton("Mode")
    .setValue(1)
    .setPosition(width*(1.0/100), height*(1.0/100))
    .setSize(int(100*SideFactor), int(height*(4.0/100)))
    .setColorBackground(color(80))
    .setColorForeground(color(120))
    .setCaptionLabel("Perlin")
    ;
   
   BT_Preview = cp5.addButton("Preview")
    .setValue(1)
    .setPosition(width*(1.0/100), height*(5.0/100))
    .setSize(int(100*SideFactor), int(height*(4.0/100)))
    .setColorBackground(color(80))
    .setColorForeground(color(120))
    ;
    
   BT_RDSeed = cp5.addButton("Random Seed")
    .setValue(1)
    .setPosition(width*(1.0/100), height*(9.0/100))
    .setSize(int(100*SideFactor), int(height*(4.0/100)))
    .setColorBackground(color(80))
    .setColorForeground(color(120))
    ;
    
   BT_OpendJs = cp5.addButton("Opend Json")
    .setValue(1)
    .setPosition(width*(1.0/100), height*(13.0/100))
    .setSize(int(100*SideFactor), int(height*(4.0/100)))
    .setColorBackground(color(80))
    .setColorForeground(color(120))
    ;
    
   BT_SaveJs = cp5.addButton("Save Json")
    .setValue(1)
    .setPosition(width*(1.0/100), height*(17.0/100))
    .setSize(int(100*SideFactor), int(height*(4.0/100)))
    .setColorBackground(color(80))
    .setColorForeground(color(120))
    ;
    
    
   //Knob
   K_Increment = cp5.addKnob("increment")
     .setRange(0.01,0.03)
     .setValue(0.02)
     .setPosition(width*(20.0/100), height*(1.0/100))
     .setRadius(15)
     .setColorForeground(color(255))
     .setColorActive(color(255,0,0))
     .setDecimalPrecision(4)
     ;
   
   K_Detail = cp5.addKnob("detail")
     .setRange(0.1,0.6)
     .setValue(0.2)
     .setPosition(width*(30.0/100), height*(1.0/100))
     .setRadius(15)
     .setColorForeground(color(255))
     .setColorActive(color(255,0,0))
     .setDecimalPrecision(2)
     ;
   
   K_Radius = cp5.addKnob("FadeDistance")
     .setRange(0,3)
     .setValue(1.2)
     .setPosition(width*(40.0/100), height*(1.0/100))
     .setRadius(15)
     .setColorForeground(color(255))
     .setColorActive(color(255,0,0))
     .setDecimalPrecision(2)
     ;
   
   
   //Field
   T_Seed = cp5.addTextfield("seed")
     .setPosition(width*(20.0/100), height*(10.0/100))
     .setValue("35982")
     .setSize(int(100*SideFactor), int(height*(4.0/100)))
     .setFont(createFont("arial", 20))
     .setAutoClear(false)
     ;
     
     
   //Area
   TA_LastSeed = cp5.addTextarea("Last Seed")
     .setPosition(width*(1.0/100), height*(95.0/100))
     .setSize(200,40)
     .setFont(createFont("arial",20))
     .setLineHeight(14)
     .setColor(color(128))
     ;
     
}


void draw() {

  if (mousePressed) {
    
    if(cp5.isMouseOver(cp5.getController("Mode")))
    {
      IsPerlinActive = !IsPerlinActive;
      if(IsPerlinActive)
      {
        BT_Mode.setCaptionLabel("ColorMap");
      }
      else
      {
        BT_Mode.setCaptionLabel("GrayScale");
      }
      delay(200);
    }

    if(mousePressed && cp5.isMouseOver(cp5.getController("Random Seed")))
    {
      LastSeed = seed;
      seed = str(int(random(0,999999)));
      TA_LastSeed.setText(LastSeed);
      T_Seed.setValue(seed);
      delay(200);
    }

    if(!IsKeyResset && cp5.isMouseOver(cp5.getController("Opend Json")))
    {
      File JsFile = new File(sketchPath("")+"/*.json"); 
      selectInput("Select a file to process:", "fileSelected", JsFile);
      IsKeyResset = true;
    }
    if(!IsKeyResset && cp5.isMouseOver(cp5.getController("Save Json")))
    {
      selectFolder("Select a folder to process:", "folderSelected");
      IsKeyResset = true;
    }
    
  }

  if (mousePressed && cp5.isMouseOver(cp5.getController("Preview"))) 
  {
    ReCalculateMap();
    delay(200);
  }
  
  if(IsPerlinActive)
  {
    image(PerlinNoise, 0, 0);
    updatePixels();
  }
  else
  {
    image(MaterialMap, 0, 0);
    updatePixels();
  }
}

PImage GeneratePerlinNoise()
{
  PImage PerlinNoise = createImage(width, height, RGB);
  
  float xoff = 0.0;
  noiseDetail(8, detail);
  noiseSeed(int(seed));
  
  for (int x = 0; x < width; x++) {
    xoff += increment;
    float yoff = 0.0;
    for (int y = 0; y < height; y++) {
      yoff += increment;
      
      float bright = noise(xoff, yoff) * 255;
      float DistFromCenter = dist(x,y, int(height/2), int(width/2));
      color NoiseColor = color(bright - DistFromCenter/FadeDistance );
      
      PerlinNoise.pixels[x+y*width] = NoiseColor;
      
    }
  }
  
  return PerlinNoise;
}

PImage ApplyMaterial(PImage map)
{
  
  PImage MaterialMap = createImage(width, height, RGB);
  background(0, 0, 255);
  for (int x = 0; x < width*height; x++) {
    
      for (int i = 0; i < Materials.size(); i++) {
      
      MaterialMap.pixels[x] = color(255,0,0);
      
      if(MapColor(map.pixels[x]) <= Materials.get(i).Max && MapColor(map.pixels[x]) >= Materials.get(i).Min )
      {
        MaterialMap.pixels[x] = Materials.get(i).Color;
        break;
      }
      
    }
    
  }
  
  return MaterialMap;
  
}

float MapColor(color col)
{
  float v = map(red(col), 0, 255, 0, 1 );
  return v - v%0.01;
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    LoadJson(selection.getAbsolutePath());
  }
}

void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    SaveJson(selection.getAbsolutePath());
  }
}

void mouseReleased() {
  
  if (IsKeyResset)
  {
    IsKeyResset = !IsKeyResset;
    print("reset!");
  }
}

void ReCalculateMap()
{
    PerlinNoise = GeneratePerlinNoise();
    MaterialMap = ApplyMaterial(PerlinNoise);
}

void SaveJson(String Path)
{
  print(Path + "/" + seed + ".json");
   
  Preset.setString("seed", seed);
  Preset.setFloat("increment", increment);
  Preset.setFloat("detail", detail);
  Preset.setFloat("FadeDistance", FadeDistance);
  print(Path + "/" + seed + ".json");
  saveJSONObject(Preset, Path + "/" + seed + ".json");
  
}

void LoadJson(String Path)
{
  Preset = loadJSONObject(Path);
  
  //Variable
  seed = Preset.getString("seed");
  increment = Preset.getFloat("increment");
  detail = Preset.getFloat("detail");
  FadeDistance = Preset.getFloat("FadeDistance");
  
  //Update GUI
  T_Seed.setValue(seed);
  K_Increment.setValue(increment);
  K_Detail.setValue(detail);
  K_Radius.setValue(FadeDistance);
  ReCalculateMap();
}
