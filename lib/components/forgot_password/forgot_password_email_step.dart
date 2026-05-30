import 'package:flutter/material.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/components/shared/custom_text_field.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/utils/validators.dart';

class ForgotPasswordEmailStep extends StatefulWidget {
  final List<Object?> mutationKey;
  final void Function(String email) onSubmit;

  const ForgotPasswordEmailStep({
    super.key,
    required this.mutationKey,
    required this.onSubmit,
  });

  @override
  State<ForgotPasswordEmailStep> createState() =>
      _ForgotPasswordEmailStepState();
}

class _ForgotPasswordEmailStepState extends State<ForgotPasswordEmailStep> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
              const Text(
                'Enter your email',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('We will send a reset OTP to your inbox.'),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Send OTP',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(_emailController.text.trim());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
