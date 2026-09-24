import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_attendance/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.userId,
    required super.email,
    required super.name,
    required super.studentId,
    required super.role,
    super.department,
    super.semester,
    super.profilePicture,
    required super.isActive,
    required super.createdAt,
  });

  /// Convert JSON from Firestore to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      studentId: json['studentId'] as String,
      role: json['role'] as String? ?? 'student',
      department: json['department'] as String?,
      semester: json['semester'] as int?,
      profilePicture: json['profilePicture'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  /// Convert UserModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'studentId': studentId,
      'role': role,
      'department': department,
      'semester': semester,
      'profilePicture': profilePicture,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'studentId': studentId,
      'role': role,
      'department': department,
      'semester': semester,
      'profilePicture': profilePicture,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    if (value is DateTime) return value;
    return DateTime.now();
  }

  /// Create a copy of UserModel with modified fields
  @override
  UserModel copyWith({
    String? userId,
    String? email,
    String? name,
    String? studentId,
    String? role,
    String? department,
    int? semester,
    String? profilePicture,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      studentId: studentId ?? this.studentId,
      role: role ?? this.role,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      profilePicture: profilePicture ?? this.profilePicture,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
