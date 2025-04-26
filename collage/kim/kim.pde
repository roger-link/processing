import java.io.File;

ArrayList<PImage> sourceImages;
ArrayList<Scrap> scraps;
int NUM_SCRAPS = 31000;

boolean recording = false;
int recordingFrame = 0;

void setup() {
  size(1000, 800, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(60);

  loadSourceImages();
  scraps = new ArrayList<Scrap>();
  for (int i = 0; i < NUM_SCRAPS; i++) {
    scraps.add(new Scrap());
  }

  createFramesFolder();
}

void draw() {
  background(0, 0, 10);

  for (Scrap s : scraps) {
    s.update();
    s.display();
  }

  if (recording) {
    saveFrame("frames/frame-####.png");
    recordingFrame++;
    if (recordingFrame > 1200) {  // ✨ 5 seconds at 60 fps
      recording = false;
      println("🛑 Auto-stopped after 5 seconds (300 frames).");
    }
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("collage-####.png");
    println("📸 Saved still collage frame!");
  }

  if (key == 'r' || key == 'R') {
    recording = true;
    recordingFrame = 0;
    println("🔴 Started recording frames!");
  }

  if (key == 'e' || key == 'E') {
    recording = false;
    println("🛑 Stopped recording manually.");
  }
}

void loadSourceImages() {
  sourceImages = new ArrayList<PImage>();
  File dir = new File(dataPath(""));
  File[] files = dir.listFiles();

  for (File f : files) {
    String name = f.getName().toLowerCase();
    if (name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".png")) {
      PImage img = loadImage(f.getName());
      if (img != null) {
        sourceImages.add(img);
      }
    }
  }

  if (sourceImages.size() == 0) {
    println("⚠️ No images found in /data!");
  } else {
    println("✅ Loaded", sourceImages.size(), "images.");
  }
}

void createFramesFolder() {
  File framesFolder = new File(sketchPath("frames"));
  if (!framesFolder.exists()) {
    framesFolder.mkdirs();
  }
}

class Scrap {
  PImage img;
  PImage mask;
  float x, y;
  float vx, vy;
  float angle, vangle;
  float alpha;
  float fadeSpeed;

  Scrap() {
    // Pick random source image
    PImage source = sourceImages.get(int(random(sourceImages.size())));

    // Random crop
    int cropW = int(random(40, 150));
    int cropH = int(random(40, 150));
    int cropX = int(random(source.width - cropW));
    int cropY = int(random(source.height - cropH));
    img = source.get(cropX, cropY, cropW, cropH);

    // Create organic blob mask
    mask = createBlobMask(cropW, cropH);
    img.mask(mask);

    // Position and motion
    x = random(width);
    y = random(height);
    vx = random(-0.3, 0.3);
    vy = random(-0.3, 0.3);
    angle = random(TWO_PI);
    vangle = random(-0.002, 0.002);

    alpha = 0;
    fadeSpeed = random(0.001, 0.003);
  }

  void update() {
    x += vx;
    y += vy;
    angle += vangle;

    alpha += fadeSpeed;
    if (alpha > 1) {
      alpha = 1;
    }

    // Wrap around screen
    if (x < -img.width) x = width;
    if (x > width) x = -img.width;
    if (y < -img.height) y = height;
    if (y > height) y = -img.height;
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(angle);

    tint(255, alpha * 255);
    imageMode(CENTER);
    image(img, 0, 0);

    popMatrix();
  }
}

PImage createBlobMask(int w, int h) {
  PGraphics pg = createGraphics(w, h);
  pg.beginDraw();
  pg.background(0);
  pg.noStroke();
  pg.fill(255);

  pg.beginShape();

  float x = w/2 + random(-w*0.2, w*0.2);
  float y = h/2 + random(-h*0.2, h*0.2);

  for (int i = 0; i < int(random(10, 25)); i++) {
    float angle = random(TWO_PI);
    float distance = random(w*0.15, w*0.55);
    x += cos(angle) * distance;
    y += sin(angle) * distance;
    x = constrain(x, 0, w);
    y = constrain(y, 0, h);
    pg.vertex(x, y);
  }

  pg.endShape(CLOSE);
  pg.endDraw();

  return pg.get();
}
