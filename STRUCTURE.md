# Project Structure Documentation

This document explains the complete folder structure and architecture of the Smart Attendance System.

## 📁 Root Structure

```
Smart-Attendance-Mobile-App/
├── android/                    # Android platform-specific code
├── ios/                        # iOS platform-specific code
├── assets/                     # Static assets (images, models, icons)
├── lib/                        # Main application code
├── test/                       # Test files
├── .gitignore                  # Git ignore rules
├── pubspec.yaml               # Project dependencies
└── README.md                  # Project overview
```

## 📱 lib/ Directory (Main Application Code)

```
lib/
├── core/                       # Core utilities and constants
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── color_constants.dart
│   │   └── string_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart
│   └── utils/
│       ├── date_utils.dart
│       ├── location_utils.dart
│       └── face_utils.dart
│
├── data/                       # Data Layer
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   ├── attendance_remote_datasource.dart
│   │   └── face_local_datasource.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── attendance_model.dart
│   │   └── face_embedding_model.dart
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── attendance_repository_impl.dart
│       └── face_repository_impl.dart
│
├── domain/                     # Business Logic Layer
│   ├── entities/
│   │   ├── user.dart
│   │   ├── attendance.dart
│   │   └── face_embedding.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── attendance_repository.dart
│   │   └── face_repository.dart
│   └── usecases/
│       ├── login_usecase.dart
│       ├── mark_attendance_usecase.dart
│       └── register_face_usecase.dart
│
├── presentation/               # UI Layer
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── attendance_provider.dart
│   │   └── face_provider.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── attendance/
│   │   │   ├── mark_attendance_screen.dart
│   │   │   └── attendance_history_screen.dart
│   │   ├── face/
│   │   │   └── face_registration_screen.dart
│   │   ├── admin/
│   │   │   └── admin_dashboard_screen.dart
│   │   └── profile/
│   │       └── profile_screen.dart
│   └── widgets/
│       ├── common/
│       │   ├── custom_button.dart
│       │   ├── custom_text_field.dart
│       │   └── loading_widget.dart
│       ├── face/
│       │   ├── camera_preview_widget.dart
│       │   └── face_detection_overlay.dart
│       └── attendance/
│           ├── attendance_card.dart
│           └── attendance_chart.dart
│
├── routes/                     # Navigation
│   ├── app_routes.dart
│   └── route_generator.dart
│
└── main.dart                   # Application entry point
```

## 🏗️ Architecture Overview

### Clean Architecture Layers

1. **Presentation Layer** (lib/presentation/)
   - Handles UI rendering and user interactions
   - Uses Provider for state management
   - Depends on Domain layer

2. **Domain Layer** (lib/domain/)
   - Contains business logic and rules
   - Independent of frameworks and UI
   - Defines interfaces for data access

3. **Data Layer** (lib/data/)
   - Implements domain interfaces
   - Handles data from Firebase and local storage
   - Manages data transformations

4. **Core Layer** (lib/core/)
   - Shared utilities and constants
   - Used by all other layers

### Data Flow

```
User Interaction
    ↓
Screen (Presentation)
    ↓
Provider (State Management)
    ↓
UseCase (Domain)
    ↓
Repository Interface (Domain)
    ↓
Repository Implementation (Data)
    ↓
DataSource (Data)
    ↓
Firebase / Local Storage
```

## 📦 Assets Structure

```
assets/
├── images/               # App images and logos
├── models/              # TensorFlow Lite models
└── icons/               # Custom icons
```

## 🧪 Test Structure

```
test/
├── unit/                # Unit tests
├── widget/              # Widget tests
└── integration/         # Integration tests
```

## 🔑 Key Principles

1. **Separation of Concerns** - Each layer has a specific responsibility
2. **Dependency Rule** - Inner layers don't depend on outer layers
3. **Testability** - Business logic is easily testable
4. **Scalability** - Easy to add new features
5. **Maintainability** - Clean, organized code structure

## 📝 Naming Conventions

- **Files**: snake_case (e.g., user_model.dart)
- **Classes**: PascalCase (e.g., UserModel)
- **Variables**: camelCase (e.g., userName)
- **Constants**: UPPER_SNAKE_CASE (e.g., MAX_DISTANCE)
- **Private members**: prefix with _ (e.g., _privateMethod)

## 🚀 Next Steps

1. Phase 2: Flutter Setup & Installation
2. Phase 3: Implement core constants and utilities
3. Phase 4: Build UI screens
4. Phase 5: Firebase integration
5. Continue with remaining phases...
