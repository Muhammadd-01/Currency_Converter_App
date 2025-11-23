import 'package:flutter/material.dart';
import '../../services/firebase_auth_service.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/glass_card.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = FirebaseAuthService();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.sendPasswordResetEmail(_emailController.text.trim());

      if (mounted) {
        setState(() {
          _emailSent = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Icon
                  const Icon(
                    Icons.lock_reset,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),

                  // Reset Password Form
                  GlassCard(
                    child: _emailSent
                        ? Column(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 64,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Email Sent!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'We\'ve sent a password reset link to:',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _emailController.text,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8E2DE2),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Please check your email and follow the instructions to reset your password.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              GradientButton(
                                text: 'Back to Login',
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          )
                        : Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Enter your email address and we\'ll send you a link to reset your password.',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Email Field
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email_outlined),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),

                                // Send Reset Link Button
                                GradientButton(
                                  text: 'Send Reset Link',
                                  onPressed:
                                      _isLoading ? null : _sendResetEmail,
                                  isLoading: _isLoading,
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
