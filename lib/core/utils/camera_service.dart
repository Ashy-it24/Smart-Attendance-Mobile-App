import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  CameraController? get controller => _controller;

  /// Initialize camera
  Future<void> initialize() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No cameras found');
      }

      // Use front camera for face recognition
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize camera: $e');
    }
  }

  /// Capture image and return file path
  Future<String> captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      final XFile image = await _controller!.takePicture();
      return image.path;
    } catch (e) {
      throw Exception('Failed to capture image: $e');
    }
  }

  /// Preprocess image for face recognition
  Future<img.Image> preprocessImage(String imagePath) async {
    final File imageFile = File(imagePath);
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize to 112x112 (standard for face recognition)
    final resized = img.copyResize(
      image,
      width: 112,
      height: 112,
    );

    return resized;
  }

  /// Convert image to normalized float array for ML model
  List<List<List<List<double>>>> imageToArray(img.Image image) {
    final array = List.generate(
      1,
      (_) => List.generate(
        112,
        (y) => List.generate(
          112,
          (x) => List.generate(3, (c) {
            final pixel = image.getPixel(x, y);
            final value = c == 0
                ? pixel.r.toDouble()
                : c == 1
                    ? pixel.g.toDouble()
                    : pixel.b.toDouble();
            // Normalize to [-1, 1]
            return (value - 127.5) / 127.5;
          }),
        ),
      ),
    );
    return array;
  }

  /// Save captured image to storage
  Future<String> saveImage(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'face_$timestamp.jpg';
      final savedPath = '${directory.path}/$fileName';

      final File imageFile = File(imagePath);
      await imageFile.copy(savedPath);

      return savedPath;
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  /// Dispose camera resources
  Future<void> dispose() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
      _isInitialized = false;
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) {
      return;
    }

    final currentCamera = _controller?.description;
    final newCamera = _cameras!.firstWhere(
      (camera) => camera != currentCamera,
      orElse: () => _cameras!.first,
    );

    await dispose();

    _controller = CameraController(
      newCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    _isInitialized = true;
  }
}
