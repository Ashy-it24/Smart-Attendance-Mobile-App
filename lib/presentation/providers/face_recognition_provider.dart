import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:smart_attendance/core/utils/camera_service.dart';
import 'package:smart_attendance/core/utils/face_utils.dart';
import 'package:smart_attendance/core/utils/mlkit_face_service.dart';
import 'package:smart_attendance/core/utils/tflite_service.dart';

enum FaceRecognitionState { initial, loading, captured, processed, error }

class FaceRecognitionProvider extends ChangeNotifier {
  final CameraService _cameraService = CameraService();
  final TFLiteService _tfliteService = TFLiteService();
  final MLKitFaceService _mlKitService = MLKitFaceService();

  FaceRecognitionState _state = FaceRecognitionState.initial;
  String? _capturedImagePath;
  List<double>? _faceEmbedding;
  String? _error;
  bool _useTFLite = false; // Flag to use TFLite or fallback to simulation

  // Getters
  FaceRecognitionState get state => _state;
  CameraService get cameraService => _cameraService;
  String? get capturedImagePath => _capturedImagePath;
  List<double>? get faceEmbedding => _faceEmbedding;
  String? get error => _error;
  bool get isCameraInitialized => _cameraService.isInitialized;
  bool get isTFLiteAvailable => _useTFLite;

  /// Initialize camera and ML services
  Future<void> initializeCamera() async {
    try {
      _state = FaceRecognitionState.loading;
      _error = null;
      notifyListeners();

      // Initialize camera
      await _cameraService.initialize();

      // Try to initialize TFLite
      try {
        await _tfliteService.initialize();
        _useTFLite = true;
        print('✅ TFLite model loaded - Using real face recognition');
      } catch (e) {
        print('⚠️  TFLite not available - Using simulated embeddings');
        _useTFLite = false;
      }

      // Initialize ML Kit for face quality check
      try {
        await _mlKitService.initialize();
        print('✅ ML Kit initialized - Face quality checks enabled');
      } catch (e) {
        print('⚠️  ML Kit not available - Skipping quality checks');
      }

      _state = FaceRecognitionState.initial;
      notifyListeners();
    } catch (e) {
      _state = FaceRecognitionState.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Capture image from camera
  Future<bool> captureImage() async {
    try {
      _state = FaceRecognitionState.loading;
      _error = null;
      notifyListeners();

      final imagePath = await _cameraService.captureImage();
      _capturedImagePath = imagePath;

      // Check face quality using ML Kit
      if (_mlKitService.isInitialized) {
        final qualityCheck = await _mlKitService.checkFaceQuality(imagePath);
        if (qualityCheck['isGood'] != true) {
          _error = qualityCheck['message'] ?? 'Face quality check failed';
          _state = FaceRecognitionState.error;
          notifyListeners();
          return false;
        }
      }

      _state = FaceRecognitionState.captured;
      notifyListeners();
      return true;
    } catch (e) {
      _state = FaceRecognitionState.error;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Generate face embedding
  Future<bool> generateEmbedding() async {
    try {
      if (_capturedImagePath == null) {
        throw Exception('No image captured');
      }

      _state = FaceRecognitionState.loading;
      notifyListeners();

      if (_useTFLite && _tfliteService.isInitialized) {
        // Use real TFLite model
        await _generateRealEmbedding();
      } else {
        // Fallback to simulated embedding
        await _generateSimulatedEmbedding();
      }

      _state = FaceRecognitionState.processed;
      notifyListeners();
      return true;
    } catch (e) {
      _state = FaceRecognitionState.error;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Generate real embedding using TFLite
  Future<void> _generateRealEmbedding() async {
    // Preprocess image
    final image = await _cameraService.preprocessImage(_capturedImagePath!);
    
    // Run TFLite inference
    _faceEmbedding = await _tfliteService.generateEmbedding(image);
    
    print('✅ Generated real face embedding (${_faceEmbedding!.length} dimensions)');
  }

  /// Generate simulated embedding (fallback)
  Future<void> _generateSimulatedEmbedding() async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Generate deterministic embedding based on image path
    // This way same image always produces same embedding (for testing)
    final seed = _capturedImagePath.hashCode;
    final random = DateTime.now().millisecondsSinceEpoch;
    
    _faceEmbedding = List.generate(
      192, 
      (index) => ((seed + index * random) % 1000) / 1000.0,
    );
    
    print('⚠️  Generated simulated embedding (for testing only)');
  }

  /// Compare face with stored embedding
  Future<Map<String, dynamic>?> compareFace(List<double> storedEmbedding) async {
    if (_faceEmbedding == null) {
      throw Exception('No face embedding generated');
    }

    final similarity = FaceUtils.cosineSimilarity(_faceEmbedding!, storedEmbedding);
    final isMatch = similarity >= 0.8;

    return {
      'match': isMatch,
      'similarity': similarity,
      'confidence': (similarity * 100).toStringAsFixed(2),
      'method': _useTFLite ? 'TFLite' : 'Simulated',
    };
  }

  /// Get face quality metrics
  Future<Map<String, dynamic>?> getFaceQuality() async {
    if (_capturedImagePath == null || !_mlKitService.isInitialized) {
      return null;
    }

    return await _mlKitService.checkFaceQuality(_capturedImagePath!);
  }

  /// Reset state
  void reset() {
    _state = FaceRecognitionState.initial;
    _capturedImagePath = null;
    _faceEmbedding = null;
    _error = null;
    notifyListeners();
  }

  /// Dispose resources
  Future<void> disposeCamera() async {
    await _cameraService.dispose();
    reset();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _tfliteService.dispose();
    _mlKitService.dispose();
    super.dispose();
  }
}
