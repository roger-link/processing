float t = 0;
ArrayList<Ghost> ghosts;
color bgColor;

int MAX_GHOSTS = 60;
int SPAWN_INTERVAL = 6;
int resetIntervalMs = 30 * 1000;
int lastResetTime = 0;

void setup() {
  size(1000, 800, P3D);
  colorMode(HSB, 360, 100, 100);
  frameRate(60);
  resetSketch();
}

void draw() {
  t += 0.01;

  if (millis() - lastResetTime >= resetIntervalMs) {
    resetSketch();
    println("🔄 Sketch manually reset at", millis() / 1000.0, "seconds.");
  }

  float hueShift = (t * 30) % 360;
  bgColor = color((hueShift + 180) % 360, 40, 12);
  noStroke();
  fill(bgColor);
  rect(0, 0, width, height);

  camera(width / 2, height / 2, 600, width / 2, height / 2, 0, 0, 1, 0);
  ambientLight(30, 30, 30);
  directionalLight(255, 255, 255, 0, -1, -1);
  hint(ENABLE_DEPTH_TEST);

  if (frameCount % SPAWN_INTERVAL == 0 && ghosts.size() < MAX_GHOSTS) {
    ghosts.add(new Ghost(t));
  }

  for (Ghost g : ghosts) {
    g.updateAndDraw(t);
  }
}

void resetSketch() {
  ghosts = new ArrayList<Ghost>();
  t = 0;
  lastResetTime = millis();
  for (int i = 0; i < MAX_GHOSTS; i++) {
    ghosts.add(new Ghost(t));
  }
}

class Ghost {
  PVector basePos;
  float seed, baseZ;
  float maxRadius;
  float hueBase;
  float birthTime;

  float alphaBase;
  float strokeAlphaBase;

  int motionType;
  float motionScale;
  float rotationSpeed;

  Ghost(float now) {
    basePos = new PVector(random(width), random(height));
    baseZ = random(-300, 300);
    seed = random(10000);
    maxRadius = random(60, 100);
    hueBase = random(360);
    birthTime = now;

    alphaBase = random(10, 25);
    strokeAlphaBase = alphaBase * random(0.3, 0.6);

    motionType = int(random(4));
    motionScale = random(40, 150);
    rotationSpeed = random(0.01) * (random(1) < 0.5 ? -1 : 1);
  }

  void updateAndDraw(float now) {
    float rise = sin(now + seed) * 30;
    float z = baseZ + rise;

    float px = basePos.x;
    float py = basePos.y;

    switch (motionType) {
      case 0:
        px += sin(now * 0.6 + seed) * motionScale;
        py += cos(now * 0.4 + seed) * motionScale;
        break;
      case 1:
        px += cos(now * 0.3 + seed * 0.5) * motionScale * 0.8;
        py += sin(now * 0.3 + seed * 0.7) * motionScale;
        break;
      case 2:
        px += noise(now * 0.3 + seed) * motionScale - motionScale / 2;
        py += noise(now * 0.4 + seed + 100) * motionScale - motionScale / 2;
        break;
      case 3:
        px += tan(now * 0.2 + seed) * (motionScale * 0.3);
        py += sin(now * 0.25 + seed) * motionScale;
        break;
    }

    pushMatrix();
    translate(px, py + rise, z);
    rotateZ((now + seed) * rotationSpeed);

    float hue = (hueBase + z * 0.2 + now * 5) % 360;
    float sat = 85 + 15 * noise(seed, now * 0.5);
    float bri = 85 + 15 * noise(seed + 100, now * 0.5);

    fill(hue, sat, bri, alphaBase);
    stroke(hue, sat, 100, strokeAlphaBase);
    strokeWeight(1.0);

    beginShape();
    for (float a = 0; a < TWO_PI; a += PI / 100) {
      float noiseAngle = a * 1.5;
      float r = maxRadius + noise(cos(noiseAngle) + seed, sin(noiseAngle) + seed, now * 0.3 + seed) * 40;
      float x = cos(a) * r;
      float y = sin(a) * r;
      vertex(x, y);
    }
    endShape(CLOSE);
    popMatrix();
  }
}
