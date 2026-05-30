import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/routes/app_routes.dart';

class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Access denied')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 64),
            const SizedBox(height: 16),
            const Text('You do not have permission to view this page.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(AppRoutes.mainRoute),
              child: const Text('Go home'),
            ),
          ],
        ),
      ),
    );
  }
}
