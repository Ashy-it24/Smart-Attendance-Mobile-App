import 'package:flutter/material.dart';
import 'package:smart_attendance/core/constants/color_constants.dart';
import 'package:smart_attendance/core/constants/string_constants.dart';
import 'package:smart_attendance/presentation/widgets/common/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.appName),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorConstants.primaryColor,
                    ColorConstants.primaryLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: ColorConstants.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your attendance is up to date',
                    style: TextStyle(
                      color: ColorConstants.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard('95%', 'Attendance'),
                      _buildStatCard('12', 'Present'),
                      _buildStatCard('1', 'Absent'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              icon: Icons.camera_alt_outlined,
              title: StringConstants.markAttendance,
              subtitle: 'Mark attendance with face recognition',
              onTap: () {
                Navigator.of(context).pushNamed('/mark-attendance');
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              context,
              icon: Icons.face_outlined,
              title: StringConstants.registerFace,
              subtitle: 'Register or update your face',
              onTap: () {
                Navigator.of(context).pushNamed('/face-register');
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              context,
              icon: Icons.history_outlined,
              title: StringConstants.attendanceHistory,
              subtitle: 'View your attendance records',
              onTap: () {
                Navigator.of(context).pushNamed('/attendance-history');
              },
            ),
            const SizedBox(height: 32),
            CustomButton(
              label: StringConstants.logout,
              backgroundColor: ColorConstants.errorColor,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: ColorConstants.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: ColorConstants.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: ColorConstants.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorConstants.surfaceColor,
          border: Border.all(color: ColorConstants.grey200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: ColorConstants.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: ColorConstants.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorConstants.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
              color: ColorConstants.grey400,
            ),
          ],
        ),
      ),
    );
  }
}
