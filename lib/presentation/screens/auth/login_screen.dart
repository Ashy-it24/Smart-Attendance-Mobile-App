import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/core/constants/color_constants.dart';
import 'package:smart_attendance/core/constants/string_constants.dart';
import 'package:smart_attendance/presentation/providers/auth_provider.dart';
import 'package:smart_attendance/presentation/widgets/common/custom_button.dart';
import 'package:smart_attendance/presentation/widgets/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  void _handleLogin(AppAuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      final success = await authProvider.login(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
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
        title: const Text(StringConstants.login),
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
                const SizedBox(height: 40),
                const Center(
                  child: Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: ColorConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  StringConstants.login,
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
                      color: ColorConstants.errorColor.withOpacity(0.1),
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
                  label: StringConstants.email,
                  hint: 'student@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  prefixIcon: Icons.email_outlined,
                  enabled: !authProvider.isLoading,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: StringConstants.password,
                  controller: _passwordController,
                  obscureText: true,
                  validator: _validatePassword,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: Icons.visibility_outlined,
                  enabled: !authProvider.isLoading,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: !authProvider.isLoading ? () {} : null,
                    child: const Text(
                      StringConstants.forgotPassword,
                      style: TextStyle(color: ColorConstants.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: StringConstants.login,
                  isLoading: authProvider.isLoading,
                  isEnabled: !authProvider.isLoading,
                  onPressed: () => _handleLogin(authProvider),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(StringConstants.dontHaveAccount),
                    TextButton(
                      onPressed: !authProvider.isLoading
                          ? () {
                              Navigator.of(context).pushNamed('/register');
                            }
                          : null,
                      child: const Text(
                        StringConstants.register,
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
