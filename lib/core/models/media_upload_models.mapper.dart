// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'media_upload_models.dart';

class MediaUploadPurposeMapper extends EnumMapper<MediaUploadPurpose> {
  MediaUploadPurposeMapper._();

  static MediaUploadPurposeMapper? _instance;
  static MediaUploadPurposeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MediaUploadPurposeMapper._());
    }
    return _instance!;
  }

  static MediaUploadPurpose fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  MediaUploadPurpose decode(dynamic value) {
    switch (value) {
      case 'avatar':
        return MediaUploadPurpose.avatar;
      case 'runEventMedia':
        return MediaUploadPurpose.runEventMedia;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(MediaUploadPurpose self) {
    switch (self) {
      case MediaUploadPurpose.avatar:
        return 'avatar';
      case MediaUploadPurpose.runEventMedia:
        return 'runEventMedia';
    }
  }
}

extension MediaUploadPurposeMapperExtension on MediaUploadPurpose {
  dynamic toValue() {
    MediaUploadPurposeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<MediaUploadPurpose>(this);
  }
}

class UploadedMediaRefMapper extends ClassMapperBase<UploadedMediaRef> {
  UploadedMediaRefMapper._();

  static UploadedMediaRefMapper? _instance;
  static UploadedMediaRefMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UploadedMediaRefMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UploadedMediaRef';

  static String _$fileUrl(UploadedMediaRef v) => v.fileUrl;
  static const Field<UploadedMediaRef, String> _f$fileUrl = Field(
    'fileUrl',
    _$fileUrl,
  );
  static String _$objectKey(UploadedMediaRef v) => v.objectKey;
  static const Field<UploadedMediaRef, String> _f$objectKey = Field(
    'objectKey',
    _$objectKey,
  );

  @override
  final MappableFields<UploadedMediaRef> fields = const {
    #fileUrl: _f$fileUrl,
    #objectKey: _f$objectKey,
  };

  static UploadedMediaRef _instantiate(DecodingData data) {
    return UploadedMediaRef(
      fileUrl: data.dec(_f$fileUrl),
      objectKey: data.dec(_f$objectKey),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UploadedMediaRef fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UploadedMediaRef>(map);
  }

  static UploadedMediaRef fromJson(String json) {
    return ensureInitialized().decodeJson<UploadedMediaRef>(json);
  }
}

mixin UploadedMediaRefMappable {
  String toJson() {
    return UploadedMediaRefMapper.ensureInitialized()
        .encodeJson<UploadedMediaRef>(this as UploadedMediaRef);
  }

  Map<String, dynamic> toMap() {
    return UploadedMediaRefMapper.ensureInitialized()
        .encodeMap<UploadedMediaRef>(this as UploadedMediaRef);
  }

  UploadedMediaRefCopyWith<UploadedMediaRef, UploadedMediaRef, UploadedMediaRef>
  get copyWith =>
      _UploadedMediaRefCopyWithImpl<UploadedMediaRef, UploadedMediaRef>(
        this as UploadedMediaRef,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UploadedMediaRefMapper.ensureInitialized().stringifyValue(
      this as UploadedMediaRef,
    );
  }

  @override
  bool operator ==(Object other) {
    return UploadedMediaRefMapper.ensureInitialized().equalsValue(
      this as UploadedMediaRef,
      other,
    );
  }

  @override
  int get hashCode {
    return UploadedMediaRefMapper.ensureInitialized().hashValue(
      this as UploadedMediaRef,
    );
  }
}

extension UploadedMediaRefValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UploadedMediaRef, $Out> {
  UploadedMediaRefCopyWith<$R, UploadedMediaRef, $Out>
  get $asUploadedMediaRef =>
      $base.as((v, t, t2) => _UploadedMediaRefCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UploadedMediaRefCopyWith<$R, $In extends UploadedMediaRef, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? fileUrl, String? objectKey});
  UploadedMediaRefCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UploadedMediaRefCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UploadedMediaRef, $Out>
    implements UploadedMediaRefCopyWith<$R, UploadedMediaRef, $Out> {
  _UploadedMediaRefCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UploadedMediaRef> $mapper =
      UploadedMediaRefMapper.ensureInitialized();
  @override
  $R call({String? fileUrl, String? objectKey}) => $apply(
    FieldCopyWithData({
      if (fileUrl != null) #fileUrl: fileUrl,
      if (objectKey != null) #objectKey: objectKey,
    }),
  );
  @override
  UploadedMediaRef $make(CopyWithData data) => UploadedMediaRef(
    fileUrl: data.get(#fileUrl, or: $value.fileUrl),
    objectKey: data.get(#objectKey, or: $value.objectKey),
  );

  @override
  UploadedMediaRefCopyWith<$R2, UploadedMediaRef, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UploadedMediaRefCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DeleteObjectFailureMapper extends ClassMapperBase<DeleteObjectFailure> {
  DeleteObjectFailureMapper._();

  static DeleteObjectFailureMapper? _instance;
  static DeleteObjectFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeleteObjectFailureMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DeleteObjectFailure';

  static String _$objectKey(DeleteObjectFailure v) => v.objectKey;
  static const Field<DeleteObjectFailure, String> _f$objectKey = Field(
    'objectKey',
    _$objectKey,
  );
  static String? _$code(DeleteObjectFailure v) => v.code;
  static const Field<DeleteObjectFailure, String> _f$code = Field(
    'code',
    _$code,
    opt: true,
  );
  static String? _$message(DeleteObjectFailure v) => v.message;
  static const Field<DeleteObjectFailure, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
  );

  @override
  final MappableFields<DeleteObjectFailure> fields = const {
    #objectKey: _f$objectKey,
    #code: _f$code,
    #message: _f$message,
  };

  static DeleteObjectFailure _instantiate(DecodingData data) {
    return DeleteObjectFailure(
      objectKey: data.dec(_f$objectKey),
      code: data.dec(_f$code),
      message: data.dec(_f$message),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DeleteObjectFailure fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeleteObjectFailure>(map);
  }

  static DeleteObjectFailure fromJson(String json) {
    return ensureInitialized().decodeJson<DeleteObjectFailure>(json);
  }
}

mixin DeleteObjectFailureMappable {
  String toJson() {
    return DeleteObjectFailureMapper.ensureInitialized()
        .encodeJson<DeleteObjectFailure>(this as DeleteObjectFailure);
  }

  Map<String, dynamic> toMap() {
    return DeleteObjectFailureMapper.ensureInitialized()
        .encodeMap<DeleteObjectFailure>(this as DeleteObjectFailure);
  }

  DeleteObjectFailureCopyWith<
    DeleteObjectFailure,
    DeleteObjectFailure,
    DeleteObjectFailure
  >
  get copyWith =>
      _DeleteObjectFailureCopyWithImpl<
        DeleteObjectFailure,
        DeleteObjectFailure
      >(this as DeleteObjectFailure, $identity, $identity);
  @override
  String toString() {
    return DeleteObjectFailureMapper.ensureInitialized().stringifyValue(
      this as DeleteObjectFailure,
    );
  }

  @override
  bool operator ==(Object other) {
    return DeleteObjectFailureMapper.ensureInitialized().equalsValue(
      this as DeleteObjectFailure,
      other,
    );
  }

  @override
  int get hashCode {
    return DeleteObjectFailureMapper.ensureInitialized().hashValue(
      this as DeleteObjectFailure,
    );
  }
}

extension DeleteObjectFailureValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeleteObjectFailure, $Out> {
  DeleteObjectFailureCopyWith<$R, DeleteObjectFailure, $Out>
  get $asDeleteObjectFailure => $base.as(
    (v, t, t2) => _DeleteObjectFailureCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DeleteObjectFailureCopyWith<
  $R,
  $In extends DeleteObjectFailure,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? objectKey, String? code, String? message});
  DeleteObjectFailureCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DeleteObjectFailureCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeleteObjectFailure, $Out>
    implements DeleteObjectFailureCopyWith<$R, DeleteObjectFailure, $Out> {
  _DeleteObjectFailureCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeleteObjectFailure> $mapper =
      DeleteObjectFailureMapper.ensureInitialized();
  @override
  $R call({String? objectKey, Object? code = $none, Object? message = $none}) =>
      $apply(
        FieldCopyWithData({
          if (objectKey != null) #objectKey: objectKey,
          if (code != $none) #code: code,
          if (message != $none) #message: message,
        }),
      );
  @override
  DeleteObjectFailure $make(CopyWithData data) => DeleteObjectFailure(
    objectKey: data.get(#objectKey, or: $value.objectKey),
    code: data.get(#code, or: $value.code),
    message: data.get(#message, or: $value.message),
  );

  @override
  DeleteObjectFailureCopyWith<$R2, DeleteObjectFailure, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DeleteObjectFailureCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DeleteObjectsResultMapper extends ClassMapperBase<DeleteObjectsResult> {
  DeleteObjectsResultMapper._();

  static DeleteObjectsResultMapper? _instance;
  static DeleteObjectsResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeleteObjectsResultMapper._());
      DeleteObjectFailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DeleteObjectsResult';

  static List<String> _$deleted(DeleteObjectsResult v) => v.deleted;
  static const Field<DeleteObjectsResult, List<String>> _f$deleted = Field(
    'deleted',
    _$deleted,
  );
  static List<DeleteObjectFailure> _$failed(DeleteObjectsResult v) => v.failed;
  static const Field<DeleteObjectsResult, List<DeleteObjectFailure>> _f$failed =
      Field('failed', _$failed);

  @override
  final MappableFields<DeleteObjectsResult> fields = const {
    #deleted: _f$deleted,
    #failed: _f$failed,
  };

  static DeleteObjectsResult _instantiate(DecodingData data) {
    return DeleteObjectsResult(
      deleted: data.dec(_f$deleted),
      failed: data.dec(_f$failed),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DeleteObjectsResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeleteObjectsResult>(map);
  }

  static DeleteObjectsResult fromJson(String json) {
    return ensureInitialized().decodeJson<DeleteObjectsResult>(json);
  }
}

mixin DeleteObjectsResultMappable {
  String toJson() {
    return DeleteObjectsResultMapper.ensureInitialized()
        .encodeJson<DeleteObjectsResult>(this as DeleteObjectsResult);
  }

  Map<String, dynamic> toMap() {
    return DeleteObjectsResultMapper.ensureInitialized()
        .encodeMap<DeleteObjectsResult>(this as DeleteObjectsResult);
  }

  DeleteObjectsResultCopyWith<
    DeleteObjectsResult,
    DeleteObjectsResult,
    DeleteObjectsResult
  >
  get copyWith =>
      _DeleteObjectsResultCopyWithImpl<
        DeleteObjectsResult,
        DeleteObjectsResult
      >(this as DeleteObjectsResult, $identity, $identity);
  @override
  String toString() {
    return DeleteObjectsResultMapper.ensureInitialized().stringifyValue(
      this as DeleteObjectsResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return DeleteObjectsResultMapper.ensureInitialized().equalsValue(
      this as DeleteObjectsResult,
      other,
    );
  }

  @override
  int get hashCode {
    return DeleteObjectsResultMapper.ensureInitialized().hashValue(
      this as DeleteObjectsResult,
    );
  }
}

extension DeleteObjectsResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeleteObjectsResult, $Out> {
  DeleteObjectsResultCopyWith<$R, DeleteObjectsResult, $Out>
  get $asDeleteObjectsResult => $base.as(
    (v, t, t2) => _DeleteObjectsResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DeleteObjectsResultCopyWith<
  $R,
  $In extends DeleteObjectsResult,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get deleted;
  ListCopyWith<
    $R,
    DeleteObjectFailure,
    DeleteObjectFailureCopyWith<$R, DeleteObjectFailure, DeleteObjectFailure>
  >
  get failed;
  $R call({List<String>? deleted, List<DeleteObjectFailure>? failed});
  DeleteObjectsResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DeleteObjectsResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeleteObjectsResult, $Out>
    implements DeleteObjectsResultCopyWith<$R, DeleteObjectsResult, $Out> {
  _DeleteObjectsResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeleteObjectsResult> $mapper =
      DeleteObjectsResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get deleted =>
      ListCopyWith(
        $value.deleted,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(deleted: v),
      );
  @override
  ListCopyWith<
    $R,
    DeleteObjectFailure,
    DeleteObjectFailureCopyWith<$R, DeleteObjectFailure, DeleteObjectFailure>
  >
  get failed => ListCopyWith(
    $value.failed,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(failed: v),
  );
  @override
  $R call({List<String>? deleted, List<DeleteObjectFailure>? failed}) => $apply(
    FieldCopyWithData({
      if (deleted != null) #deleted: deleted,
      if (failed != null) #failed: failed,
    }),
  );
  @override
  DeleteObjectsResult $make(CopyWithData data) => DeleteObjectsResult(
    deleted: data.get(#deleted, or: $value.deleted),
    failed: data.get(#failed, or: $value.failed),
  );

  @override
  DeleteObjectsResultCopyWith<$R2, DeleteObjectsResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DeleteObjectsResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PresignedUploadInfoMapper extends ClassMapperBase<PresignedUploadInfo> {
  PresignedUploadInfoMapper._();

  static PresignedUploadInfoMapper? _instance;
  static PresignedUploadInfoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PresignedUploadInfoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PresignedUploadInfo';

  static String _$uploadUrl(PresignedUploadInfo v) => v.uploadUrl;
  static const Field<PresignedUploadInfo, String> _f$uploadUrl = Field(
    'uploadUrl',
    _$uploadUrl,
  );
  static String _$fileUrl(PresignedUploadInfo v) => v.fileUrl;
  static const Field<PresignedUploadInfo, String> _f$fileUrl = Field(
    'fileUrl',
    _$fileUrl,
  );
  static String _$objectKey(PresignedUploadInfo v) => v.objectKey;
  static const Field<PresignedUploadInfo, String> _f$objectKey = Field(
    'objectKey',
    _$objectKey,
  );
  static String _$expiresAt(PresignedUploadInfo v) => v.expiresAt;
  static const Field<PresignedUploadInfo, String> _f$expiresAt = Field(
    'expiresAt',
    _$expiresAt,
  );
  static Map<String, String> _$headers(PresignedUploadInfo v) => v.headers;
  static const Field<PresignedUploadInfo, Map<String, String>> _f$headers =
      Field('headers', _$headers);

  @override
  final MappableFields<PresignedUploadInfo> fields = const {
    #uploadUrl: _f$uploadUrl,
    #fileUrl: _f$fileUrl,
    #objectKey: _f$objectKey,
    #expiresAt: _f$expiresAt,
    #headers: _f$headers,
  };

  static PresignedUploadInfo _instantiate(DecodingData data) {
    return PresignedUploadInfo(
      uploadUrl: data.dec(_f$uploadUrl),
      fileUrl: data.dec(_f$fileUrl),
      objectKey: data.dec(_f$objectKey),
      expiresAt: data.dec(_f$expiresAt),
      headers: data.dec(_f$headers),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PresignedUploadInfo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PresignedUploadInfo>(map);
  }

  static PresignedUploadInfo fromJson(String json) {
    return ensureInitialized().decodeJson<PresignedUploadInfo>(json);
  }
}

mixin PresignedUploadInfoMappable {
  String toJson() {
    return PresignedUploadInfoMapper.ensureInitialized()
        .encodeJson<PresignedUploadInfo>(this as PresignedUploadInfo);
  }

  Map<String, dynamic> toMap() {
    return PresignedUploadInfoMapper.ensureInitialized()
        .encodeMap<PresignedUploadInfo>(this as PresignedUploadInfo);
  }

  PresignedUploadInfoCopyWith<
    PresignedUploadInfo,
    PresignedUploadInfo,
    PresignedUploadInfo
  >
  get copyWith =>
      _PresignedUploadInfoCopyWithImpl<
        PresignedUploadInfo,
        PresignedUploadInfo
      >(this as PresignedUploadInfo, $identity, $identity);
  @override
  String toString() {
    return PresignedUploadInfoMapper.ensureInitialized().stringifyValue(
      this as PresignedUploadInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    return PresignedUploadInfoMapper.ensureInitialized().equalsValue(
      this as PresignedUploadInfo,
      other,
    );
  }

  @override
  int get hashCode {
    return PresignedUploadInfoMapper.ensureInitialized().hashValue(
      this as PresignedUploadInfo,
    );
  }
}

extension PresignedUploadInfoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PresignedUploadInfo, $Out> {
  PresignedUploadInfoCopyWith<$R, PresignedUploadInfo, $Out>
  get $asPresignedUploadInfo => $base.as(
    (v, t, t2) => _PresignedUploadInfoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PresignedUploadInfoCopyWith<
  $R,
  $In extends PresignedUploadInfo,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get headers;
  $R call({
    String? uploadUrl,
    String? fileUrl,
    String? objectKey,
    String? expiresAt,
    Map<String, String>? headers,
  });
  PresignedUploadInfoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PresignedUploadInfoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PresignedUploadInfo, $Out>
    implements PresignedUploadInfoCopyWith<$R, PresignedUploadInfo, $Out> {
  _PresignedUploadInfoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PresignedUploadInfo> $mapper =
      PresignedUploadInfoMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get headers => MapCopyWith(
    $value.headers,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(headers: v),
  );
  @override
  $R call({
    String? uploadUrl,
    String? fileUrl,
    String? objectKey,
    String? expiresAt,
    Map<String, String>? headers,
  }) => $apply(
    FieldCopyWithData({
      if (uploadUrl != null) #uploadUrl: uploadUrl,
      if (fileUrl != null) #fileUrl: fileUrl,
      if (objectKey != null) #objectKey: objectKey,
      if (expiresAt != null) #expiresAt: expiresAt,
      if (headers != null) #headers: headers,
    }),
  );
  @override
  PresignedUploadInfo $make(CopyWithData data) => PresignedUploadInfo(
    uploadUrl: data.get(#uploadUrl, or: $value.uploadUrl),
    fileUrl: data.get(#fileUrl, or: $value.fileUrl),
    objectKey: data.get(#objectKey, or: $value.objectKey),
    expiresAt: data.get(#expiresAt, or: $value.expiresAt),
    headers: data.get(#headers, or: $value.headers),
  );

  @override
  PresignedUploadInfoCopyWith<$R2, PresignedUploadInfo, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PresignedUploadInfoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

