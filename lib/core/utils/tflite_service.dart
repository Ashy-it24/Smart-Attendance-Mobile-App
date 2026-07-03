import 'dart:math' as math;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  Interpreter? _interpreter;
  bool _isInitialized = false;

  // Model configuration
  static const int inputSize = 112;
  static const int outputSize = 192; // MobileFaceNet outputs 192-dimensional embedding

  bool get isInitialized => _isInitialized;

  /// Initialize TensorFlow Lite interpreter
  Future<void> initialize() async {
    try {
      // Load model from assets
      _interpreter = await Interpreter.fromAsset('models/mobilefacenet.tflite');
      
      // Allocate tensors
      _interpreter!.allocateTensors();
      
      _isInitialized = true;
      print('TFLite model loaded successfully');
      print('Input shape: ${_interpreter!.getInputTensors()}');
      print('Output shape: ${_interpreter!.getOutputTensors()}');
    } catch (e) {
      print('Failed to load TFLite model: $e');
      throw Exception('Model initialization failed: $e');
    }
  }

  /// Generate face embedding from image
  Future<List<double>> generateEmbedding(img.Image image) async {
    if (!_isInitialized || _interpreter == null) {
      throw Exception('TFLite model not initialized');
    }

    try {
      // Preprocess image
      final input = _preprocessImage(image);
      
      // Prepare output buffer
      final output = [List.filled(outputSize, 0.0)];
      
      // Run inference
      _interpreter!.run(input, output);
      
      // Extract embedding
      final embedding = output[0] as List<double>;
      
      // Normalize embedding
      return _normalizeEmbedding(embedding);
    } catch (e) {
      print('Inference error: $e');
      throw Exception('Failed to generate embedding: $e');
    }
  }

  /// Preprocess image for model input
  /// Converts image to [1, 112, 112, 3] float array normalized to [0, 1]
  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    // Resize image to input size
    final resized = img.copyResize(
      image,
      width: inputSize,
      height: inputSize,
      interpolation: img.Interpolation.linear,
    );

    // Convert to normalized float array
    final input = List.generate(
      1,
      (_) => List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) => List.generate(3, (c) {
            final pixel = resized.getPixel(x, y);
            final value = c == 0
                ? pixel.r.toDouble()
                : c == 1
                    ? pixel.g.toDouble()
                    : pixel.b.toDouble();
            
            // Normalize to [0, 1]
            return value / 255.0;
          }),
        ),
      ),
    );

    return input;
  }

  /// Normalize embedding to unit vector (L2 normalization)
  List<double> _normalizeEmbedding(List<double> embedding) {
    double magnitude = 0.0;
    for (final value in embedding) {
      magnitude += value * value;
    }
    
    if (magnitude == 0.0) {
      return embedding;
    }

    magnitude = math.sqrt(magnitude);
    return embedding.map((value) => value / magnitude).toList();
  }

  /// Get model input shape
  List<int> getInputShape() {
    if (_interpreter == null) return [];
    return _interpreter!.getInputTensor(0).shape;
  }

  /// Get model output shape
  List<int> getOutputShape() {
    if (_interpreter == null) return [];
    return _interpreter!.getOutputTensor(0).shape;
  }

  /// Dispose resources
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }
}
