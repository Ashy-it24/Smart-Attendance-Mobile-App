import 'package:smart_attendance/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> loginWithEmail(String email, String password);
  Future<User> registerWithEmail(
    String email,
    String password,
    String name,
    String studentId,
  );
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isUserLoggedIn();
}
