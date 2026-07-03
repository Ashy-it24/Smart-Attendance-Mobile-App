class Attendance {
  final String attendanceId;
  final String userId;
  final String studentId;
  final String subjectId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double faceMatchConfidence;
  final String status; // 'present', 'absent', 'late'
  final String markedBy; // 'face', 'manual'
  final String? deviceInfo;

  Attendance({
    required this.attendanceId,
    required this.userId,
    required this.studentId,
    required this.subjectId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.faceMatchConfidence,
    required this.status,
    required this.markedBy,
    this.deviceInfo,
  });

  Attendance copyWith({
    String? attendanceId,
    String? userId,
    String? studentId,
    String? subjectId,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? faceMatchConfidence,
    String? status,
    String? markedBy,
    String? deviceInfo,
  }) {
    return Attendance(
      attendanceId: attendanceId ?? this.attendanceId,
      userId: userId ?? this.userId,
      studentId: studentId ?? this.studentId,
      subjectId: subjectId ?? this.subjectId,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      faceMatchConfidence: faceMatchConfidence ?? this.faceMatchConfidence,
      status: status ?? this.status,
      markedBy: markedBy ?? this.markedBy,
      deviceInfo: deviceInfo ?? this.deviceInfo,
    );
  }

  @override
  String toString() =>
      'Attendance(attendanceId: $attendanceId, status: $status, timestamp: $timestamp)';
}
