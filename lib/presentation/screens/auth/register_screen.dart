import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/core/constants/color_constants.dart';
import 'package:smart_attendance/core/constants/string_constants.dart';
import 'package:smart_attendance/presentation/providers/auth_provider.dart';
import 'package:smart_attendance/presentation/widgets/common/custom_button.dart';
import 'package:smart_attendance/presentation/widgets/common/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? _validateStudentId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Student ID is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) {
      return StringConstants.errorInvalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return StringConstants.errorPasswordShort;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return StringConstants.errorPasswordMismatch;
    }
    return null;
  }

  void _handleRegister(AppAuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      final success = await authProvider.register(
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        name: _nameController.text,
        studentId: _studentIdController.text,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(StringConstants.registerSuccess),
            backgroundColor: ColorConstants.successColor,
          ),
        );
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? StringConstants.errorGeneral),
            backgroundColor: ColorConstants.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.register),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Consumer<AppAuthProvider>(
            builder: (context, authProvider, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const Text(
                  StringConstants.register,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (authProvider.error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorConstants.errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorConstants.errorColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      authProvider.error!,
                      style: const TextStyle(
                        color: ColorConstants.errorColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                CustomTextField(
                  label: 'Full Name',
                  hint: 'John Doe',
                  controller: _nameController,
                  enabled: !authProvider.isLoading,
                  validator: _validateName,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Student ID',
                  hint: 'STU001234',
                  controller: _studentIdController,
                  enabled: !authProvider.isLoading,
                  validator: _validateStudentId,
                  prefixIcon: Icons.badge_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: StringConstants.email,
                  hint: 'student@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !authProvider.isLoading,
                  validator: _validateEmail,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: StringConstants.password,
                  controller: _passwordController,
                  obscureText: true,
                  enabled: !authProvider.isLoading,
                  validator: _validatePassword,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: Icons.visibility_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: StringConstants.confirmPassword,
                  controller: _confirmPasswordController,
                  obscureText: true,
                  enabled: !authProvider.isLoading,
                  validator: _validateConfirmPassword,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: Icons.visibility_outlined,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  label: StringConstants.register,
                  isLoading: authProvider.isLoading,
                  isEnabled: !authProvider.isLoading,
                  onPressed: () => _handleRegister(authProvider),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(StringConstants.alreadyHaveAccount),
                    TextButton(
                      onPressed: !authProvider.isLoading
                          ? () {
                              Navigator.of(context).pop();
                            }
                          : null,
                      child: const Text(
                        StringConstants.login,
                        style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
