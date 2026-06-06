import 'package:dart_mappable/dart_mappable.dart';

part 'admin_dashboard_analytics_model.mapper.dart';

@MappableClass()
class AdminDashboardAnalyticsRevenue
    with AdminDashboardAnalyticsRevenueMappable {
  final double totalCollected;
  final int paidRegistrations;
  final String currency;

  const AdminDashboardAnalyticsRevenue({
    this.totalCollected = 0,
    this.paidRegistrations = 0,
    this.currency = 'INR',
  });

  static final fromMap = AdminDashboardAnalyticsRevenueMapper.fromMap;
}

@MappableClass()
class AdminDashboardAnalyticsModel with AdminDashboardAnalyticsModelMappable {
  final int totalEvents;
  final int totalRegistrations;
  final AdminDashboardAnalyticsRevenue revenue;
  final String? fromDate;
  final String? toDate;

  const AdminDashboardAnalyticsModel({
    this.totalEvents = 0,
    this.totalRegistrations = 0,
    this.revenue = const AdminDashboardAnalyticsRevenue(),
    this.fromDate,
    this.toDate,
  });

  static final fromMap = AdminDashboardAnalyticsModelMapper.fromMap;

  static AdminDashboardAnalyticsModel fromApiMap(Map<String, dynamic> map) {
    final copy = Map<String, dynamic>.from(map);
    copy['revenue'] ??= <String, dynamic>{};
    return AdminDashboardAnalyticsModelMapper.fromMap(copy);
  }
}
