# Presentation Layer

This folder contains all UI-related code including screens, widgets, and state management.

## Structure

### providers/
State management using Provider pattern:
- **auth_provider.dart** - Authentication state management
- **attendance_provider.dart** - Attendance state management
- **face_provider.dart** - Face recognition state management

### screens/
Full-screen pages organized by feature:

#### auth/
- **login_screen.dart** - User login page
- **register_screen.dart** - User registration page

#### home/
- **home_screen.dart** - Main dashboard

#### attendance/
- **mark_attendance_screen.dart** - Attendance marking with camera
- **attendance_history_screen.dart** - View past attendance records

#### face/
- **face_registration_screen.dart** - Register face for recognition

#### admin/
- **admin_dashboard_screen.dart** - Admin panel with analytics

#### profile/
- **profile_screen.dart** - User profile and settings

### widgets/
Reusable UI components:

#### common/
- **custom_button.dart** - Styled button widget
- **custom_text_field.dart** - Styled text input widget
- **loading_widget.dart** - Loading indicator

#### face/
- **camera_preview_widget.dart** - Camera preview for face capture
- **face_detection_overlay.dart** - Visual overlay during face detection

#### attendance/
- **attendance_card.dart** - Card showing attendance record
- **attendance_chart.dart** - Chart for attendance visualization

## Purpose

The presentation layer:
- Displays data to users
- Handles user interactions
- Manages UI state
- Communicates with domain layer through use cases
