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

  void _navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final authProvider = context.read<AppAuthProvider>();
        
        if (authProvider.isAuthenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: const Center(
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
