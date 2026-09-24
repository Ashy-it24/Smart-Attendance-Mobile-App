import 'package:flutter/material.dart';
import 'package:smart_attendance/core/constants/color_constants.dart';
import 'package:smart_attendance/core/constants/string_constants.dart';
import 'package:smart_attendance/presentation/screens/attendance/attendance_history_screen.dart';
import 'package:smart_attendance/presentation/screens/home/home_screen.dart';
import 'package:smart_attendance/presentation/screens/profile/profile_screen.dart';

void main() {
  runApp(const SmartAttendancePreviewApp());
}

class SmartAttendancePreviewApp extends StatelessWidget {
  const SmartAttendancePreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${StringConstants.appName} Preview',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorConstants.primaryColor,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (_) => const HomeScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/attendance-history': (_) => const AttendanceHistoryScreen(),
        '/login': (_) => const _PreviewPlaceholderScreen(
              title: StringConstants.login,
              message: 'Firebase login is disabled in preview mode.',
            ),
        '/mark-attendance': (_) => const _PreviewPlaceholderScreen(
              title: StringConstants.markAttendance,
              message: 'Camera and face recognition require an Android device.',
            ),
        '/face-register': (_) => const _PreviewPlaceholderScreen(
              title: StringConstants.registerFace,
              message: 'Face registration requires an Android device.',
            ),
      },
    );
  }
}

class _PreviewPlaceholderScreen extends StatelessWidget {
  const _PreviewPlaceholderScreen({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.phone_android_outlined,
                color: ColorConstants.primaryColor,
                size: 72,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(
                  color: ColorConstants.textSecondary,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
