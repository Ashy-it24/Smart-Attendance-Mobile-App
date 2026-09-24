import 'package:flutter/material.dart';
import 'package:smart_attendance/core/constants/color_constants.dart';
import 'package:smart_attendance/core/constants/string_constants.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.attendanceHistory),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAttendanceCard(
            date: '2024-01-15',
            time: '09:30 AM',
            subject: 'Introduction to Flutter',
            status: StringConstants.present,
            statusColor: ColorConstants.successColor,
          ),
          _buildAttendanceCard(
            date: '2024-01-14',
            time: '02:00 PM',
            subject: 'Advanced Dart Programming',
            status: StringConstants.present,
            statusColor: ColorConstants.successColor,
          ),
          _buildAttendanceCard(
            date: '2024-01-13',
            time: '---',
            subject: 'Database Design',
            status: StringConstants.absent,
            statusColor: ColorConstants.errorColor,
          ),
          _buildAttendanceCard(
            date: '2024-01-12',
            time: '09:45 AM',
            subject: 'Web Development',
            status: StringConstants.late,
            statusColor: ColorConstants.warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard({
    required String date,
    required String time,
    required String subject,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstants.grey200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              status == StringConstants.present
                  ? Icons.check_circle_outline
                  : status == StringConstants.absent
                      ? Icons.cancel_outlined
                      : Icons.schedule_outlined,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$date at $time',
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
