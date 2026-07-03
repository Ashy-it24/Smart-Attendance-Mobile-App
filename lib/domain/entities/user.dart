class User {
  final String userId;
  final String email;
  final String name;
  final String studentId;
  final String role; // 'student', 'teacher', 'admin'
  final String? department;
  final int? semester;
  final String? profilePicture;
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.userId,
    required this.email,
    required this.name,
    required this.studentId,
    required this.role,
    this.department,
    this.semester,
    this.profilePicture,
    required this.isActive,
    required this.createdAt,
  });

  /// Create a copy of User with modified fields
  User copyWith({
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
    return User(
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

  @override
  String toString() => 'User(userId: $userId, email: $email, name: $name)';
}
