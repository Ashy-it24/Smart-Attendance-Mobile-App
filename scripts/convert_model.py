#!/usr/bin/env python3
"""
Convert MobileFaceNet TensorFlow model to TensorFlow Lite format
"""

import tensorflow as tf
import os

def convert_to_tflite(pb_file, output_file):
    """Convert frozen graph (.pb) to TFLite format"""
    print(f"Loading model from: {pb_file}")
    
    # Load the frozen graph
    with tf.io.gfile.GFile(pb_file, "rb") as f:
        graph_def = tf.compat.v1.GraphDef()
        graph_def.ParseFromString(f.read())
    
    # Convert to TFLite
    converter = tf.compat.v1.lite.TFLiteConverter.from_frozen_graph(
        graph_def_file=pb_file,
        input_arrays=['input'],
        output_arrays=['embeddings'],
        input_shapes={'input': [1, 112, 112, 3]}
    )
    
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    tflite_model = converter.convert()
    
    # Save
    with open(output_file, 'wb') as f:
        f.write(tflite_model)
    
    print(f"✅ Converted: {output_file}")
    print(f"📊 Size: {len(tflite_model) / 1024:.2f} KB")

if __name__ == "__main__":
    pb_file = "MobileFaceNet_9925_9680.pb"
    output_file = "mobilefacenet.tflite"
    
    if not os.path.exists(pb_file):
        print(f"❌ {pb_file} not found!")
        exit(1)
    
    convert_to_tflite(pb_file, output_file)
