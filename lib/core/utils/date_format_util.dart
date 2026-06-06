import 'package:intl/intl.dart';

DateTime? parseApiDate(String? value) {
  if (value == null || value.isEmpty) return null;
  try {
    return DateTime.parse(value).toLocal();
  } catch (_) {
    return null;
  }
}

String _fallbackFromIso(String? iso, String fallback) {
  if (iso == null || iso.isEmpty) return fallback;
  return iso.length >= 10 ? iso.substring(0, 10) : iso;
}

/// e.g. Jan 15, 2026
String formatEventDate(String? iso, {String fallback = 'Date TBA'}) {
  final date = parseApiDate(iso);
  if (date == null) return _fallbackFromIso(iso, fallback);
  return DateFormat('MMM d, yyyy').format(date);
}

/// e.g. 15 Jan 2026
String formatEventDateLong(String? iso, {String fallback = '—'}) {
  final date = parseApiDate(iso);
  if (date == null) {
    if (iso == null || iso.isEmpty) return fallback;
    return iso;
  }
  return DateFormat('d MMM yyyy').format(date);
}

/// e.g. 15 Jan 2026, 3:30 PM
String formatEventDateTime(String? iso, {String fallback = '—'}) {
  final date = parseApiDate(iso);
  if (date == null) {
    if (iso == null || iso.isEmpty) return fallback;
    return iso;
  }
  return DateFormat('d MMM yyyy, h:mm a').format(date);
}

/// e.g. 15/1/2026
String formatEventDateNumeric(String? iso, {String fallback = '—'}) {
  final date = parseApiDate(iso);
  if (date == null) {
    if (iso == null || iso.isEmpty) return fallback;
    return iso;
  }
  return DateFormat('d/M/y').format(date);
}

/// e.g. 2026-01-15
String formatIsoDateOnly(String? iso, {String fallback = '—'}) {
  final date = parseApiDate(iso);
  if (date == null) return _fallbackFromIso(iso, fallback);
  return DateFormat('y-MM-dd').format(date);
}
