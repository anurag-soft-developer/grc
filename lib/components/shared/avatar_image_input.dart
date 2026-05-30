import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/media_upload_models.dart';
import 'package:grc/core/services/media_upload_service.dart';
import 'package:image_picker/image_picker.dart';

class AvatarImageInput extends StatefulWidget {
  final RxList<String> imageUrls;
  final void Function(String url)? onDeferredRemoteRemoval;

  const AvatarImageInput({
    super.key,
    required this.imageUrls,
    this.onDeferredRemoteRemoval,
  });

  @override
  AvatarImageInputState createState() => AvatarImageInputState();
}

class AvatarImageInputState extends State<AvatarImageInput> {
  final _picker = ImagePicker();
  String? _localPath;
  final _uploadProgress = 0.0.obs;

  Future<void> _pick(ImageSource source) async {
    final file = await _picker.pickImage(source: source, maxWidth: 1200);
    if (file == null) return;

    final previousUrl =
        widget.imageUrls.isNotEmpty ? widget.imageUrls.first : null;
    if (previousUrl != null && previousUrl.startsWith('http')) {
      widget.onDeferredRemoteRemoval?.call(previousUrl);
    }

    setState(() {
      _localPath = file.path;
      widget.imageUrls
        ..clear()
        ..add(file.path);
    });
  }

  Future<String?> uploadPendingIfNeeded() async {
    if (_localPath == null) {
      final url = widget.imageUrls.isNotEmpty ? widget.imageUrls.first : null;
      if (url != null && url.startsWith('http')) return url;
      return null;
    }
    final ref = await MediaUploadService.instance.uploadLocalFile(
      file: File(_localPath!),
      purpose: MediaUploadPurpose.avatar,
      onProgress: (p) => _uploadProgress.value = p,
    );
    _uploadProgress.value = 0;
    if (ref == null) return null;
    widget.imageUrls
      ..clear()
      ..add(ref.fileUrl);
    _localPath = null;
    return ref.fileUrl;
  }

  @override
  Widget build(BuildContext context) {
    final displayUrl =
        widget.imageUrls.isNotEmpty ? widget.imageUrls.first : null;
    final isLocal = displayUrl != null &&
        (displayUrl.startsWith('/') || !displayUrl.startsWith('http'));

    Widget avatarChild;
    if (displayUrl == null) {
      avatarChild = const Icon(Icons.person, size: 48, color: Colors.white70);
    } else if (isLocal) {
      avatarChild = ClipOval(
        child: Image.file(
          File(displayUrl),
          width: 96,
          height: 96,
          fit: BoxFit.cover,
        ),
      );
    } else {
      avatarChild = ClipOval(
        child: Image.network(
          displayUrl,
          width: 96,
          height: 96,
          fit: BoxFit.cover,
        ),
      );
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: const Color(AppColors.secondary),
          child: avatarChild,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => _pick(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Gallery'),
            ),
            TextButton.icon(
              onPressed: () => _pick(ImageSource.camera),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Camera'),
            ),
          ],
        ),
        Obx(() {
          if (_uploadProgress.value <= 0 || _uploadProgress.value >= 1) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(value: _uploadProgress.value),
          );
        }),
      ],
    );
  }
}
