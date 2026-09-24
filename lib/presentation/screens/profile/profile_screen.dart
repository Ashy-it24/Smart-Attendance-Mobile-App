import 'package:flutter/material.dart';
import 'package:smart_attendance/core/constants/color_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Picture
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: ColorConstants.grey200,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                size: 60,
                color: ColorConstants.grey500,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'STU001234',
              style: TextStyle(
                fontSize: 14,
                color: ColorConstants.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoSection(
              'Email',
              'john.doe@university.edu',
            ),
            _buildInfoSection(
              'Department',
              'Computer Science',
            ),
            _buildInfoSection(
              'Semester',
              '4th',
            ),
            _buildInfoSection(
              'Role',
              'Student',
            ),
            const SizedBox(height: 32),
            _buildSettingTile(
              context,
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: () {},
            ),
            _buildSettingTile(
              context,
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () {},
            ),
            _buildSettingTile(
              context,
              icon: Icons.notification_important_outlined,
              title: 'Notifications',
              onTap: () {},
            ),
            _buildSettingTile(
              context,
              icon: Icons.info_outline,
              title: 'About',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.grey50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: ColorConstants.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorConstants.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ColorConstants.grey200,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: ColorConstants.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: ColorConstants.textPrimary,
                ),
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
