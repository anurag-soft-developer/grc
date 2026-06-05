// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'run_event_analytics_model.dart';

class RunEventAnalyticsByStatusMapper
    extends ClassMapperBase<RunEventAnalyticsByStatus> {
  RunEventAnalyticsByStatusMapper._();

  static RunEventAnalyticsByStatusMapper? _instance;
  static RunEventAnalyticsByStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = RunEventAnalyticsByStatusMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'RunEventAnalyticsByStatus';

  static int _$submitted(RunEventAnalyticsByStatus v) => v.submitted;
  static const Field<RunEventAnalyticsByStatus, int> _f$submitted = Field(
    'submitted',
    _$submitted,
    opt: true,
    def: 0,
  );
  static int _$pendingPayment(RunEventAnalyticsByStatus v) => v.pendingPayment;
  static const Field<RunEventAnalyticsByStatus, int> _f$pendingPayment = Field(
    'pendingPayment',
    _$pendingPayment,
    key: r'pending_payment',
    opt: true,
    def: 0,
  );
  static int _$draft(RunEventAnalyticsByStatus v) => v.draft;
  static const Field<RunEventAnalyticsByStatus, int> _f$draft = Field(
    'draft',
    _$draft,
    opt: true,
    def: 0,
  );
  static int _$cancelled(RunEventAnalyticsByStatus v) => v.cancelled;
  static const Field<RunEventAnalyticsByStatus, int> _f$cancelled = Field(
    'cancelled',
    _$cancelled,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<RunEventAnalyticsByStatus> fields = const {
    #submitted: _f$submitted,
    #pendingPayment: _f$pendingPayment,
    #draft: _f$draft,
    #cancelled: _f$cancelled,
  };

  static RunEventAnalyticsByStatus _instantiate(DecodingData data) {
    return RunEventAnalyticsByStatus(
      submitted: data.dec(_f$submitted),
      pendingPayment: data.dec(_f$pendingPayment),
      draft: data.dec(_f$draft),
      cancelled: data.dec(_f$cancelled),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RunEventAnalyticsByStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RunEventAnalyticsByStatus>(map);
  }

  static RunEventAnalyticsByStatus fromJson(String json) {
    return ensureInitialized().decodeJson<RunEventAnalyticsByStatus>(json);
  }
}

mixin RunEventAnalyticsByStatusMappable {
  String toJson() {
    return RunEventAnalyticsByStatusMapper.ensureInitialized()
        .encodeJson<RunEventAnalyticsByStatus>(
          this as RunEventAnalyticsByStatus,
        );
  }

  Map<String, dynamic> toMap() {
    return RunEventAnalyticsByStatusMapper.ensureInitialized()
        .encodeMap<RunEventAnalyticsByStatus>(
          this as RunEventAnalyticsByStatus,
        );
  }

  RunEventAnalyticsByStatusCopyWith<
    RunEventAnalyticsByStatus,
    RunEventAnalyticsByStatus,
    RunEventAnalyticsByStatus
  >
  get copyWith =>
      _RunEventAnalyticsByStatusCopyWithImpl<
        RunEventAnalyticsByStatus,
        RunEventAnalyticsByStatus
      >(this as RunEventAnalyticsByStatus, $identity, $identity);
  @override
  String toString() {
    return RunEventAnalyticsByStatusMapper.ensureInitialized().stringifyValue(
      this as RunEventAnalyticsByStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    return RunEventAnalyticsByStatusMapper.ensureInitialized().equalsValue(
      this as RunEventAnalyticsByStatus,
      other,
    );
  }

  @override
  int get hashCode {
    return RunEventAnalyticsByStatusMapper.ensureInitialized().hashValue(
      this as RunEventAnalyticsByStatus,
    );
  }
}

extension RunEventAnalyticsByStatusValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RunEventAnalyticsByStatus, $Out> {
  RunEventAnalyticsByStatusCopyWith<$R, RunEventAnalyticsByStatus, $Out>
  get $asRunEventAnalyticsByStatus => $base.as(
    (v, t, t2) => _RunEventAnalyticsByStatusCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RunEventAnalyticsByStatusCopyWith<
  $R,
  $In extends RunEventAnalyticsByStatus,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? submitted, int? pendingPayment, int? draft, int? cancelled});
  RunEventAnalyticsByStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RunEventAnalyticsByStatusCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RunEventAnalyticsByStatus, $Out>
    implements
        RunEventAnalyticsByStatusCopyWith<$R, RunEventAnalyticsByStatus, $Out> {
  _RunEventAnalyticsByStatusCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RunEventAnalyticsByStatus> $mapper =
      RunEventAnalyticsByStatusMapper.ensureInitialized();
  @override
  $R call({int? submitted, int? pendingPayment, int? draft, int? cancelled}) =>
      $apply(
        FieldCopyWithData({
          if (submitted != null) #submitted: submitted,
          if (pendingPayment != null) #pendingPayment: pendingPayment,
          if (draft != null) #draft: draft,
          if (cancelled != null) #cancelled: cancelled,
        }),
      );
  @override
  RunEventAnalyticsByStatus $make(CopyWithData data) =>
      RunEventAnalyticsByStatus(
        submitted: data.get(#submitted, or: $value.submitted),
        pendingPayment: data.get(#pendingPayment, or: $value.pendingPayment),
        draft: data.get(#draft, or: $value.draft),
        cancelled: data.get(#cancelled, or: $value.cancelled),
      );

  @override
  RunEventAnalyticsByStatusCopyWith<$R2, RunEventAnalyticsByStatus, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _RunEventAnalyticsByStatusCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RunEventAnalyticsByPaymentStatusMapper
    extends ClassMapperBase<RunEventAnalyticsByPaymentStatus> {
  RunEventAnalyticsByPaymentStatusMapper._();

  static RunEventAnalyticsByPaymentStatusMapper? _instance;
  static RunEventAnalyticsByPaymentStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = RunEventAnalyticsByPaymentStatusMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'RunEventAnalyticsByPaymentStatus';

  static int _$paid(RunEventAnalyticsByPaymentStatus v) => v.paid;
  static const Field<RunEventAnalyticsByPaymentStatus, int> _f$paid = Field(
    'paid',
    _$paid,
    opt: true,
    def: 0,
  );
  static int _$pending(RunEventAnalyticsByPaymentStatus v) => v.pending;
  static const Field<RunEventAnalyticsByPaymentStatus, int> _f$pending = Field(
    'pending',
    _$pending,
    opt: true,
    def: 0,
  );
  static int _$failed(RunEventAnalyticsByPaymentStatus v) => v.failed;
  static const Field<RunEventAnalyticsByPaymentStatus, int> _f$failed = Field(
    'failed',
    _$failed,
    opt: true,
    def: 0,
  );
  static int _$refunded(RunEventAnalyticsByPaymentStatus v) => v.refunded;
  static const Field<RunEventAnalyticsByPaymentStatus, int> _f$refunded = Field(
    'refunded',
    _$refunded,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<RunEventAnalyticsByPaymentStatus> fields = const {
    #paid: _f$paid,
    #pending: _f$pending,
    #failed: _f$failed,
    #refunded: _f$refunded,
  };

  static RunEventAnalyticsByPaymentStatus _instantiate(DecodingData data) {
    return RunEventAnalyticsByPaymentStatus(
      paid: data.dec(_f$paid),
      pending: data.dec(_f$pending),
      failed: data.dec(_f$failed),
      refunded: data.dec(_f$refunded),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RunEventAnalyticsByPaymentStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RunEventAnalyticsByPaymentStatus>(map);
  }

  static RunEventAnalyticsByPaymentStatus fromJson(String json) {
    return ensureInitialized().decodeJson<RunEventAnalyticsByPaymentStatus>(
      json,
    );
  }
}

mixin RunEventAnalyticsByPaymentStatusMappable {
  String toJson() {
    return RunEventAnalyticsByPaymentStatusMapper.ensureInitialized()
        .encodeJson<RunEventAnalyticsByPaymentStatus>(
          this as RunEventAnalyticsByPaymentStatus,
        );
  }

  Map<String, dynamic> toMap() {
    return RunEventAnalyticsByPaymentStatusMapper.ensureInitialized()
        .encodeMap<RunEventAnalyticsByPaymentStatus>(
          this as RunEventAnalyticsByPaymentStatus,
        );
  }

  RunEventAnalyticsByPaymentStatusCopyWith<
    RunEventAnalyticsByPaymentStatus,
    RunEventAnalyticsByPaymentStatus,
    RunEventAnalyticsByPaymentStatus
  >
  get copyWith =>
      _RunEventAnalyticsByPaymentStatusCopyWithImpl<
        RunEventAnalyticsByPaymentStatus,
        RunEventAnalyticsByPaymentStatus
      >(this as RunEventAnalyticsByPaymentStatus, $identity, $identity);
  @override
  String toString() {
    return RunEventAnalyticsByPaymentStatusMapper.ensureInitialized()
        .stringifyValue(this as RunEventAnalyticsByPaymentStatus);
  }

  @override
  bool operator ==(Object other) {
    return RunEventAnalyticsByPaymentStatusMapper.ensureInitialized()
        .equalsValue(this as RunEventAnalyticsByPaymentStatus, other);
  }

  @override
  int get hashCode {
    return RunEventAnalyticsByPaymentStatusMapper.ensureInitialized().hashValue(
      this as RunEventAnalyticsByPaymentStatus,
    );
  }
}

extension RunEventAnalyticsByPaymentStatusValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RunEventAnalyticsByPaymentStatus, $Out> {
  RunEventAnalyticsByPaymentStatusCopyWith<
    $R,
    RunEventAnalyticsByPaymentStatus,
    $Out
  >
  get $asRunEventAnalyticsByPaymentStatus => $base.as(
    (v, t, t2) =>
        _RunEventAnalyticsByPaymentStatusCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RunEventAnalyticsByPaymentStatusCopyWith<
  $R,
  $In extends RunEventAnalyticsByPaymentStatus,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? paid, int? pending, int? failed, int? refunded});
  RunEventAnalyticsByPaymentStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RunEventAnalyticsByPaymentStatusCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RunEventAnalyticsByPaymentStatus, $Out>
    implements
        RunEventAnalyticsByPaymentStatusCopyWith<
          $R,
          RunEventAnalyticsByPaymentStatus,
          $Out
        > {
  _RunEventAnalyticsByPaymentStatusCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<RunEventAnalyticsByPaymentStatus> $mapper =
      RunEventAnalyticsByPaymentStatusMapper.ensureInitialized();
  @override
  $R call({int? paid, int? pending, int? failed, int? refunded}) => $apply(
    FieldCopyWithData({
      if (paid != null) #paid: paid,
      if (pending != null) #pending: pending,
      if (failed != null) #failed: failed,
      if (refunded != null) #refunded: refunded,
    }),
  );
  @override
  RunEventAnalyticsByPaymentStatus $make(CopyWithData data) =>
      RunEventAnalyticsByPaymentStatus(
        paid: data.get(#paid, or: $value.paid),
        pending: data.get(#pending, or: $value.pending),
        failed: data.get(#failed, or: $value.failed),
        refunded: data.get(#refunded, or: $value.refunded),
      );

  @override
  RunEventAnalyticsByPaymentStatusCopyWith<
    $R2,
    RunEventAnalyticsByPaymentStatus,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _RunEventAnalyticsByPaymentStatusCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

class RunEventAnalyticsRevenueMapper
    extends ClassMapperBase<RunEventAnalyticsRevenue> {
  RunEventAnalyticsRevenueMapper._();

  static RunEventAnalyticsRevenueMapper? _instance;
  static RunEventAnalyticsRevenueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = RunEventAnalyticsRevenueMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'RunEventAnalyticsRevenue';

  static double _$totalCollected(RunEventAnalyticsRevenue v) =>
      v.totalCollected;
  static const Field<RunEventAnalyticsRevenue, double> _f$totalCollected =
      Field('totalCollected', _$totalCollected, opt: true, def: 0);
  static int _$paidRegistrations(RunEventAnalyticsRevenue v) =>
      v.paidRegistrations;
  static const Field<RunEventAnalyticsRevenue, int> _f$paidRegistrations =
      Field('paidRegistrations', _$paidRegistrations, opt: true, def: 0);

  @override
  final MappableFields<RunEventAnalyticsRevenue> fields = const {
    #totalCollected: _f$totalCollected,
    #paidRegistrations: _f$paidRegistrations,
  };

  static RunEventAnalyticsRevenue _instantiate(DecodingData data) {
    return RunEventAnalyticsRevenue(
      totalCollected: data.dec(_f$totalCollected),
      paidRegistrations: data.dec(_f$paidRegistrations),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RunEventAnalyticsRevenue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RunEventAnalyticsRevenue>(map);
  }

  static RunEventAnalyticsRevenue fromJson(String json) {
    return ensureInitialized().decodeJson<RunEventAnalyticsRevenue>(json);
  }
}

mixin RunEventAnalyticsRevenueMappable {
  String toJson() {
    return RunEventAnalyticsRevenueMapper.ensureInitialized()
        .encodeJson<RunEventAnalyticsRevenue>(this as RunEventAnalyticsRevenue);
  }

  Map<String, dynamic> toMap() {
    return RunEventAnalyticsRevenueMapper.ensureInitialized()
        .encodeMap<RunEventAnalyticsRevenue>(this as RunEventAnalyticsRevenue);
  }

  RunEventAnalyticsRevenueCopyWith<
    RunEventAnalyticsRevenue,
    RunEventAnalyticsRevenue,
    RunEventAnalyticsRevenue
  >
  get copyWith =>
      _RunEventAnalyticsRevenueCopyWithImpl<
        RunEventAnalyticsRevenue,
        RunEventAnalyticsRevenue
      >(this as RunEventAnalyticsRevenue, $identity, $identity);
  @override
  String toString() {
    return RunEventAnalyticsRevenueMapper.ensureInitialized().stringifyValue(
      this as RunEventAnalyticsRevenue,
    );
  }

  @override
  bool operator ==(Object other) {
    return RunEventAnalyticsRevenueMapper.ensureInitialized().equalsValue(
      this as RunEventAnalyticsRevenue,
      other,
    );
  }

  @override
  int get hashCode {
    return RunEventAnalyticsRevenueMapper.ensureInitialized().hashValue(
      this as RunEventAnalyticsRevenue,
    );
  }
}

extension RunEventAnalyticsRevenueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RunEventAnalyticsRevenue, $Out> {
  RunEventAnalyticsRevenueCopyWith<$R, RunEventAnalyticsRevenue, $Out>
  get $asRunEventAnalyticsRevenue => $base.as(
    (v, t, t2) => _RunEventAnalyticsRevenueCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RunEventAnalyticsRevenueCopyWith<
  $R,
  $In extends RunEventAnalyticsRevenue,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({double? totalCollected, int? paidRegistrations});
  RunEventAnalyticsRevenueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RunEventAnalyticsRevenueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RunEventAnalyticsRevenue, $Out>
    implements
        RunEventAnalyticsRevenueCopyWith<$R, RunEventAnalyticsRevenue, $Out> {
  _RunEventAnalyticsRevenueCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RunEventAnalyticsRevenue> $mapper =
      RunEventAnalyticsRevenueMapper.ensureInitialized();
  @override
  $R call({double? totalCollected, int? paidRegistrations}) => $apply(
    FieldCopyWithData({
      if (totalCollected != null) #totalCollected: totalCollected,
      if (paidRegistrations != null) #paidRegistrations: paidRegistrations,
    }),
  );
  @override
  RunEventAnalyticsRevenue $make(CopyWithData data) => RunEventAnalyticsRevenue(
    totalCollected: data.get(#totalCollected, or: $value.totalCollected),
    paidRegistrations: data.get(
      #paidRegistrations,
      or: $value.paidRegistrations,
    ),
  );

  @override
  RunEventAnalyticsRevenueCopyWith<$R2, RunEventAnalyticsRevenue, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _RunEventAnalyticsRevenueCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RunEventAnalyticsModelMapper
    extends ClassMapperBase<RunEventAnalyticsModel> {
  RunEventAnalyticsModelMapper._();

  static RunEventAnalyticsModelMapper? _instance;
  static RunEventAnalyticsModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RunEventAnalyticsModelMapper._());
      RunEventAnalyticsByStatusMapper.ensureInitialized();
      RunEventAnalyticsByPaymentStatusMapper.ensureInitialized();
      RunEventAnalyticsRevenueMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RunEventAnalyticsModel';

  static String _$eventId(RunEventAnalyticsModel v) => v.eventId;
  static const Field<RunEventAnalyticsModel, String> _f$eventId = Field(
    'eventId',
    _$eventId,
    opt: true,
    def: '',
  );
  static String _$title(RunEventAnalyticsModel v) => v.title;
  static const Field<RunEventAnalyticsModel, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
    def: '',
  );
  static String _$currency(RunEventAnalyticsModel v) => v.currency;
  static const Field<RunEventAnalyticsModel, String> _f$currency = Field(
    'currency',
    _$currency,
    opt: true,
    def: 'INR',
  );
  static double? _$price(RunEventAnalyticsModel v) => v.price;
  static const Field<RunEventAnalyticsModel, double> _f$price = Field(
    'price',
    _$price,
    opt: true,
  );
  static int? _$maxParticipants(RunEventAnalyticsModel v) => v.maxParticipants;
  static const Field<RunEventAnalyticsModel, int> _f$maxParticipants = Field(
    'maxParticipants',
    _$maxParticipants,
    opt: true,
  );
  static int _$registeredCount(RunEventAnalyticsModel v) => v.registeredCount;
  static const Field<RunEventAnalyticsModel, int> _f$registeredCount = Field(
    'registeredCount',
    _$registeredCount,
    opt: true,
    def: 0,
  );
  static RunEventAnalyticsByStatus _$byStatus(RunEventAnalyticsModel v) =>
      v.byStatus;
  static const Field<RunEventAnalyticsModel, RunEventAnalyticsByStatus>
  _f$byStatus = Field(
    'byStatus',
    _$byStatus,
    opt: true,
    def: const RunEventAnalyticsByStatus(),
  );
  static RunEventAnalyticsByPaymentStatus _$byPaymentStatus(
    RunEventAnalyticsModel v,
  ) => v.byPaymentStatus;
  static const Field<RunEventAnalyticsModel, RunEventAnalyticsByPaymentStatus>
  _f$byPaymentStatus = Field(
    'byPaymentStatus',
    _$byPaymentStatus,
    opt: true,
    def: const RunEventAnalyticsByPaymentStatus(),
  );
  static RunEventAnalyticsRevenue _$revenue(RunEventAnalyticsModel v) =>
      v.revenue;
  static const Field<RunEventAnalyticsModel, RunEventAnalyticsRevenue>
  _f$revenue = Field(
    'revenue',
    _$revenue,
    opt: true,
    def: const RunEventAnalyticsRevenue(),
  );
  static int? _$capacityPercent(RunEventAnalyticsModel v) => v.capacityPercent;
  static const Field<RunEventAnalyticsModel, int> _f$capacityPercent = Field(
    'capacityPercent',
    _$capacityPercent,
    opt: true,
  );

  @override
  final MappableFields<RunEventAnalyticsModel> fields = const {
    #eventId: _f$eventId,
    #title: _f$title,
    #currency: _f$currency,
    #price: _f$price,
    #maxParticipants: _f$maxParticipants,
    #registeredCount: _f$registeredCount,
    #byStatus: _f$byStatus,
    #byPaymentStatus: _f$byPaymentStatus,
    #revenue: _f$revenue,
    #capacityPercent: _f$capacityPercent,
  };

  static RunEventAnalyticsModel _instantiate(DecodingData data) {
    return RunEventAnalyticsModel(
      eventId: data.dec(_f$eventId),
      title: data.dec(_f$title),
      currency: data.dec(_f$currency),
      price: data.dec(_f$price),
      maxParticipants: data.dec(_f$maxParticipants),
      registeredCount: data.dec(_f$registeredCount),
      byStatus: data.dec(_f$byStatus),
      byPaymentStatus: data.dec(_f$byPaymentStatus),
      revenue: data.dec(_f$revenue),
      capacityPercent: data.dec(_f$capacityPercent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RunEventAnalyticsModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RunEventAnalyticsModel>(map);
  }

  static RunEventAnalyticsModel fromJson(String json) {
    return ensureInitialized().decodeJson<RunEventAnalyticsModel>(json);
  }
}

mixin RunEventAnalyticsModelMappable {
  String toJson() {
    return RunEventAnalyticsModelMapper.ensureInitialized()
        .encodeJson<RunEventAnalyticsModel>(this as RunEventAnalyticsModel);
  }

  Map<String, dynamic> toMap() {
    return RunEventAnalyticsModelMapper.ensureInitialized()
        .encodeMap<RunEventAnalyticsModel>(this as RunEventAnalyticsModel);
  }

  RunEventAnalyticsModelCopyWith<
    RunEventAnalyticsModel,
    RunEventAnalyticsModel,
    RunEventAnalyticsModel
  >
  get copyWith =>
      _RunEventAnalyticsModelCopyWithImpl<
        RunEventAnalyticsModel,
        RunEventAnalyticsModel
      >(this as RunEventAnalyticsModel, $identity, $identity);
  @override
  String toString() {
    return RunEventAnalyticsModelMapper.ensureInitialized().stringifyValue(
      this as RunEventAnalyticsModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return RunEventAnalyticsModelMapper.ensureInitialized().equalsValue(
      this as RunEventAnalyticsModel,
      other,
    );
  }

  @override
  int get hashCode {
    return RunEventAnalyticsModelMapper.ensureInitialized().hashValue(
      this as RunEventAnalyticsModel,
    );
  }
}

extension RunEventAnalyticsModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RunEventAnalyticsModel, $Out> {
  RunEventAnalyticsModelCopyWith<$R, RunEventAnalyticsModel, $Out>
  get $asRunEventAnalyticsModel => $base.as(
    (v, t, t2) => _RunEventAnalyticsModelCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RunEventAnalyticsModelCopyWith<
  $R,
  $In extends RunEventAnalyticsModel,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  RunEventAnalyticsByStatusCopyWith<
    $R,
    RunEventAnalyticsByStatus,
    RunEventAnalyticsByStatus
  >
  get byStatus;
  RunEventAnalyticsByPaymentStatusCopyWith<
    $R,
    RunEventAnalyticsByPaymentStatus,
    RunEventAnalyticsByPaymentStatus
  >
  get byPaymentStatus;
  RunEventAnalyticsRevenueCopyWith<
    $R,
    RunEventAnalyticsRevenue,
    RunEventAnalyticsRevenue
  >
  get revenue;
  $R call({
    String? eventId,
    String? title,
    String? currency,
    double? price,
    int? maxParticipants,
    int? registeredCount,
    RunEventAnalyticsByStatus? byStatus,
    RunEventAnalyticsByPaymentStatus? byPaymentStatus,
    RunEventAnalyticsRevenue? revenue,
    int? capacityPercent,
  });
  RunEventAnalyticsModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RunEventAnalyticsModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RunEventAnalyticsModel, $Out>
    implements
        RunEventAnalyticsModelCopyWith<$R, RunEventAnalyticsModel, $Out> {
  _RunEventAnalyticsModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RunEventAnalyticsModel> $mapper =
      RunEventAnalyticsModelMapper.ensureInitialized();
  @override
  RunEventAnalyticsByStatusCopyWith<
    $R,
    RunEventAnalyticsByStatus,
    RunEventAnalyticsByStatus
  >
  get byStatus => $value.byStatus.copyWith.$chain((v) => call(byStatus: v));
  @override
  RunEventAnalyticsByPaymentStatusCopyWith<
    $R,
    RunEventAnalyticsByPaymentStatus,
    RunEventAnalyticsByPaymentStatus
  >
  get byPaymentStatus =>
      $value.byPaymentStatus.copyWith.$chain((v) => call(byPaymentStatus: v));
  @override
  RunEventAnalyticsRevenueCopyWith<
    $R,
    RunEventAnalyticsRevenue,
    RunEventAnalyticsRevenue
  >
  get revenue => $value.revenue.copyWith.$chain((v) => call(revenue: v));
  @override
  $R call({
    String? eventId,
    String? title,
    String? currency,
    Object? price = $none,
    Object? maxParticipants = $none,
    int? registeredCount,
    RunEventAnalyticsByStatus? byStatus,
    RunEventAnalyticsByPaymentStatus? byPaymentStatus,
    RunEventAnalyticsRevenue? revenue,
    Object? capacityPercent = $none,
  }) => $apply(
    FieldCopyWithData({
      if (eventId != null) #eventId: eventId,
      if (title != null) #title: title,
      if (currency != null) #currency: currency,
      if (price != $none) #price: price,
      if (maxParticipants != $none) #maxParticipants: maxParticipants,
      if (registeredCount != null) #registeredCount: registeredCount,
      if (byStatus != null) #byStatus: byStatus,
      if (byPaymentStatus != null) #byPaymentStatus: byPaymentStatus,
      if (revenue != null) #revenue: revenue,
      if (capacityPercent != $none) #capacityPercent: capacityPercent,
    }),
  );
  @override
  RunEventAnalyticsModel $make(CopyWithData data) => RunEventAnalyticsModel(
    eventId: data.get(#eventId, or: $value.eventId),
    title: data.get(#title, or: $value.title),
    currency: data.get(#currency, or: $value.currency),
    price: data.get(#price, or: $value.price),
    maxParticipants: data.get(#maxParticipants, or: $value.maxParticipants),
    registeredCount: data.get(#registeredCount, or: $value.registeredCount),
    byStatus: data.get(#byStatus, or: $value.byStatus),
    byPaymentStatus: data.get(#byPaymentStatus, or: $value.byPaymentStatus),
    revenue: data.get(#revenue, or: $value.revenue),
    capacityPercent: data.get(#capacityPercent, or: $value.capacityPercent),
  );

  @override
  RunEventAnalyticsModelCopyWith<$R2, RunEventAnalyticsModel, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _RunEventAnalyticsModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

