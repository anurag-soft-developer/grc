// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'admin_dashboard_analytics_model.dart';

class AdminDashboardAnalyticsRevenueMapper
    extends ClassMapperBase<AdminDashboardAnalyticsRevenue> {
  AdminDashboardAnalyticsRevenueMapper._();

  static AdminDashboardAnalyticsRevenueMapper? _instance;
  static AdminDashboardAnalyticsRevenueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = AdminDashboardAnalyticsRevenueMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'AdminDashboardAnalyticsRevenue';

  static double _$totalCollected(AdminDashboardAnalyticsRevenue v) =>
      v.totalCollected;
  static const Field<AdminDashboardAnalyticsRevenue, double> _f$totalCollected =
      Field('totalCollected', _$totalCollected, opt: true, def: 0);
  static int _$paidRegistrations(AdminDashboardAnalyticsRevenue v) =>
      v.paidRegistrations;
  static const Field<AdminDashboardAnalyticsRevenue, int> _f$paidRegistrations =
      Field('paidRegistrations', _$paidRegistrations, opt: true, def: 0);
  static String _$currency(AdminDashboardAnalyticsRevenue v) => v.currency;
  static const Field<AdminDashboardAnalyticsRevenue, String> _f$currency =
      Field('currency', _$currency, opt: true, def: 'INR');

  @override
  final MappableFields<AdminDashboardAnalyticsRevenue> fields = const {
    #totalCollected: _f$totalCollected,
    #paidRegistrations: _f$paidRegistrations,
    #currency: _f$currency,
  };

  static AdminDashboardAnalyticsRevenue _instantiate(DecodingData data) {
    return AdminDashboardAnalyticsRevenue(
      totalCollected: data.dec(_f$totalCollected),
      paidRegistrations: data.dec(_f$paidRegistrations),
      currency: data.dec(_f$currency),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AdminDashboardAnalyticsRevenue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminDashboardAnalyticsRevenue>(map);
  }

  static AdminDashboardAnalyticsRevenue fromJson(String json) {
    return ensureInitialized().decodeJson<AdminDashboardAnalyticsRevenue>(json);
  }
}

mixin AdminDashboardAnalyticsRevenueMappable {
  String toJson() {
    return AdminDashboardAnalyticsRevenueMapper.ensureInitialized()
        .encodeJson<AdminDashboardAnalyticsRevenue>(
          this as AdminDashboardAnalyticsRevenue,
        );
  }

  Map<String, dynamic> toMap() {
    return AdminDashboardAnalyticsRevenueMapper.ensureInitialized()
        .encodeMap<AdminDashboardAnalyticsRevenue>(
          this as AdminDashboardAnalyticsRevenue,
        );
  }

  AdminDashboardAnalyticsRevenueCopyWith<
    AdminDashboardAnalyticsRevenue,
    AdminDashboardAnalyticsRevenue,
    AdminDashboardAnalyticsRevenue
  >
  get copyWith =>
      _AdminDashboardAnalyticsRevenueCopyWithImpl<
        AdminDashboardAnalyticsRevenue,
        AdminDashboardAnalyticsRevenue
      >(this as AdminDashboardAnalyticsRevenue, $identity, $identity);
  @override
  String toString() {
    return AdminDashboardAnalyticsRevenueMapper.ensureInitialized()
        .stringifyValue(this as AdminDashboardAnalyticsRevenue);
  }

  @override
  bool operator ==(Object other) {
    return AdminDashboardAnalyticsRevenueMapper.ensureInitialized().equalsValue(
      this as AdminDashboardAnalyticsRevenue,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminDashboardAnalyticsRevenueMapper.ensureInitialized().hashValue(
      this as AdminDashboardAnalyticsRevenue,
    );
  }
}

extension AdminDashboardAnalyticsRevenueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminDashboardAnalyticsRevenue, $Out> {
  AdminDashboardAnalyticsRevenueCopyWith<
    $R,
    AdminDashboardAnalyticsRevenue,
    $Out
  >
  get $asAdminDashboardAnalyticsRevenue => $base.as(
    (v, t, t2) =>
        _AdminDashboardAnalyticsRevenueCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminDashboardAnalyticsRevenueCopyWith<
  $R,
  $In extends AdminDashboardAnalyticsRevenue,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({double? totalCollected, int? paidRegistrations, String? currency});
  AdminDashboardAnalyticsRevenueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminDashboardAnalyticsRevenueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminDashboardAnalyticsRevenue, $Out>
    implements
        AdminDashboardAnalyticsRevenueCopyWith<
          $R,
          AdminDashboardAnalyticsRevenue,
          $Out
        > {
  _AdminDashboardAnalyticsRevenueCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<AdminDashboardAnalyticsRevenue> $mapper =
      AdminDashboardAnalyticsRevenueMapper.ensureInitialized();
  @override
  $R call({double? totalCollected, int? paidRegistrations, String? currency}) =>
      $apply(
        FieldCopyWithData({
          if (totalCollected != null) #totalCollected: totalCollected,
          if (paidRegistrations != null) #paidRegistrations: paidRegistrations,
          if (currency != null) #currency: currency,
        }),
      );
  @override
  AdminDashboardAnalyticsRevenue $make(CopyWithData data) =>
      AdminDashboardAnalyticsRevenue(
        totalCollected: data.get(#totalCollected, or: $value.totalCollected),
        paidRegistrations: data.get(
          #paidRegistrations,
          or: $value.paidRegistrations,
        ),
        currency: data.get(#currency, or: $value.currency),
      );

  @override
  AdminDashboardAnalyticsRevenueCopyWith<
    $R2,
    AdminDashboardAnalyticsRevenue,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AdminDashboardAnalyticsRevenueCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdminDashboardAnalyticsModelMapper
    extends ClassMapperBase<AdminDashboardAnalyticsModel> {
  AdminDashboardAnalyticsModelMapper._();

  static AdminDashboardAnalyticsModelMapper? _instance;
  static AdminDashboardAnalyticsModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = AdminDashboardAnalyticsModelMapper._(),
      );
      AdminDashboardAnalyticsRevenueMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AdminDashboardAnalyticsModel';

  static int _$totalEvents(AdminDashboardAnalyticsModel v) => v.totalEvents;
  static const Field<AdminDashboardAnalyticsModel, int> _f$totalEvents = Field(
    'totalEvents',
    _$totalEvents,
    opt: true,
    def: 0,
  );
  static int _$totalRegistrations(AdminDashboardAnalyticsModel v) =>
      v.totalRegistrations;
  static const Field<AdminDashboardAnalyticsModel, int> _f$totalRegistrations =
      Field('totalRegistrations', _$totalRegistrations, opt: true, def: 0);
  static AdminDashboardAnalyticsRevenue _$revenue(
    AdminDashboardAnalyticsModel v,
  ) => v.revenue;
  static const Field<
    AdminDashboardAnalyticsModel,
    AdminDashboardAnalyticsRevenue
  >
  _f$revenue = Field(
    'revenue',
    _$revenue,
    opt: true,
    def: const AdminDashboardAnalyticsRevenue(),
  );
  static String? _$fromDate(AdminDashboardAnalyticsModel v) => v.fromDate;
  static const Field<AdminDashboardAnalyticsModel, String> _f$fromDate = Field(
    'fromDate',
    _$fromDate,
    opt: true,
  );
  static String? _$toDate(AdminDashboardAnalyticsModel v) => v.toDate;
  static const Field<AdminDashboardAnalyticsModel, String> _f$toDate = Field(
    'toDate',
    _$toDate,
    opt: true,
  );

  @override
  final MappableFields<AdminDashboardAnalyticsModel> fields = const {
    #totalEvents: _f$totalEvents,
    #totalRegistrations: _f$totalRegistrations,
    #revenue: _f$revenue,
    #fromDate: _f$fromDate,
    #toDate: _f$toDate,
  };

  static AdminDashboardAnalyticsModel _instantiate(DecodingData data) {
    return AdminDashboardAnalyticsModel(
      totalEvents: data.dec(_f$totalEvents),
      totalRegistrations: data.dec(_f$totalRegistrations),
      revenue: data.dec(_f$revenue),
      fromDate: data.dec(_f$fromDate),
      toDate: data.dec(_f$toDate),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AdminDashboardAnalyticsModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminDashboardAnalyticsModel>(map);
  }

  static AdminDashboardAnalyticsModel fromJson(String json) {
    return ensureInitialized().decodeJson<AdminDashboardAnalyticsModel>(json);
  }
}

mixin AdminDashboardAnalyticsModelMappable {
  String toJson() {
    return AdminDashboardAnalyticsModelMapper.ensureInitialized()
        .encodeJson<AdminDashboardAnalyticsModel>(
          this as AdminDashboardAnalyticsModel,
        );
  }

  Map<String, dynamic> toMap() {
    return AdminDashboardAnalyticsModelMapper.ensureInitialized()
        .encodeMap<AdminDashboardAnalyticsModel>(
          this as AdminDashboardAnalyticsModel,
        );
  }

  AdminDashboardAnalyticsModelCopyWith<
    AdminDashboardAnalyticsModel,
    AdminDashboardAnalyticsModel,
    AdminDashboardAnalyticsModel
  >
  get copyWith =>
      _AdminDashboardAnalyticsModelCopyWithImpl<
        AdminDashboardAnalyticsModel,
        AdminDashboardAnalyticsModel
      >(this as AdminDashboardAnalyticsModel, $identity, $identity);
  @override
  String toString() {
    return AdminDashboardAnalyticsModelMapper.ensureInitialized()
        .stringifyValue(this as AdminDashboardAnalyticsModel);
  }

  @override
  bool operator ==(Object other) {
    return AdminDashboardAnalyticsModelMapper.ensureInitialized().equalsValue(
      this as AdminDashboardAnalyticsModel,
      other,
    );
  }

  @override
  int get hashCode {
    return AdminDashboardAnalyticsModelMapper.ensureInitialized().hashValue(
      this as AdminDashboardAnalyticsModel,
    );
  }
}

extension AdminDashboardAnalyticsModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminDashboardAnalyticsModel, $Out> {
  AdminDashboardAnalyticsModelCopyWith<$R, AdminDashboardAnalyticsModel, $Out>
  get $asAdminDashboardAnalyticsModel => $base.as(
    (v, t, t2) => _AdminDashboardAnalyticsModelCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AdminDashboardAnalyticsModelCopyWith<
  $R,
  $In extends AdminDashboardAnalyticsModel,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  AdminDashboardAnalyticsRevenueCopyWith<
    $R,
    AdminDashboardAnalyticsRevenue,
    AdminDashboardAnalyticsRevenue
  >
  get revenue;
  $R call({
    int? totalEvents,
    int? totalRegistrations,
    AdminDashboardAnalyticsRevenue? revenue,
    String? fromDate,
    String? toDate,
  });
  AdminDashboardAnalyticsModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdminDashboardAnalyticsModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminDashboardAnalyticsModel, $Out>
    implements
        AdminDashboardAnalyticsModelCopyWith<
          $R,
          AdminDashboardAnalyticsModel,
          $Out
        > {
  _AdminDashboardAnalyticsModelCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<AdminDashboardAnalyticsModel> $mapper =
      AdminDashboardAnalyticsModelMapper.ensureInitialized();
  @override
  AdminDashboardAnalyticsRevenueCopyWith<
    $R,
    AdminDashboardAnalyticsRevenue,
    AdminDashboardAnalyticsRevenue
  >
  get revenue => $value.revenue.copyWith.$chain((v) => call(revenue: v));
  @override
  $R call({
    int? totalEvents,
    int? totalRegistrations,
    AdminDashboardAnalyticsRevenue? revenue,
    Object? fromDate = $none,
    Object? toDate = $none,
  }) => $apply(
    FieldCopyWithData({
      if (totalEvents != null) #totalEvents: totalEvents,
      if (totalRegistrations != null) #totalRegistrations: totalRegistrations,
      if (revenue != null) #revenue: revenue,
      if (fromDate != $none) #fromDate: fromDate,
      if (toDate != $none) #toDate: toDate,
    }),
  );
  @override
  AdminDashboardAnalyticsModel $make(CopyWithData data) =>
      AdminDashboardAnalyticsModel(
        totalEvents: data.get(#totalEvents, or: $value.totalEvents),
        totalRegistrations: data.get(
          #totalRegistrations,
          or: $value.totalRegistrations,
        ),
        revenue: data.get(#revenue, or: $value.revenue),
        fromDate: data.get(#fromDate, or: $value.fromDate),
        toDate: data.get(#toDate, or: $value.toDate),
      );

  @override
  AdminDashboardAnalyticsModelCopyWith<$R2, AdminDashboardAnalyticsModel, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AdminDashboardAnalyticsModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

