# Convert MobileFaceNet Model

## The .pb file is already downloaded at:
```
/tmp/MobileFaceNet_TF/arch/pretrained_model/MobileFaceNet_9925_9680.pb
```

## To convert it to .tflite:

### Step 1: Install TensorFlow
```bash
pip3 install tensorflow
```

### Step 2: Run Conversion
```bash
cd /Users/aswanthb/Documents/GitHub/Smart-Attendance-Mobile-App
python3 << 'EOF'
import tensorflow as tf

converter = tf.compat.v1.lite.TFLiteConverter.from_frozen_graph(
    graph_def_file='/tmp/MobileFaceNet_TF/arch/pretrained_model/MobileFaceNet_9925_9680.pb',
    input_arrays=['input'],
    output_arrays=['embeddings'],
    input_shapes={'input': [1, 112, 112, 3]}
)

tflite_model = converter.convert()

with open('assets/models/mobilefacenet.tflite', 'wb') as f:
    f.write(tflite_model)

print(f"✅ Converted! Size: {len(tflite_model)/1024:.1f} KB")
EOF
```

### Step 3: Rebuild App
```bash
flutter clean
flutter pub get  
flutter run
```

---

## Alternative: Skip Conversion

The app works without conversion:
- ✅ UI fully functional
- ✅ Face detection working (ML Kit)
- ✅ Quality checks working
- ⚠️ Embeddings simulated

You can build the entire app and add the model later!

---

## Run This Command Now:

```bash
pip3 install tensorflow && python3 << 'EOF'
import tensorflow as tf
converter = tf.compat.v1.lite.TFLiteConverter.from_frozen_graph(
    graph_def_file='/tmp/MobileFaceNet_TF/arch/pretrained_model/MobileFaceNet_9925_9680.pb',
    input_arrays=['input'],
    output_arrays=['embeddings'],
    input_shapes={'input': [1, 112, 112, 3]}
)
tflite_model = converter.convert()
with open('assets/models/mobilefacenet.tflite', 'wb') as f:
    f.write(tflite_model)
print("✅ Done!")
EOF
```

This will take 2-3 minutes to install TensorFlow and convert.
