import 'package:flutter/material.dart';
import 'package:grc/core/config/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Widget? icon;
  final double height;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.height = 50,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isOutlined
        ? Colors.transparent
        : const Color(AppColors.primary);
    final fg = isOutlined
        ? const Color(AppColors.primary)
        : Colors.white;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          side: isOutlined
              ? const BorderSide(color: Color(AppColors.primary))
              : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: isLoading
            ? SizedBox(
                height: height * 0.4,
                width: height * 0.4,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[icon!, const SizedBox(width: 4)],
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
