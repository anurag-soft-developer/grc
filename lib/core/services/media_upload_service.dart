import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:grc/core/config/api_constants.dart';
import 'package:grc/core/models/media_upload_models.dart';
import 'package:grc/core/services/api_service.dart';

class MediaUploadService {
  MediaUploadService._();
  static final MediaUploadService instance = MediaUploadService._();

  final ApiService _api = ApiService();

  static String fileNameFromPath(String path) {
    final normalized = path.replaceAll(r'\', '/');
    final idx = normalized.lastIndexOf('/');
    return idx >= 0 ? normalized.substring(idx + 1) : normalized;
  }

  static String? inferObjectKeyFromPublicUrl(String publicUrl) {
    try {
      final uri = Uri.parse(publicUrl.trim());
      final path = uri.path.replaceFirst(RegExp(r'^/+'), '');
      if (path.startsWith('users/')) return path;
      return null;
    } catch (_) {
      return null;
    }
  }

  static String mimeTypeForPath(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'application/octet-stream';
  }

  Future<PresignedUploadInfo?> requestUploadUrl({
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    required MediaUploadPurpose purpose,
    String? idempotencyKey,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.storage.uploadUrl,
      data: {
        'fileName': fileName,
        'mimeType': mimeType,
        'sizeBytes': sizeBytes,
        'purpose': purpose.apiValue,
        if (idempotencyKey != null) 'idempotencyKey': idempotencyKey,
      },
    );
    if (response == null) return null;
    return PresignedUploadInfo.fromMap(response);
  }

  Future<DeleteObjectsResult?> deleteObjects(List<String> objectKeys) async {
    final unique = objectKeys
        .toSet()
        .where((k) => k.trim().isNotEmpty)
        .toList();
    if (unique.isEmpty) {
      return DeleteObjectsResult(deleted: [], failed: []);
    }

    final response = await _api.delete<Map<String, dynamic>>(
      ApiConstants.storage.delete,
      data: {'objectKeys': unique},
    );
    if (response == null) return null;
    return DeleteObjectsResult.fromMap(response);
  }

  Future<void> putPresignedBytes({
    required String uploadUrl,
    required List<int> bytes,
    required Map<String, String> headers,
    required void Function(double progress) onProgress,
  }) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
        validateStatus: (status) =>
            status != null && status >= 200 && status < 400,
      ),
    );
    await dio.put<void>(
      uploadUrl,
      data: bytes,
      options: Options(headers: headers),
      onSendProgress: (sent, total) {
        if (total > 0) onProgress(sent / total);
      },
    );
  }

  Future<UploadedMediaRef?> uploadLocalFile({
    required File file,
    required MediaUploadPurpose purpose,
    String? idempotencyKey,
    required void Function(double progress) onProgress,
  }) async {
    final path = file.path;
    final fileName = fileNameFromPath(path);
    final mimeType = mimeTypeForPath(path);
    final bytes = await file.readAsBytes();
    final key = idempotencyKey ?? _randomIdempotencyKey();

    final info = await requestUploadUrl(
      fileName: fileName,
      mimeType: mimeType,
      sizeBytes: bytes.length,
      purpose: purpose,
      idempotencyKey: key,
    );
    if (info == null) return null;

    await putPresignedBytes(
      uploadUrl: info.uploadUrl,
      bytes: bytes,
      headers: info.signedHeaders,
      onProgress: onProgress,
    );

    return UploadedMediaRef(fileUrl: info.fileUrl, objectKey: info.objectKey);
  }

  static String _randomIdempotencyKey() {
    final r = Random();
    return List.generate(16, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  }
}
