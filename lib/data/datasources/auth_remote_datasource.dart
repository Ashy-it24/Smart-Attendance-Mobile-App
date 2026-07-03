import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:smart_attendance/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail(String email, String password);
  Future<UserModel> registerWithEmail(
    String email,
    String password,
    String name,
    String studentId,
  );
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserModel> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('User not found');

      return UserModel(
        userId: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        studentId: '', // Will be fetched from Firestore
        role: 'student',
        isActive: true,
        createdAt: DateTime.now(),
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<UserModel> registerWithEmail(
    String email,
    String password,
    String name,
    String studentId,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('User creation failed');

      // Set display name
      await user.updateDisplayName(name);

      return UserModel(
        userId: user.uid,
        email: email,
        name: name,
        studentId: studentId,
        role: 'student',
        isActive: true,
        createdAt: DateTime.now(),
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;

      return UserModel(
        userId: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        studentId: '',
        role: 'student',
        isActive: true,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  /// Handle Firebase Auth exceptions
  Exception _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email');
      case 'wrong-password':
        return Exception('Incorrect password');
      case 'email-already-in-use':
        return Exception('Email is already in use');
      case 'weak-password':
        return Exception('Password is too weak');
      case 'invalid-email':
        return Exception('Email is invalid');
      case 'user-disabled':
        return Exception('User account has been disabled');
      default:
        return Exception('Authentication error: ${e.message}');
    }
  }
}
