import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendance/core/constants/app_constants.dart';
import 'package:smart_attendance/core/utils/camera_service.dart';
import 'package:smart_attendance/core/utils/face_utils.dart';
import 'package:smart_attendance/core/utils/mlkit_face_service.dart';
import 'package:smart_attendance/core/utils/tflite_service.dart';

enum FaceRecognitionState { initial, loading, captured, processed, error }

class FaceRecognitionProvider extends ChangeNotifier {
  final CameraService _cameraService = CameraService();
  final TFLiteService _tfliteService = TFLiteService();
  final MLKitFaceService _mlKitService = MLKitFaceService();

  // Lazy Firebase instances to avoid blocking main thread at startup
  FirebaseAuth? _firebaseAuth;
  FirebaseFirestore? _firestore;
  FirebaseAuth get _auth => _firebaseAuth ??= FirebaseAuth.instance;
  FirebaseFirestore get _db => _firestore ??= FirebaseFirestore.instance;

  FaceRecognitionState _state = FaceRecognitionState.initial;
  String? _capturedImagePath;
  List<double>? _faceEmbedding;
  String? _error;
  bool _useTFLite = false;
  int _registrationProgress = 0;

  FaceRecognitionState get state => _state;
  CameraService get cameraService => _cameraService;
  String? get capturedImagePath => _capturedImagePath;
  List<double>? get faceEmbedding => _faceEmbedding;
  String? get error => _error;
  bool get isCameraInitialized => _cameraService.isInitialized;
  bool get isTFLiteAvailable => _useTFLite;
  int get registrationProgress => _registrationProgress;

  Future<void> initializeCamera() async {
    try {
      _state = FaceRecognitionState.loading;
      _error = null;
      notifyListeners();

      await _cameraService.initialize();

      try {
        await _tfliteService.initialize();
        _useTFLite = true;
        print('TFLite Service successfully initialized in provider');
      } catch (e) {
        print('TFLite initialization failed, using fallback: $e');
        _useTFLite = false;
      }

      try {
        await _mlKitService.initialize();
      } catch (_) {}

      _state = FaceRecognitionState.initial;
      notifyListeners();
    } catch (e) {
      _state = FaceRecognitionState.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> captureImage() async {
    try {
      _state = FaceRecognitionState.loading;
      _error = null;
      notifyListeners();

      final imagePath = await _cameraService.captureImage();
      _capturedImagePath = imagePath;

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

  Future<bool> generateEmbedding() async {
    try {
      if (_capturedImagePath == null) throw Exception('No image captured');

      _state = FaceRecognitionState.loading;
      notifyListeners();

      if (_useTFLite && _tfliteService.isInitialized) {
        await _generateRealEmbedding();
      } else {
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

  Future<bool> registerCurrentUserFace({
    int sampleCount = AppConstants.faceCaptureCount,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Please login before registering your face');

      if (!_cameraService.isInitialized) await initializeCamera();

      _state = FaceRecognitionState.loading;
      _error = null;
      _registrationProgress = 0;
      notifyListeners();

      final embeddings = <List<double>>[];
      for (int i = 0; i < sampleCount; i++) {
        final captured = await captureImage();
        if (!captured) return false;

        final processed = await generateEmbedding();
        if (!processed || _faceEmbedding == null) return false;

        embeddings.add(_faceEmbedding!);
        _registrationProgress = i + 1;
        notifyListeners();

        if (i < sampleCount - 1) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      final averagedEmbedding = _averageEmbeddings(embeddings);
      await _db.collection('face_embeddings').doc(user.uid).set({
        'embeddingId': user.uid,
        'userId': user.uid,
        'embedding': averagedEmbedding,
        'sampleCount': embeddings.length,
        'dimension': averagedEmbedding.length,
        'confidence': _useTFLite ? 1.0 : 0.5,
        'method': _useTFLite ? 'TFLite' : 'Simulated',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _faceEmbedding = averagedEmbedding;
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

  Future<Map<String, dynamic>?> verifyCurrentUserAndMarkAttendance() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Please login before marking attendance');

      final storedEmbedding = await getRegisteredEmbedding(user.uid);
      if (storedEmbedding == null) {
        throw Exception('No registered face found. Register your face first.');
      }

      final captured = await captureImage();
      if (!captured) return null;

      final processed = await generateEmbedding();
      if (!processed) return null;

      final result = await compareFace(storedEmbedding);
      if (result == null) return null;

      if (result['match'] == true) {
        await _saveAttendance(
          userId: user.uid,
          confidence: result['similarity'] as double,
        );
      }

      return result;
    } catch (e) {
      _state = FaceRecognitionState.error;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<List<double>?> getRegisteredEmbedding(String userId) async {
    final doc = await _db.collection('face_embeddings').doc(userId).get();
    final data = doc.data();
    if (!doc.exists || data == null || data['isActive'] != true) return null;

    final embedding = (data['embedding'] as List<dynamic>)
        .map((value) => (value as num).toDouble())
        .toList();

    if (_faceEmbedding != null && _faceEmbedding!.length != embedding.length) {
      throw Exception(
        'Registered face embedding has ${embedding.length} dimensions, '
        'but the current model produced ${_faceEmbedding!.length}. '
        'Please register your face again.',
      );
    }

    return embedding;
  }

  Future<void> _generateRealEmbedding() async {
    final image = await _cameraService.preprocessImage(_capturedImagePath!);
    _faceEmbedding = await _tfliteService.generateEmbedding(image);
  }

  Future<void> _generateSimulatedEmbedding() async {
    await Future.delayed(const Duration(seconds: 1));
    final seed = _capturedImagePath.hashCode;
    final raw = List.generate(
      192,
      (index) => math.sin(seed + index * 1.5),
    );
    _faceEmbedding = FaceUtils.normalizeEmbedding(raw);
  }

  Future<Map<String, dynamic>?> compareFace(List<double> storedEmbedding) async {
    if (_faceEmbedding == null) throw Exception('No face embedding generated');

    final similarity = FaceUtils.cosineSimilarity(_faceEmbedding!, storedEmbedding);
    final isMatch = similarity >= AppConstants.faceMatchThreshold;

    return {
      'match': isMatch,
      'similarity': similarity,
      'confidence': (similarity * 100).toStringAsFixed(2),
      'method': _useTFLite ? 'TFLite' : 'Simulated',
    };
  }

  List<double> _averageEmbeddings(List<List<double>> embeddings) {
    if (embeddings.isEmpty) throw Exception('No face samples captured');

    final dimension = embeddings.first.length;
    if (embeddings.any((e) => e.length != dimension)) {
      throw Exception('Captured face samples have inconsistent dimensions');
    }

    final averaged = List<double>.filled(dimension, 0.0);
    for (final embedding in embeddings) {
      for (int i = 0; i < dimension; i++) {
        averaged[i] += embedding[i];
      }
    }
    for (int i = 0; i < dimension; i++) {
      averaged[i] /= embeddings.length;
    }

    return FaceUtils.normalizeEmbedding(averaged);
  }

  Future<void> _saveAttendance({
    required String userId,
    required double confidence,
  }) async {
    final userDoc = await _db.collection('users').doc(userId).get();
    final studentId = userDoc.data()?['studentId'] as String? ?? '';

    await _db.collection('attendance').add({
      'userId': userId,
      'studentId': studentId,
      'subjectId': 'default',
      'timestamp': FieldValue.serverTimestamp(),
      'faceMatchConfidence': confidence,
      'status': 'present',
      'markedBy': 'face',
      'deviceInfo': 'mobile',
    });
  }

  Future<Map<String, dynamic>?> getFaceQuality() async {
    if (_capturedImagePath == null || !_mlKitService.isInitialized) return null;
    return await _mlKitService.checkFaceQuality(_capturedImagePath!);
  }

  void reset() {
    _state = FaceRecognitionState.initial;
    _capturedImagePath = null;
    _faceEmbedding = null;
    _error = null;
    _registrationProgress = 0;
    notifyListeners();
  }

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
