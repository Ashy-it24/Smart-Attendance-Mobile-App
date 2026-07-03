import 'package:flutter/material.dart';
import 'package:smart_attendance/presentation/screens/attendance/attendance_history_screen.dart';
import 'package:smart_attendance/presentation/screens/attendance/mark_attendance_screen.dart';
import 'package:smart_attendance/presentation/screens/auth/login_screen.dart';
import 'package:smart_attendance/presentation/screens/auth/register_screen.dart';
import 'package:smart_attendance/presentation/screens/face/face_registration_screen.dart';
import 'package:smart_attendance/presentation/screens/home/home_screen.dart';
import 'package:smart_attendance/presentation/screens/profile/profile_screen.dart';
import 'package:smart_attendance/presentation/screens/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String markAttendance = '/mark-attendance';
  static const String attendanceHistory = '/attendance-history';
  static const String faceRegister = '/face-register';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );
      case AppRoutes.markAttendance:
        return MaterialPageRoute(
          builder: (_) => const MarkAttendanceScreen(),
        );
      case AppRoutes.attendanceHistory:
        return MaterialPageRoute(
          builder: (_) => const AttendanceHistoryScreen(),
        );
      case AppRoutes.faceRegister:
        return MaterialPageRoute(
          builder: (_) => const FaceRegistrationScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
