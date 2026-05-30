import 'package:flutter/material.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/components/shared/custom_text_field.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/utils/validators.dart';

class ForgotPasswordOtpStep extends StatefulWidget {
  final String email;
  final List<Object?> mutationKey;
  final VoidCallback onBack;
  final void Function(String otp, String password) onSubmit;
  final VoidCallback onResend;

  const ForgotPasswordOtpStep({
    super.key,
    required this.email,
    required this.mutationKey,
    required this.onBack,
    required this.onSubmit,
    required this.onResend,
  });

  @override
  State<ForgotPasswordOtpStep> createState() => _ForgotPasswordOtpStepState();
}

class _ForgotPasswordOtpStepState extends State<ForgotPasswordOtpStep> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MutationLoadingOverlay(
      mutationKey: widget.mutationKey,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: widget.onBack, icon: const Icon(Icons.arrow_back)),
              Text('Reset password for ${widget.email}'),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _otpController,
                labelText: 'OTP',
                keyboardType: TextInputType.number,
                validator: (v) => Validators.validateOtp(v),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                labelText: 'New password',
                obscureText: true,
                validator: Validators.validateSignupPassword,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmController,
                labelText: 'Confirm password',
                obscureText: true,
                validator: (v) => Validators.validateConfirmPassword(
                  v,
                  _passwordController.text,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Reset password',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(
                      _otpController.text.trim(),
                      _passwordController.text.trim(),
                    );
                  }
                },
              ),
              TextButton(onPressed: widget.onResend, child: const Text('Resend OTP')),
            ],
          ),
        ),
      ),
    );
  }
}
