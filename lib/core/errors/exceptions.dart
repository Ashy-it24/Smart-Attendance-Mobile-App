class AppException implements Exception {
  final String message;
  final String? code;

  AppException({required this.message, this.code});

  @override
  String toString() => message;
}

class FirebaseException extends AppException {
  FirebaseException({required super.message, super.code});
}

class NetworkException extends AppException {
  NetworkException({required super.message, super.code});
}

class AuthenticationException extends AppException {
  AuthenticationException({required super.message, super.code});
}

class PermissionException extends AppException {
  PermissionException({required super.message, super.code});
}

class CameraException extends AppException {
  CameraException({required super.message, super.code});
}

class LocationException extends AppException {
  LocationException({required super.message, super.code});
}
