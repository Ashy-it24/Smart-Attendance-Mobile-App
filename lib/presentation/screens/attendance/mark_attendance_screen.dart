import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/core/constants/color_constants.dart';
import 'package:smart_attendance/core/constants/string_constants.dart';
import 'package:smart_attendance/presentation/providers/face_recognition_provider.dart';
import 'package:smart_attendance/presentation/widgets/common/custom_button.dart';
import 'package:smart_attendance/presentation/widgets/face/camera_preview_widget.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  bool _isVerifying = false;
  bool _isVerified = false;
  double _matchConfidence = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final provider = context.read<FaceRecognitionProvider>();
    await provider.initializeCamera();
  }

  Future<void> _verifyAndMarkAttendance() async {
    setState(() => _isVerifying = true);

    final provider = context.read<FaceRecognitionProvider>();

    // Step 1: Capture image
    final captured = await provider.captureImage();
    if (!captured) {
      _showError(provider.error ?? 'Failed to capture image');
      setState(() => _isVerifying = false);
      return;
    }

    // Step 2: Generate embedding
    final processed = await provider.generateEmbedding();
    if (!processed) {
      _showError(provider.error ?? 'Face not detected');
      setState(() => _isVerifying = false);
      return;
    }

    // Step 3: Compare with stored embedding (simulated)
    // TODO: Fetch stored embedding from Firestore
    final storedEmbedding = List.generate(512, (i) => 0.5 + (i % 100) / 200);
    
    final result = await provider.compareFace(storedEmbedding);
    
    if (result != null && result['match'] == true) {
      setState(() {
        _isVerified = true;
        _matchConfidence = result['similarity'];
        _isVerifying = false;
      });

      // Step 4: Check location (to be implemented in Phase 9)
      // For now, assume location is valid

      // Step 5: Mark attendance
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        _showSuccess();
      }
    } else {
      setState(() => _isVerifying = false);
      _showError(StringConstants.faceNotDetected);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ColorConstants.errorColor,
      ),
    );
  }

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(StringConstants.attendanceMarked),
        backgroundColor: ColorConstants.successColor,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    context.read<FaceRecognitionProvider>().disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.markAttendance),
        centerTitle: true,
      ),
      body: Consumer<FaceRecognitionProvider>(
        builder: (context, provider, _) {
          if (!provider.isCameraInitialized) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Initializing camera...'),
                ],
              ),
            );
          }

          if (_isVerified) {
            return _buildSuccessView();
          }

          return Column(
            children: [
              Expanded(
                child: CameraPreviewWidget(
                  controller: provider.cameraService.controller!,
                  message: _isVerifying
                      ? 'Verifying face...'
                      : 'Position your face to mark attendance',
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                color: ColorConstants.white,
                child: Column(
                  children: [
                    const Text(
                      'Face Verification',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your face will be verified before marking attendance',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorConstants.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      label: StringConstants.markAttendance,
                      icon: Icons.check_circle_outline,
                      isLoading: _isVerifying,
                      onPressed: _verifyAndMarkAttendance,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: ColorConstants.successColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: ColorConstants.successColor,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Attendance Marked!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Match Confidence: ${(_matchConfidence * 100).toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 16,
              color: ColorConstants.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Your attendance has been recorded successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: ColorConstants.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
