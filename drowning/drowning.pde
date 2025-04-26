int cols, rows;
int scl = 20;
int w = 1400;
int h = 1000;

float flying = 0;
float[][] terrain;

int numFigures = 6;
HumanFigure[] figures;
PShape humanModel;

void setup() {
  size(1000, 800, P3D);
  colorMode(HSB, 360, 100, 100);
  humanModel = loadShape("model.obj"); // your working file
  cols = w / scl;
  rows = h / scl;
  terrain = new float[cols][rows];

  figures = new HumanFigure[numFigures];
  for (int i = 0; i < numFigures; i++) {
    figures[i] = new HumanFigure(random(w), random(h));
  }

  frameRate(30);
}

void draw() {
  flying -= 0.05;

  float yoff = flying;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      float noiseVal = noise(xoff, yoff);
      terrain[x][y] = map(noiseVal, 0, 1, -120, 120);
      xoff += 0.15;
    }
    yoff += 0.15;
  }

  background(20, 10, 100);
  ambientLight(30, 30, 30);
  directionalLight(255, 255, 255, -0.3, 1, -0.4);

  translate(width/2, height/2 + 50);
  rotateX(PI / 3.2);
  translate(-w/2, -h/2);

  drawTerrain();

  for (HumanFigure f : figures) {
    f.update();
    f.display();
  }
}

void drawTerrain() {
  stroke(25, 80, 100, 100);
  fill(0);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x * scl, y * scl, terrain[x][y]);
      vertex(x * scl, (y+1) * scl, terrain[x][y+1]);
    }
    endShape();
  }
}

class HumanFigure {
  float x, y, t, scaleFactor, verticalOffset;

  HumanFigure(float x_, float y_) {
    x = x_;
    y = y_;
    t = random(TWO_PI);
    scaleFactor = random(30, 45);        // much bigger
    verticalOffset = random(-100, -60);  // ensures they go *under* the terrain
  }

  void update() {
    t += 0.008;
  }

  void display() {
    float z = getTerrainZ(x, y);
    float rise = sin(t) * 80 + verticalOffset;

    pushMatrix();
    translate(x, y, z + rise);
    scale(scaleFactor);
    shape(humanModel);
    popMatrix();
  }

  float getTerrainZ(float px, float py) {
    int cx = constrain(floor(px / scl), 0, cols - 1);
    int cy = constrain(floor(py / scl), 0, rows - 1);
    return terrain[cx][cy];
  }
}
