import 'package:image/image.dart' as img;

class TFLiteService {
  bool get isInitialized => false;

  Future<void> initialize() async {
    throw UnsupportedError('TFLite is not available on web');
  }

  Future<List<double>> generateEmbedding(img.Image image) async {
    throw UnsupportedError('TFLite is not available on web');
  }

  List<int> getInputShape() => [];

  List<int> getOutputShape() => [];

  void dispose() {}
}
