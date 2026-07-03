import 'package:smart_attendance/domain/entities/user.dart';
import 'package:smart_attendance/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> call({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String studentId,
  }) async {
    // Validate input
    if (email.isEmpty || password.isEmpty || name.isEmpty || studentId.isEmpty) {
      throw Exception('All fields are required');
    }

    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    if (name.length < 3) {
      throw Exception('Name must be at least 3 characters');
    }

    // Call repository
    return await repository.registerWithEmail(
      email,
      password,
      name,
      studentId,
    );
  }
}
