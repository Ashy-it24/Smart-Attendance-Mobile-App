import 'dart:math' as math;

class FaceUtils {
  /// Calculate cosine similarity between two face embeddings
  /// Returns a value between -1 and 1, where 1 means identical
  static double cosineSimilarity(List<double> embedding1, List<double> embedding2) {
    if (embedding1.length != embedding2.length) {
      throw Exception('Embeddings must have same length');
    }

    double dotProduct = 0.0;
    double magnitude1 = 0.0;
    double magnitude2 = 0.0;

    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
      magnitude1 += embedding1[i] * embedding1[i];
      magnitude2 += embedding2[i] * embedding2[i];
    }

    magnitude1 = math.sqrt(magnitude1);
    magnitude2 = math.sqrt(magnitude2);

    if (magnitude1 == 0 || magnitude2 == 0) {
      return 0.0;
    }

    return dotProduct / (magnitude1 * magnitude2);
  }

  /// Calculate Euclidean distance between two embeddings
  /// Lower distance = more similar
  static double euclideanDistance(List<double> embedding1, List<double> embedding2) {
    if (embedding1.length != embedding2.length) {
      throw Exception('Embeddings must have same length');
    }

    double sum = 0.0;
    for (int i = 0; i < embedding1.length; i++) {
      final diff = embedding1[i] - embedding2[i];
      sum += diff * diff;
    }

    return math.sqrt(sum);
  }

  /// Check if two faces match based on similarity threshold
  static bool isSamePerson({
    required List<double> embedding1,
    required List<double> embedding2,
    double threshold = 0.8,
  }) {
    final similarity = cosineSimilarity(embedding1, embedding2);
    return similarity >= threshold;
  }

  /// Normalize embedding to unit vector
  static List<double> normalizeEmbedding(List<double> embedding) {
    double magnitude = 0.0;
    for (final value in embedding) {
      magnitude += value * value;
    }
    magnitude = math.sqrt(magnitude);

    if (magnitude == 0) {
      return embedding;
    }

    return embedding.map((value) => value / magnitude).toList();
  }

  /// Find best match from a list of stored embeddings
  /// Returns index of best match and similarity score
  static Map<String, dynamic>? findBestMatch({
    required List<double> queryEmbedding,
    required List<List<double>> storedEmbeddings,
    double threshold = 0.8,
  }) {
    if (storedEmbeddings.isEmpty) {
      return null;
    }

    double maxSimilarity = -1.0;
    int bestMatchIndex = -1;

    for (int i = 0; i < storedEmbeddings.length; i++) {
      final similarity = cosineSimilarity(queryEmbedding, storedEmbeddings[i]);
      if (similarity > maxSimilarity) {
        maxSimilarity = similarity;
        bestMatchIndex = i;
      }
    }

    if (maxSimilarity >= threshold) {
      return {
        'index': bestMatchIndex,
        'similarity': maxSimilarity,
      };
    }

    return null;
  }
}
