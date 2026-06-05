import 'package:dart_mappable/dart_mappable.dart';

part 'run_event_analytics_model.mapper.dart';

@MappableClass()
class RunEventAnalyticsByStatus with RunEventAnalyticsByStatusMappable {
  final int submitted;
  @MappableField(key: 'pending_payment')
  final int pendingPayment;
  final int draft;
  final int cancelled;

  const RunEventAnalyticsByStatus({
    this.submitted = 0,
    this.pendingPayment = 0,
    this.draft = 0,
    this.cancelled = 0,
  });

  static final fromMap = RunEventAnalyticsByStatusMapper.fromMap;
}

@MappableClass()
class RunEventAnalyticsByPaymentStatus
    with RunEventAnalyticsByPaymentStatusMappable {
  final int paid;
  final int pending;
  final int failed;
  final int refunded;

  const RunEventAnalyticsByPaymentStatus({
    this.paid = 0,
    this.pending = 0,
    this.failed = 0,
    this.refunded = 0,
  });

  static final fromMap = RunEventAnalyticsByPaymentStatusMapper.fromMap;
}

@MappableClass()
class RunEventAnalyticsRevenue with RunEventAnalyticsRevenueMappable {
  final double totalCollected;
  final int paidRegistrations;

  const RunEventAnalyticsRevenue({
    this.totalCollected = 0,
    this.paidRegistrations = 0,
  });

  static final fromMap = RunEventAnalyticsRevenueMapper.fromMap;
}

@MappableClass()
class RunEventAnalyticsModel with RunEventAnalyticsModelMappable {
  final String eventId;
  final String title;
  final String currency;
  final double? price;
  final int? maxParticipants;
  final int registeredCount;
  final RunEventAnalyticsByStatus byStatus;
  final RunEventAnalyticsByPaymentStatus byPaymentStatus;
  final RunEventAnalyticsRevenue revenue;
  final int? capacityPercent;

  const RunEventAnalyticsModel({
    this.eventId = '',
    this.title = '',
    this.currency = 'INR',
    this.price,
    this.maxParticipants,
    this.registeredCount = 0,
    this.byStatus = const RunEventAnalyticsByStatus(),
    this.byPaymentStatus = const RunEventAnalyticsByPaymentStatus(),
    this.revenue = const RunEventAnalyticsRevenue(),
    this.capacityPercent,
  });

  static final fromMap = RunEventAnalyticsModelMapper.fromMap;

  static RunEventAnalyticsModel fromApiMap(Map<String, dynamic> map) {
    final copy = Map<String, dynamic>.from(map);
    copy['byStatus'] ??= <String, dynamic>{};
    copy['byPaymentStatus'] ??= <String, dynamic>{};
    copy['revenue'] ??= <String, dynamic>{};
    copy['currency'] ??= 'INR';
    return RunEventAnalyticsModelMapper.fromMap(copy);
  }
}
