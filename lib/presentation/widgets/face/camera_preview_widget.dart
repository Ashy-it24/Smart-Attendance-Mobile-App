import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendance/core/constants/color_constants.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;
  final String? message;

  const CameraPreviewWidget({
    super.key,
    required this.controller,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        // Camera preview
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(controller),
        ),
        
        // Face detection overlay
        CustomPaint(
          size: Size.infinite,
          painter: FaceOverlayPainter(),
        ),
        
        // Message overlay
        if (message != null)
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConstants.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message!,
                style: const TextStyle(
                  color: ColorConstants.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// Custom painter for face detection overlay
class FaceOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorConstants.primaryColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw oval guide for face positioning
    final center = Offset(size.width / 2, size.height / 2);
    final ovalRect = Rect.fromCenter(
      center: center,
      width: size.width * 0.7,
      height: size.height * 0.5,
    );

    canvas.drawOval(ovalRect, paint);

    // Draw corner markers
    final cornerPaint = Paint()
      ..color = ColorConstants.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final cornerLength = 30.0;

    // Top-left
    canvas.drawLine(
      Offset(ovalRect.left, ovalRect.top + cornerLength),
      Offset(ovalRect.left, ovalRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(ovalRect.left, ovalRect.top),
      Offset(ovalRect.left + cornerLength, ovalRect.top),
      cornerPaint,
    );

    // Top-right
    canvas.drawLine(
      Offset(ovalRect.right - cornerLength, ovalRect.top),
      Offset(ovalRect.right, ovalRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(ovalRect.right, ovalRect.top),
      Offset(ovalRect.right, ovalRect.top + cornerLength),
      cornerPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(ovalRect.left, ovalRect.bottom - cornerLength),
      Offset(ovalRect.left, ovalRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(ovalRect.left, ovalRect.bottom),
      Offset(ovalRect.left + cornerLength, ovalRect.bottom),
      cornerPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(ovalRect.right - cornerLength, ovalRect.bottom),
      Offset(ovalRect.right, ovalRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(ovalRect.right, ovalRect.bottom - cornerLength),
      Offset(ovalRect.right, ovalRect.bottom),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
