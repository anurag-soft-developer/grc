import 'package:dart_mappable/dart_mappable.dart';

part 'media_upload_models.mapper.dart';

@MappableEnum()
enum MediaUploadPurpose {
  @MappableValue('avatar')
  avatar,
  @MappableValue('runEventMedia')
  runEventMedia,
}

extension MediaUploadPurposeApi on MediaUploadPurpose {
  String get apiValue => switch (this) {
        MediaUploadPurpose.avatar => 'avatar',
        MediaUploadPurpose.runEventMedia => 'runEventMedia',
      };
}

@MappableClass()
class UploadedMediaRef with UploadedMediaRefMappable {
  @MappableField(key: 'fileUrl')
  final String fileUrl;
  @MappableField(key: 'objectKey')
  final String objectKey;

  const UploadedMediaRef({
    required this.fileUrl,
    required this.objectKey,
  });

  static final fromMap = UploadedMediaRefMapper.fromMap;
  static final fromJson = UploadedMediaRefMapper.fromJson;
}

@MappableClass()
class DeleteObjectFailure with DeleteObjectFailureMappable {
  @MappableField(key: 'objectKey')
  final String objectKey;
  final String? code;
  final String? message;

  const DeleteObjectFailure({
    required this.objectKey,
    this.code,
    this.message,
  });

  static final fromMap = DeleteObjectFailureMapper.fromMap;
  static final fromJson = DeleteObjectFailureMapper.fromJson;
}

@MappableClass()
class DeleteObjectsResult with DeleteObjectsResultMappable {
  final List<String> deleted;
  final List<DeleteObjectFailure> failed;

  const DeleteObjectsResult({
    required this.deleted,
    required this.failed,
  });

  static final fromMap = DeleteObjectsResultMapper.fromMap;
  static final fromJson = DeleteObjectsResultMapper.fromJson;
}

@MappableClass()
class PresignedUploadInfo with PresignedUploadInfoMappable {
  @MappableField(key: 'uploadUrl')
  final String uploadUrl;
  @MappableField(key: 'fileUrl')
  final String fileUrl;
  @MappableField(key: 'objectKey')
  final String objectKey;
  @MappableField(key: 'expiresAt')
  final String expiresAt;
  final Map<String, String> headers;

  const PresignedUploadInfo({
    required this.uploadUrl,
    required this.fileUrl,
    required this.objectKey,
    required this.expiresAt,
    required this.headers,
  });

  /// Signed PUT headers from API `headers` object.
  Map<String, String> get signedHeaders => headers;

  static final fromMap = PresignedUploadInfoMapper.fromMap;
  static final fromJson = PresignedUploadInfoMapper.fromJson;
}
