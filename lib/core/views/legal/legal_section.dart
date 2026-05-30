import 'package:flutter/material.dart';
import 'package:grc/core/config/constants.dart';

class LegalSection extends StatelessWidget {
  final String title;
  final String body;

  const LegalSection({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.text),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 15,
              height: 1.55,
              color: Color(AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
