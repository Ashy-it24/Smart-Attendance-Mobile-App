#!/usr/bin/env python3
"""Convert MobileFaceNet to TFLite"""
import tensorflow as tf

pb_file = "MobileFaceNet_9925_9680.pb"
output = "mobilefacenet.tflite"

converter = tf.compat.v1.lite.TFLiteConverter.from_frozen_graph(
    graph_def_file=pb_file,
    input_arrays=['input'],
    output_arrays=['embeddings'],
    input_shapes={'input': [1, 112, 112, 3]}
)

tflite_model = converter.convert()

with open(output, 'wb') as f:
    f.write(tflite_model)

print(f"✅ Converted to {output}")
print(f"Size: {len(tflite_model)/1024:.1f} KB")
