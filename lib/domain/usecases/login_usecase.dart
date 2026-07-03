import 'package:smart_attendance/domain/entities/user.dart';
import 'package:smart_attendance/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) async {
    // Validate input
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Call repository
    return await repository.loginWithEmail(email, password);
  }
}
