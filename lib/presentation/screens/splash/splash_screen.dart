import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/core/constants/color_constants.dart';
import 'package:smart_attendance/core/constants/string_constants.dart';
import 'package:smart_attendance/presentation/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    final authProvider = context.read<AppAuthProvider>();

    // Wait for auth check to complete (max 5 seconds)
    int waited = 0;
    while (authProvider.state == AuthState.initial ||
        authProvider.state == AuthState.loading) {
      await Future.delayed(const Duration(milliseconds: 100));
      waited += 100;
      if (waited >= 5000) break;
    }

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_outlined,
              size: 80,
              color: ColorConstants.white,
            ),
            SizedBox(height: 24),
            Text(
              StringConstants.appName,
              style: TextStyle(
                color: ColorConstants.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Attendance Management System',
              style: TextStyle(
                color: ColorConstants.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorConstants.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
