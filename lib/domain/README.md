# Domain Layer

This is the innermost layer containing business logic and rules. It's independent of any framework or external library.

## Structure

### entities/
Pure Dart classes representing business objects:
- **user.dart** - User entity with core properties
- **attendance.dart** - Attendance entity
- **face_embedding.dart** - Face embedding entity

### repositories/
Abstract interfaces (contracts) for repositories:
- **auth_repository.dart** - Authentication methods contract
- **attendance_repository.dart** - Attendance operations contract
- **face_repository.dart** - Face recognition contract

### usecases/
Business logic encapsulated in use cases (one use case = one action):
- **login_usecase.dart** - Handle user login logic
- **mark_attendance_usecase.dart** - Mark attendance with validation
- **register_face_usecase.dart** - Register user face embedding

## Purpose

The domain layer:
- Contains business logic independent of UI and data sources
- Defines contracts that outer layers must implement
- Ensures the app's core functionality remains testable and maintainable
- Follows the Dependency Inversion Principle
