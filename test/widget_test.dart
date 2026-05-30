import 'package:flutter_test/flutter_test.dart';
import 'package:grc/core/config/app_colors.dart';

void main() {
  test('GRC brand colors are defined', () {
    expect(AppColors.primary, 0xFF4F46E5);
    expect(AppColors.secondary, 0xFF0D9488);
  });
}
