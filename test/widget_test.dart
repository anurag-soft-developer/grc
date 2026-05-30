import 'package:flutter_test/flutter_test.dart';
import 'package:grc/core/config/app_colors.dart';

void main() {
  test('GRC brand colors are defined', () {
    expect(AppColors.primary, 0xFFE85D4C);
    expect(AppColors.secondary, 0xFF1B6B5A);
  });
}
