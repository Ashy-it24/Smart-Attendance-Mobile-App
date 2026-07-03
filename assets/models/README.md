# Face Recognition Model Setup

## Download Pre-trained Model

### Option 1: MobileFaceNet (Recommended)
**Size:** ~1-2 MB  
**Accuracy:** 99.25% on LFW dataset  
**Speed:** Fast on mobile devices

**Download from:**
1. Visit: https://github.com/sirius-ai/MobileFaceNet_TF
2. Navigate to: `arch/` folder
3. Download: `MobileFaceNet_9925_9680.tflite`
4. Place in: `assets/models/mobilefacenet.tflite`

### Option 2: FaceNet (Higher Accuracy)
**Size:** ~90 MB  
**Accuracy:** 99.63% on LFW dataset  
**Speed:** Slower but more accurate

**Download from:**
1. Visit: https://github.com/nyoki-mtl/keras-facenet
2. Download the TFLite version
3. Convert to `.tflite` format if needed

### Option 3: TensorFlow Hub
```bash
# Use TensorFlow Model Maker to download
pip install tflite-model-maker
# Then download FaceNet or MobileFaceNet
```

---

## Model Specifications

### Input
- Size: 112x112x3 (RGB image)
- Type: Float32
- Range: [0, 1] or [-1, 1] (normalized)

### Output
- Size: 192 or 512 (embedding vector)
- Type: Float32
- Purpose: Face representation

---

## Manual Download Steps

1. **Create models folder** (already done):
   ```bash
   mkdir -p assets/models
   ```

2. **Download model**:
   - Go to GitHub repo
   - Download `.tflite` file
   - Save as `mobilefacenet.tflite`

3. **Place in project**:
   ```
   Smart-Attendance-Mobile-App/
   └── assets/
       └── models/
           └── mobilefacenet.tflite  ← Place here
   ```

4. **Verify file**:
   ```bash
   ls -lh assets/models/mobilefacenet.tflite
   # Should show ~1-2 MB file size
   ```

---

## Alternative: Pre-built Models

If GitHub is unavailable, use these alternatives:

### MediaPipe FaceMesh
```
https://storage.googleapis.com/mediapipe-models/face_detector/
```

### Google ML Kit
Built-in face detection (no download needed)
- Use `google_ml_kit` Flutter package
- Automatic model download

---

## For Development/Testing

If you can't get the model immediately, the current simulated version will work for:
- UI testing
- Flow validation
- Database integration
- Everything except actual face matching

Real model can be added later without changing any other code!

---

## Recommended: Use MediaPipe

For easiest setup, use Google's MediaPipe:

```yaml
dependencies:
  google_ml_kit: ^0.16.3
```

This auto-downloads models and handles everything!
