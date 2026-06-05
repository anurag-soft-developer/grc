// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'razorpay_order_model.dart';

class RazorpayOrderModelMapper extends ClassMapperBase<RazorpayOrderModel> {
  RazorpayOrderModelMapper._();

  static RazorpayOrderModelMapper? _instance;
  static RazorpayOrderModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RazorpayOrderModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RazorpayOrderModel';

  static String _$id(RazorpayOrderModel v) => v.id;
  static const Field<RazorpayOrderModel, String> _f$id = Field('id', _$id);
  static String _$entity(RazorpayOrderModel v) => v.entity;
  static const Field<RazorpayOrderModel, String> _f$entity = Field(
    'entity',
    _$entity,
  );
  static int _$amount(RazorpayOrderModel v) => v.amount;
  static const Field<RazorpayOrderModel, int> _f$amount = Field(
    'amount',
    _$amount,
  );
  static int _$amountPaid(RazorpayOrderModel v) => v.amountPaid;
  static const Field<RazorpayOrderModel, int> _f$amountPaid = Field(
    'amountPaid',
    _$amountPaid,
    key: r'amount_paid',
  );
  static int _$amountDue(RazorpayOrderModel v) => v.amountDue;
  static const Field<RazorpayOrderModel, int> _f$amountDue = Field(
    'amountDue',
    _$amountDue,
    key: r'amount_due',
  );
  static String _$currency(RazorpayOrderModel v) => v.currency;
  static const Field<RazorpayOrderModel, String> _f$currency = Field(
    'currency',
    _$currency,
  );
  static String _$receipt(RazorpayOrderModel v) => v.receipt;
  static const Field<RazorpayOrderModel, String> _f$receipt = Field(
    'receipt',
    _$receipt,
  );
  static String _$status(RazorpayOrderModel v) => v.status;
  static const Field<RazorpayOrderModel, String> _f$status = Field(
    'status',
    _$status,
  );
  static int _$attempts(RazorpayOrderModel v) => v.attempts;
  static const Field<RazorpayOrderModel, int> _f$attempts = Field(
    'attempts',
    _$attempts,
  );
  static int _$createdAt(RazorpayOrderModel v) => v.createdAt;
  static const Field<RazorpayOrderModel, int> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );

  @override
  final MappableFields<RazorpayOrderModel> fields = const {
    #id: _f$id,
    #entity: _f$entity,
    #amount: _f$amount,
    #amountPaid: _f$amountPaid,
    #amountDue: _f$amountDue,
    #currency: _f$currency,
    #receipt: _f$receipt,
    #status: _f$status,
    #attempts: _f$attempts,
    #createdAt: _f$createdAt,
  };

  static RazorpayOrderModel _instantiate(DecodingData data) {
    return RazorpayOrderModel(
      id: data.dec(_f$id),
      entity: data.dec(_f$entity),
      amount: data.dec(_f$amount),
      amountPaid: data.dec(_f$amountPaid),
      amountDue: data.dec(_f$amountDue),
      currency: data.dec(_f$currency),
      receipt: data.dec(_f$receipt),
      status: data.dec(_f$status),
      attempts: data.dec(_f$attempts),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RazorpayOrderModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RazorpayOrderModel>(map);
  }

  static RazorpayOrderModel fromJson(String json) {
    return ensureInitialized().decodeJson<RazorpayOrderModel>(json);
  }
}

mixin RazorpayOrderModelMappable {
  String toJson() {
    return RazorpayOrderModelMapper.ensureInitialized()
        .encodeJson<RazorpayOrderModel>(this as RazorpayOrderModel);
  }

  Map<String, dynamic> toMap() {
    return RazorpayOrderModelMapper.ensureInitialized()
        .encodeMap<RazorpayOrderModel>(this as RazorpayOrderModel);
  }

  RazorpayOrderModelCopyWith<
    RazorpayOrderModel,
    RazorpayOrderModel,
    RazorpayOrderModel
  >
  get copyWith =>
      _RazorpayOrderModelCopyWithImpl<RazorpayOrderModel, RazorpayOrderModel>(
        this as RazorpayOrderModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RazorpayOrderModelMapper.ensureInitialized().stringifyValue(
      this as RazorpayOrderModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return RazorpayOrderModelMapper.ensureInitialized().equalsValue(
      this as RazorpayOrderModel,
      other,
    );
  }

  @override
  int get hashCode {
    return RazorpayOrderModelMapper.ensureInitialized().hashValue(
      this as RazorpayOrderModel,
    );
  }
}

extension RazorpayOrderModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RazorpayOrderModel, $Out> {
  RazorpayOrderModelCopyWith<$R, RazorpayOrderModel, $Out>
  get $asRazorpayOrderModel => $base.as(
    (v, t, t2) => _RazorpayOrderModelCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RazorpayOrderModelCopyWith<
  $R,
  $In extends RazorpayOrderModel,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? entity,
    int? amount,
    int? amountPaid,
    int? amountDue,
    String? currency,
    String? receipt,
    String? status,
    int? attempts,
    int? createdAt,
  });
  RazorpayOrderModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RazorpayOrderModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RazorpayOrderModel, $Out>
    implements RazorpayOrderModelCopyWith<$R, RazorpayOrderModel, $Out> {
  _RazorpayOrderModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RazorpayOrderModel> $mapper =
      RazorpayOrderModelMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? entity,
    int? amount,
    int? amountPaid,
    int? amountDue,
    String? currency,
    String? receipt,
    String? status,
    int? attempts,
    int? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (entity != null) #entity: entity,
      if (amount != null) #amount: amount,
      if (amountPaid != null) #amountPaid: amountPaid,
      if (amountDue != null) #amountDue: amountDue,
      if (currency != null) #currency: currency,
      if (receipt != null) #receipt: receipt,
      if (status != null) #status: status,
      if (attempts != null) #attempts: attempts,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  RazorpayOrderModel $make(CopyWithData data) => RazorpayOrderModel(
    id: data.get(#id, or: $value.id),
    entity: data.get(#entity, or: $value.entity),
    amount: data.get(#amount, or: $value.amount),
    amountPaid: data.get(#amountPaid, or: $value.amountPaid),
    amountDue: data.get(#amountDue, or: $value.amountDue),
    currency: data.get(#currency, or: $value.currency),
    receipt: data.get(#receipt, or: $value.receipt),
    status: data.get(#status, or: $value.status),
    attempts: data.get(#attempts, or: $value.attempts),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  RazorpayOrderModelCopyWith<$R2, RazorpayOrderModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RazorpayOrderModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

