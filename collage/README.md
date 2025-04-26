# 🖼️ Collage Scraps Generator (Processing Sketch)

## ✨ Overview

This Processing sketch generates an evolving digital collage made from random irregular scraps of images.
Each fragment drifts, rotates, and layers over time, creating a living, breathing collage.

You can **save a still frame** or **record 5 seconds of frames** to later assemble into a GIF.

---

## 📂 Folder Setup

- Place your **source images** (`.jpg`, `.jpeg`, `.png`) inside the `data/` folder.
- The sketch automatically loads **all images** in `data/`.
- A folder `frames/` will be created automatically to store captured frames when recording.

---

## 🌹️ Controls

| Key | Action |
|:---|:--------|
| `s` | 📸 Save a still snapshot as `collage-####.png` |
| `r` | 🔴 Start recording frames for 5 seconds (300 frames at 60 fps) into `/frames/` |
| `e` | 🔝 Stop recording manually (optional — recording auto-stops after 5 seconds) |

---

## 🚰 Exporting a GIF

After recording frames:

### Using ffmpeg (recommended)

In Terminal:

```bash
cd path/to/your/sketch/frames
ffmpeg -framerate 30 -pattern_type glob -i "frame-*.png" -vf "scale=800:-1" -loop 0 collage.gif
```

- `-framerate 30` = GIF will run at 30 FPS
- `-loop 0` = GIF will loop forever
- `scale=800:-1` = resize width to 800px (height auto-adjusted)

Result: `collage.gif` will be created!

---

### Using an Online Tool

Alternatively, you can upload your frames to:

- [ezgif.com/maker](https://ezgif.com/maker)

Upload the images, adjust frame delay (about `3ms` per frame), and create the GIF.

---

## 🧐 Notes

- The sketch uses **31000 scraps** for a richly layered collage.
- Each scrap:
  - Is randomly cropped from your images
  - Masked with an irregular organic blob shape
  - Moves slowly across the canvas
  - Fades in naturally
- The result is an endless generative art piece that feels handcrafted and dreamlike.

---

## 🖼️ Example Output

| Still Collage | Animated GIF |
|:--------------|:-------------|
| One frame saved with `s` | 20s capture saved with `r` and assembled |
