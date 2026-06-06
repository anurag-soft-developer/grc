import 'package:grc/admin/dashboard/model/admin_dashboard_analytics_model.dart';
import 'package:grc/admin/dashboard/model/dashboard_date_range.dart';
import 'package:grc/core/config/api_constants.dart';
import 'package:grc/core/services/api_service.dart';
import 'package:flutter/material.dart';

class AdminDashboardService {
  static final AdminDashboardService instance = AdminDashboardService._();
  AdminDashboardService._();

  final ApiService _api = ApiService();

  Future<AdminDashboardAnalyticsModel> getAnalytics({
    DateTimeRange? range,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.dashboard.analytics,
      queryParameters: {
        if (range != null) ...{
          'fromDate': formatDashboardApiDate(range.start),
          'toDate': formatDashboardApiDate(range.end),
        },
      },
    );

    if (response == null) {
      throw Exception('Failed to load dashboard analytics');
    }

    return AdminDashboardAnalyticsModel.fromApiMap(response);
  }
}
