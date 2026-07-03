import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:smart_attendance/data/datasources/auth_remote_datasource.dart';
import 'package:smart_attendance/domain/entities/user.dart';
import 'package:smart_attendance/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._remoteDataSource, this._firebaseAuth);

  @override
  Future<User> loginWithEmail(String email, String password) async {
    return await _remoteDataSource.loginWithEmail(email, password);
  }

  @override
  Future<User> registerWithEmail(
    String email,
    String password,
    String name,
    String studentId,
  ) async {
    return await _remoteDataSource.registerWithEmail(
      email,
      password,
      name,
      studentId,
    );
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }

  @override
  Future<User?> getCurrentUser() async {
    return await _remoteDataSource.getCurrentUser();
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return _firebaseAuth.currentUser != null;
  }
}
