import 'package:flutter/material.dart';
import 'package:grc/core/config/app_colors.dart';

class PreviewableAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final bool enablePreview;
  final Widget? customAvatar;

  const PreviewableAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 36,
    this.enablePreview = true,
    this.customAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final avatarWidget = customAvatar ?? _buildDefaultAvatar(hasImage);

    if (!enablePreview || !hasImage) {
      return avatarWidget;
    }

    return InkWell(
      onTap: () => _openAvatarPreview(context, imageUrl!),
      customBorder: const CircleBorder(),
      child: avatarWidget,
    );
  }

  Widget _buildDefaultAvatar(bool hasImage) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            const Color(AppColors.primary).withValues(alpha: 0.7),
            const Color(AppColors.secondary).withValues(alpha: 0.7),
          ],
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: const Color(AppColors.surface),
        backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
        child: hasImage
            ? null
            : Icon(
                Icons.person_rounded,
                size: radius,
                color: const Color(AppColors.primary).withValues(alpha: 0.6),
              ),
      ),
    );
  }

  void _openAvatarPreview(BuildContext context, String avatarUrl) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AvatarPreviewDialog(imageUrl: avatarUrl),
    );
  }
}

class AvatarPreviewDialog extends StatelessWidget {
  final String imageUrl;

  const AvatarPreviewDialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black.withValues(alpha: 0.92),
      child: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Unable to load avatar preview',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Material(
              color: Colors.black.withValues(alpha: 0.45),
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                tooltip: 'Close',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
