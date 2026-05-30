import 'package:flutter/material.dart';
import 'package:grc/core/config/constants.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    this.icon = Icons.construction_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: const Color(AppColors.secondary)),
            const SizedBox(height: 16),
            Text(
              '$title — coming soon',
              style: const TextStyle(
                fontSize: 18,
                color: Color(AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
