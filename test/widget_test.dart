import 'package:flutter_test/flutter_test.dart';
import 'package:smart_attendance/main.dart';

void main() {
  testWidgets('SmartAttendanceApp displays home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SmartAttendanceApp());
    expect(find.text('Smart Attendance'), findsOneWidget);
    expect(find.text('Project Structure Created!'), findsOneWidget);
  });
}
