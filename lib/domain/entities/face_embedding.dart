class FaceEmbedding {
  final String embeddingId;
  final String userId;
  final List<double> embedding; // 512-dimensional vector
  final double confidence;
  final DateTime createdAt;
  final bool isActive;

  FaceEmbedding({
    required this.embeddingId,
    required this.userId,
    required this.embedding,
    required this.confidence,
    required this.createdAt,
    required this.isActive,
  });

  FaceEmbedding copyWith({
    String? embeddingId,
    String? userId,
    List<double>? embedding,
    double? confidence,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return FaceEmbedding(
      embeddingId: embeddingId ?? this.embeddingId,
      userId: userId ?? this.userId,
      embedding: embedding ?? this.embedding,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() =>
      'FaceEmbedding(embeddingId: $embeddingId, userId: $userId, confidence: $confidence)';
}
