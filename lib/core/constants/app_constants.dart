class AppConstants {
  // API & Firebase
  static const String firebaseProjectId = 'smart-attendance-project';
  
  // Timeouts
  static const int requestTimeout = 30;
  static const int authTimeout = 20;
  
  // Face Recognition
  static const double faceMatchThreshold = 0.8;
  static const int faceCaptureCount = 5; // Number of face captures for registration
  
  // Geofencing
  static const double classroomRadius = 100.0; // meters
  static const int locationUpdateInterval = 5000; // milliseconds
  
  // Pagination
  static const int pageSize = 20;
  
  // Retry
  static const int maxRetries = 3;
}
