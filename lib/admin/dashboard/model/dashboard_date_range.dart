import 'package:flutter/material.dart';

enum DashboardDatePreset {
  thisWeek,
  thisMonth,
  thisYear,
  all,
}

extension DashboardDatePresetX on DashboardDatePreset {
  String get label {
    switch (this) {
      case DashboardDatePreset.thisWeek:
        return 'This week';
      case DashboardDatePreset.thisMonth:
        return 'This month';
      case DashboardDatePreset.thisYear:
        return 'This year';
      case DashboardDatePreset.all:
        return 'All';
    }
  }

  DateTimeRange? resolveRange() {
    if (this == DashboardDatePreset.all) {
      return null;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (this) {
      case DashboardDatePreset.thisWeek:
        final start = today.subtract(Duration(days: today.weekday - 1));
        return DateTimeRange(start: start, end: today);
      case DashboardDatePreset.thisMonth:
        return DateTimeRange(
          start: DateTime(today.year, today.month),
          end: today,
        );
      case DashboardDatePreset.thisYear:
        return DateTimeRange(
          start: DateTime(today.year),
          end: today,
        );
      case DashboardDatePreset.all:
        return null;
    }
  }
}

String formatDashboardApiDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}
