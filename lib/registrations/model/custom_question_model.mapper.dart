// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'custom_question_model.dart';

class CustomQuestionModelMapper extends ClassMapperBase<CustomQuestionModel> {
  CustomQuestionModelMapper._();

  static CustomQuestionModelMapper? _instance;
  static CustomQuestionModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CustomQuestionModelMapper._());
      CustomQuestionTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CustomQuestionModel';

  static String _$key(CustomQuestionModel v) => v.key;
  static const Field<CustomQuestionModel, String> _f$key = Field('key', _$key);
  static String _$label(CustomQuestionModel v) => v.label;
  static const Field<CustomQuestionModel, String> _f$label = Field(
    'label',
    _$label,
  );
  static CustomQuestionType _$type(CustomQuestionModel v) => v.type;
  static const Field<CustomQuestionModel, CustomQuestionType> _f$type = Field(
    'type',
    _$type,
  );
  static List<String> _$options(CustomQuestionModel v) => v.options;
  static const Field<CustomQuestionModel, List<String>> _f$options = Field(
    'options',
    _$options,
    opt: true,
    def: const [],
  );
  static bool _$required(CustomQuestionModel v) => v.required;
  static const Field<CustomQuestionModel, bool> _f$required = Field(
    'required',
    _$required,
    opt: true,
    def: false,
  );
  static int _$order(CustomQuestionModel v) => v.order;
  static const Field<CustomQuestionModel, int> _f$order = Field(
    'order',
    _$order,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<CustomQuestionModel> fields = const {
    #key: _f$key,
    #label: _f$label,
    #type: _f$type,
    #options: _f$options,
    #required: _f$required,
    #order: _f$order,
  };

  static CustomQuestionModel _instantiate(DecodingData data) {
    return CustomQuestionModel(
      key: data.dec(_f$key),
      label: data.dec(_f$label),
      type: data.dec(_f$type),
      options: data.dec(_f$options),
      required: data.dec(_f$required),
      order: data.dec(_f$order),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CustomQuestionModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CustomQuestionModel>(map);
  }

  static CustomQuestionModel fromJson(String json) {
    return ensureInitialized().decodeJson<CustomQuestionModel>(json);
  }
}

mixin CustomQuestionModelMappable {
  String toJson() {
    return CustomQuestionModelMapper.ensureInitialized()
        .encodeJson<CustomQuestionModel>(this as CustomQuestionModel);
  }

  Map<String, dynamic> toMap() {
    return CustomQuestionModelMapper.ensureInitialized()
        .encodeMap<CustomQuestionModel>(this as CustomQuestionModel);
  }

  CustomQuestionModelCopyWith<
    CustomQuestionModel,
    CustomQuestionModel,
    CustomQuestionModel
  >
  get copyWith =>
      _CustomQuestionModelCopyWithImpl<
        CustomQuestionModel,
        CustomQuestionModel
      >(this as CustomQuestionModel, $identity, $identity);
  @override
  String toString() {
    return CustomQuestionModelMapper.ensureInitialized().stringifyValue(
      this as CustomQuestionModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return CustomQuestionModelMapper.ensureInitialized().equalsValue(
      this as CustomQuestionModel,
      other,
    );
  }

  @override
  int get hashCode {
    return CustomQuestionModelMapper.ensureInitialized().hashValue(
      this as CustomQuestionModel,
    );
  }
}

extension CustomQuestionModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CustomQuestionModel, $Out> {
  CustomQuestionModelCopyWith<$R, CustomQuestionModel, $Out>
  get $asCustomQuestionModel => $base.as(
    (v, t, t2) => _CustomQuestionModelCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CustomQuestionModelCopyWith<
  $R,
  $In extends CustomQuestionModel,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get options;
  $R call({
    String? key,
    String? label,
    CustomQuestionType? type,
    List<String>? options,
    bool? required,
    int? order,
  });
  CustomQuestionModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CustomQuestionModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CustomQuestionModel, $Out>
    implements CustomQuestionModelCopyWith<$R, CustomQuestionModel, $Out> {
  _CustomQuestionModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CustomQuestionModel> $mapper =
      CustomQuestionModelMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get options =>
      ListCopyWith(
        $value.options,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(options: v),
      );
  @override
  $R call({
    String? key,
    String? label,
    CustomQuestionType? type,
    List<String>? options,
    bool? required,
    int? order,
  }) => $apply(
    FieldCopyWithData({
      if (key != null) #key: key,
      if (label != null) #label: label,
      if (type != null) #type: type,
      if (options != null) #options: options,
      if (required != null) #required: required,
      if (order != null) #order: order,
    }),
  );
  @override
  CustomQuestionModel $make(CopyWithData data) => CustomQuestionModel(
    key: data.get(#key, or: $value.key),
    label: data.get(#label, or: $value.label),
    type: data.get(#type, or: $value.type),
    options: data.get(#options, or: $value.options),
    required: data.get(#required, or: $value.required),
    order: data.get(#order, or: $value.order),
  );

  @override
  CustomQuestionModelCopyWith<$R2, CustomQuestionModel, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CustomQuestionModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

