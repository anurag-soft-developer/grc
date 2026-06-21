import 'package:grc/admin/dashboard/model/dashboard_date_range.dart';

enum ParticipantPaymentStatusFilter { all, pending, paid, failed, refunded }

class ParticipantListFilters {
  const ParticipantListFilters({
    this.search,
    this.paymentStatus = ParticipantPaymentStatusFilter.all,
    this.submittedAt,
  });

  static const empty = ParticipantListFilters();

  final String? search;
  final ParticipantPaymentStatusFilter paymentStatus;
  final DateTime? submittedAt;

  bool get hasActiveFilters =>
      (search != null && search!.trim().isNotEmpty) ||
      paymentStatus != ParticipantPaymentStatusFilter.all ||
      submittedAt != null;

  String get paymentStatusLabel => switch (paymentStatus) {
    ParticipantPaymentStatusFilter.all => 'All',
    ParticipantPaymentStatusFilter.pending => 'Pending',
    ParticipantPaymentStatusFilter.paid => 'Paid',
    ParticipantPaymentStatusFilter.failed => 'Failed',
    ParticipantPaymentStatusFilter.refunded => 'Refunded',
  };

  String get submittedAtLabel => submittedAt == null
      ? 'All'
      : formatDashboardApiDate(submittedAt!);

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    final trimmedSearch = search?.trim();
    if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
      params['search'] = trimmedSearch;
    }
    if (paymentStatus != ParticipantPaymentStatusFilter.all) {
      params['paymentStatus'] = paymentStatus.name;
    }
    if (submittedAt != null) {
      params['submittedAt'] = formatDashboardApiDate(submittedAt!);
    }
    return params;
  }

  ParticipantListFilters copyWith({
    String? search,
    bool clearSearch = false,
    ParticipantPaymentStatusFilter? paymentStatus,
    DateTime? submittedAt,
    bool clearSubmittedAt = false,
  }) {
    return ParticipantListFilters(
      search: clearSearch ? null : (search ?? this.search),
      paymentStatus: paymentStatus ?? this.paymentStatus,
      submittedAt: clearSubmittedAt ? null : (submittedAt ?? this.submittedAt),
    );
  }

  ParticipantListFilters withSearch(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return copyWith(clearSearch: true);
    }
    return copyWith(search: trimmed);
  }

  ParticipantListFilters withPaymentStatus(
    ParticipantPaymentStatusFilter value,
  ) {
    return copyWith(paymentStatus: value);
  }

  ParticipantListFilters withSubmittedAt(DateTime? date) {
    return copyWith(
      submittedAt: date,
      clearSubmittedAt: date == null,
    );
  }

  List<String> toQueryKeyParts() {
    return [
      search?.trim() ?? '',
      paymentStatus.name,
      if (submittedAt != null) formatDashboardApiDate(submittedAt!),
    ];
  }
}
