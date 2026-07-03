# Data Layer

This folder contains the data implementation details - models, repositories, and data sources.

## Structure

### datasources/
Remote and local data sources that fetch data from Firebase or local storage:
- **auth_remote_datasource.dart** - Firebase Authentication operations
- **attendance_remote_datasource.dart** - Firestore attendance operations
- **face_local_datasource.dart** - Local storage for face embeddings

### models/
Data models that extend domain entities and include JSON serialization:
- **user_model.dart** - User data model with fromJson/toJson
- **attendance_model.dart** - Attendance record model
- **face_embedding_model.dart** - Face embedding data model

### repositories/
Implementation of repository interfaces defined in the domain layer:
- **auth_repository_impl.dart** - Authentication repository implementation
- **attendance_repository_impl.dart** - Attendance repository implementation
- **face_repository_impl.dart** - Face recognition repository implementation

## Purpose

The data layer is responsible for:
- Fetching data from external sources (Firebase)
- Storing data locally when needed
- Converting between data models and domain entities
- Implementing repository contracts from the domain layer
