import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' show Offset;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// ML Kit Face Detection Service
/// Uses Google's on-device ML to detect faces
/// Note: This detects faces but doesn't generate embeddings
/// For embeddings, use TFLite model
class MLKitFaceService {
  late FaceDetector _faceDetector;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize face detector
  Future<void> initialize() async {
    try {
      final options = FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
        enableContours: true,
        enableTracking: false,
        minFaceSize: 0.15,
        performanceMode: FaceDetectorMode.accurate,
      );

      _faceDetector = FaceDetector(options: options);
      _isInitialized = true;
      print('ML Kit Face Detector initialized');
    } catch (e) {
      print('Failed to initialize ML Kit: $e');
      throw Exception('ML Kit initialization failed: $e');
    }
  }

  /// Detect faces in image
  Future<List<Face>> detectFaces(String imagePath) async {
    if (!_isInitialized) {
      throw Exception('Face detector not initialized');
    }

    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final faces = await _faceDetector.processImage(inputImage);
      return faces;
    } catch (e) {
      print('Face detection error: $e');
      throw Exception('Failed to detect faces: $e');
    }
  }

  /// Check if image has exactly one face
  Future<bool> hasSingleFace(String imagePath) async {
    final faces = await detectFaces(imagePath);
    return faces.length == 1;
  }

  /// Check if face is well-positioned (good quality)
  Future<Map<String, dynamic>> checkFaceQuality(String imagePath) async {
    final faces = await detectFaces(imagePath);

    if (faces.isEmpty) {
      return {
        'isGood': false,
        'message': 'No face detected',
      };
    }

    if (faces.length > 1) {
      return {
        'isGood': false,
        'message': 'Multiple faces detected',
      };
    }

    final face = faces.first;

    // Check face size
    final boundingBox = face.boundingBox;
    final faceArea = boundingBox.width * boundingBox.height;
    final minArea = 10000; // Minimum face area in pixels

    if (faceArea < minArea) {
      return {
        'isGood': false,
        'message': 'Face too small. Move closer',
      };
    }

    // Check head rotation
    final headYaw = face.headEulerAngleY ?? 0;
    final headPitch = face.headEulerAngleX ?? 0;
    final headRoll = face.headEulerAngleZ ?? 0;

    if (headYaw.abs() > 15 || headPitch.abs() > 15 || headRoll.abs() > 15) {
      return {
        'isGood': false,
        'message': 'Keep your head straight',
      };
    }

    // Check if eyes are open (if classification enabled)
    if (face.leftEyeOpenProbability != null) {
      final leftEyeOpen = face.leftEyeOpenProbability! > 0.5;
      final rightEyeOpen = face.rightEyeOpenProbability! > 0.5;

      if (!leftEyeOpen || !rightEyeOpen) {
        return {
          'isGood': false,
          'message': 'Please keep your eyes open',
        };
      }
    }

    // Check if smiling (optional)
    if (face.smilingProbability != null) {
      final isSmiling = face.smilingProbability! > 0.7;
      if (!isSmiling) {
        // Optional: Can enforce smiling
        // return {'isGood': false, 'message': 'Please smile'};
      }
    }

    return {
      'isGood': true,
      'message': 'Good face position',
      'confidence': 0.95,
    };
  }

  /// Get face landmarks (eyes, nose, mouth positions)
  Future<Map<String, dynamic>?> getFaceLandmarks(String imagePath) async {
    final faces = await detectFaces(imagePath);

    if (faces.isEmpty) return null;

    final face = faces.first;
    final landmarks = <String, dynamic>{};

    // Left eye
    if (face.landmarks[FaceLandmarkType.leftEye] != null) {
      landmarks['leftEye'] = face.landmarks[FaceLandmarkType.leftEye]!.position;
    }

    // Right eye
    if (face.landmarks[FaceLandmarkType.rightEye] != null) {
      landmarks['rightEye'] = face.landmarks[FaceLandmarkType.rightEye]!.position;
    }

    // Nose
    if (face.landmarks[FaceLandmarkType.noseBase] != null) {
      landmarks['nose'] = face.landmarks[FaceLandmarkType.noseBase]!.position;
    }

    // Mouth
    if (face.landmarks[FaceLandmarkType.bottomMouth] != null) {
      landmarks['mouth'] = face.landmarks[FaceLandmarkType.bottomMouth]!.position;
    }

    return landmarks.isEmpty ? null : landmarks;
  }

  /// Generate simple face descriptor from landmarks (not a real embedding)
  /// This is a simple geometric feature, not suitable for production
  Future<List<double>?> generateSimpleDescriptor(String imagePath) async {
    final landmarks = await getFaceLandmarks(imagePath);
    if (landmarks == null) return null;

    // Calculate distances between landmarks
    final descriptor = <double>[];

    // This is a simplified approach - real embeddings are much better
    // Use this only for testing without TFLite model
    if (landmarks.containsKey('leftEye') && landmarks.containsKey('rightEye')) {
      final leftEye = landmarks['leftEye'] as Offset;
      final rightEye = landmarks['rightEye'] as Offset;
      final eyeDistance = math.sqrt(
        math.pow(leftEye.dx - rightEye.dx, 2) + 
        math.pow(leftEye.dy - rightEye.dy, 2)
      );
      descriptor.add(eyeDistance);
    }

    // Add more geometric features...
    // This is just for demonstration
    // Real face recognition needs proper embeddings from neural networks

    return descriptor;
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _faceDetector.close();
    _isInitialized = false;
  }
}
