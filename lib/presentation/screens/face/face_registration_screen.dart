import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/core/constants/app_constants.dart';
import 'package:smart_attendance/core/constants/color_constants.dart';
import 'package:smart_attendance/core/constants/string_constants.dart';
import 'package:smart_attendance/presentation/providers/face_recognition_provider.dart';
import 'package:smart_attendance/presentation/widgets/common/custom_button.dart';
import 'package:smart_attendance/presentation/widgets/face/camera_preview_widget.dart';

class FaceRegistrationScreen extends StatefulWidget {
  const FaceRegistrationScreen({super.key});

  @override
  State<FaceRegistrationScreen> createState() => _FaceRegistrationScreenState();
}

class _FaceRegistrationScreenState extends State<FaceRegistrationScreen> {
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final provider = context.read<FaceRecognitionProvider>();
    await provider.initializeCamera();
  }

  Future<void> _captureAndProcess() async {
    final provider = context.read<FaceRecognitionProvider>();
    final registered = await provider.registerCurrentUserFace();

    if (!mounted) return;

    if (registered) {
      _showSuccess();
    } else {
      _showError(provider.error ?? 'Failed to register face');
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
        content: Text(StringConstants.faceRegistered),
        backgroundColor: ColorConstants.successColor,
      ),
    );

    // Navigate back after short delay
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
        title: const Text(StringConstants.registerFace),
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

          if (provider.state == FaceRecognitionState.processed) {
            return _buildSuccessView();
          }

          return Column(
            children: [
              Expanded(
                child: CameraPreviewWidget(
                  controller: provider.cameraService.controller!,
                  message: provider.state == FaceRecognitionState.loading
                      ? 'Capturing sample ${provider.registrationProgress + 1} of ${AppConstants.faceCaptureCount}. Keep your face steady.'
                      : 'Position your face within the oval',
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                color: ColorConstants.white,
                child: Column(
                  children: [
                    Text(
                      provider.state == FaceRecognitionState.loading
                          ? 'Training Face Template'
                          : 'Face Registration',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.state == FaceRecognitionState.loading
                          ? 'The app is capturing multiple samples to build your face embedding.'
                          : 'Make sure your face is well-lit and clearly visible',
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorConstants.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (provider.state == FaceRecognitionState.loading) ...[
                      LinearProgressIndicator(
                        value: provider.registrationProgress /
                            AppConstants.faceCaptureCount,
                      ),
                      const SizedBox(height: 16),
                    ],
                    CustomButton(
                      label: StringConstants.captureFace,
                      icon: Icons.camera_alt,
                      isLoading: provider.state == FaceRecognitionState.loading,
                      onPressed: _captureAndProcess,
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
              color: ColorConstants.successColor.withValues(alpha: 0.1),
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
            'Face Registered Successfully!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Your face has been registered. You can now use face recognition for attendance.',
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
