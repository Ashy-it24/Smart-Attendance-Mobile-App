import 'package:intl/intl.dart';

class DateUtils {
  /// Format DateTime to display format (e.g., "10 Jan 2024")
  static String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  /// Format DateTime to time format (e.g., "2:30 PM")
  static String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  /// Format DateTime to full format (e.g., "10 Jan 2024, 2:30 PM")
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('d MMM yyyy, h:mm a').format(dateTime);
  }

  /// Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get time difference in minutes
  static int getMinutesDifference(DateTime from, DateTime to) {
    return to.difference(from).inMinutes;
  }

  /// Check if time is between two times (as HH:mm strings)
  static bool isTimeBetween(
    String time,
    String startTime,
    String endTime,
  ) {
    final int timeInMinutes = _timeStringToMinutes(time);
    final int startInMinutes = _timeStringToMinutes(startTime);
    final int endInMinutes = _timeStringToMinutes(endTime);

    return timeInMinutes >= startInMinutes && timeInMinutes <= endInMinutes;
  }

  /// Convert time string "HH:mm" to minutes
  static int _timeStringToMinutes(String time) {
    final parts = time.split(':');
    final int hours = int.parse(parts[0]);
    final int minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }
}
