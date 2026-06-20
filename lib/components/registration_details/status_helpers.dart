import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/config/app_colors.dart';

class RegistrationStatusTone {
  final String title;
  final IconData icon;
  final Color foreground;
  final Color background;
  final Color border;

  const RegistrationStatusTone({
    required this.title,
    required this.icon,
    required this.foreground,
    required this.background,
    required this.border,
  });
}

RegistrationStatusTone registrationStatusTone(String status, String payment) {
  if (status == 'submitted' && payment == 'paid') {
    return const RegistrationStatusTone(
      title: 'Registration confirmed',
      icon: Icons.verified_rounded,
      foreground: Color(AppColors.success),
      background: Color(0x1A34D399),
      border: Color(0x6634D399),
    );
  }
  if (status == 'pending_payment') {
    return const RegistrationStatusTone(
      title: 'Payment pending',
      icon: Icons.hourglass_top_rounded,
      foreground: Color(AppColors.primary),
      background: Color(0x1A60A5FA),
      border: Color(0x6660A5FA),
    );
  }
  if (status == 'cancelled') {
    return const RegistrationStatusTone(
      title: 'Registration cancelled',
      icon: Icons.cancel_outlined,
      foreground: Color(AppColors.error),
      background: Color(0x1AF87171),
      border: Color(0x66F87171),
    );
  }
  if (status == 'draft') {
    return const RegistrationStatusTone(
      title: 'Draft registration',
      icon: Icons.edit_note_rounded,
      foreground: Color(AppColors.textSecondary),
      background: Color(AppColors.surface),
      border: Color(AppColors.divider),
    );
  }
  return RegistrationStatusTone(
    title: registrationLabel(status),
    icon: Icons.info_outline_rounded,
    foreground: const Color(AppColors.info),
    background: const Color(0x1A38BDF8),
    border: const Color(0x6638BDF8),
  );
}

String registrationLabel(String? value) {
  if (value == null || value.isEmpty) return '—';
  return value.replaceAll('_', ' ').capitalizeFirst ?? '';
}

Color paymentChipColor(String? paymentStatus) {
  switch (paymentStatus) {
    case 'paid':
      return const Color(AppColors.success);
    case 'pending':
      return const Color(AppColors.primary);
    case 'failed':
      return const Color(AppColors.error);
    case 'refunded':
      return const Color(AppColors.textSecondary);
    default:
      return const Color(AppColors.textSecondary);
  }
}

String formatRegistrationAnswer(dynamic raw) {
  if (raw == null) return '—';
  if (raw is List) return raw.join(', ');
  if (raw is bool) return raw ? 'Yes' : 'No';
  return raw.toString();
}
