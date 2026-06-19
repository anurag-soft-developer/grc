import 'package:grc/admin/dashboard/model/dashboard_date_range.dart';
import 'package:grc/core/config/preset_cities.dart';

enum EventLocationFilterMode { all, city, nearMe }

enum EventSegmentFilterMode { all, upcoming, closed }

class EventListFilters {
  const EventListFilters({
    this.eventDate,
    this.city,
    this.lat,
    this.long,
    this.maxDistanceMeters,
    this.locationLabel,
    this.locationMode = EventLocationFilterMode.all,
    this.segmentMode = EventSegmentFilterMode.upcoming,
  });

  static const all = EventListFilters();

  final DateTime? eventDate;
  final String? city;
  final double? lat;
  final double? long;
  final int? maxDistanceMeters;
  final String? locationLabel;
  final EventLocationFilterMode locationMode;
  final EventSegmentFilterMode segmentMode;

  bool get hasActiveFilters =>
      eventDate != null || locationMode != EventLocationFilterMode.all;

  String? get apiSegment => switch (segmentMode) {
    EventSegmentFilterMode.all => null,
    EventSegmentFilterMode.upcoming => 'upcoming',
    EventSegmentFilterMode.closed => 'closed',
  };

  String get segmentDisplayLabel {
    return switch (segmentMode) {
      EventSegmentFilterMode.all => 'All',
      EventSegmentFilterMode.upcoming => 'Upcoming',
      EventSegmentFilterMode.closed => 'Closed',
    };
  }

  String get dateLabel =>
      eventDate == null ? 'All' : formatDashboardApiDate(eventDate!);

  String get locationDisplayLabel {
    if (locationMode == EventLocationFilterMode.all) {
      return 'All';
    }
    return locationLabel ?? city ?? 'All';
  }

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};

    if (eventDate != null) {
      params['eventDate'] = formatDashboardApiDate(eventDate!);
    }

    switch (locationMode) {
      case EventLocationFilterMode.city:
        if (city != null && city!.isNotEmpty) {
          params['city'] = city;
        }
      case EventLocationFilterMode.nearMe:
        if (lat != null && long != null) {
          params['lat'] = lat;
          params['long'] = long;
          if (maxDistanceMeters != null) {
            params['maxDistanceMeters'] = maxDistanceMeters;
          }
        }
      case EventLocationFilterMode.all:
        break;
    }

    return params;
  }

  EventListFilters copyWith({
    DateTime? eventDate,
    bool clearEventDate = false,
    String? city,
    double? lat,
    double? long,
    int? maxDistanceMeters,
    String? locationLabel,
    EventLocationFilterMode? locationMode,
    EventSegmentFilterMode? segmentMode,
    bool clearLocation = false,
    bool clearSegment = false,
  }) {
    if (clearLocation) {
      return EventListFilters(
        eventDate: clearEventDate ? null : (eventDate ?? this.eventDate),
        locationMode: EventLocationFilterMode.all,
        segmentMode: clearSegment
            ? EventSegmentFilterMode.all
            : (segmentMode ?? this.segmentMode),
      );
    }

    return EventListFilters(
      eventDate: clearEventDate ? null : (eventDate ?? this.eventDate),
      city: city ?? this.city,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      maxDistanceMeters: maxDistanceMeters ?? this.maxDistanceMeters,
      locationLabel: locationLabel ?? this.locationLabel,
      locationMode: locationMode ?? this.locationMode,
      segmentMode: clearSegment
          ? EventSegmentFilterMode.all
          : (segmentMode ?? this.segmentMode),
    );
  }

  EventListFilters withDate(DateTime? date) {
    return copyWith(eventDate: date, clearEventDate: date == null);
  }

  EventListFilters withSegment(EventSegmentFilterMode value) {
    return copyWith(segmentMode: value);
  }

  EventListFilters withSegmentAll() {
    return copyWith(clearSegment: true);
  }

  EventListFilters withLocationAll() {
    return copyWith(clearLocation: true);
  }

  EventListFilters withCity({required String city, required String label}) {
    return EventListFilters(
      eventDate: eventDate,
      city: city,
      locationLabel: label,
      locationMode: EventLocationFilterMode.city,
      segmentMode: segmentMode,
    );
  }

  EventListFilters withNearMe({
    required double lat,
    required double long,
    int maxDistanceMeters = nearMeMaxDistanceMeters,
  }) {
    return EventListFilters(
      eventDate: eventDate,
      lat: lat,
      long: long,
      maxDistanceMeters: maxDistanceMeters,
      locationLabel: 'Near me',
      locationMode: EventLocationFilterMode.nearMe,
      segmentMode: segmentMode,
    );
  }

  List<String> toQueryKeyParts() {
    return [
      segmentMode.name,
      if (eventDate != null) formatDashboardApiDate(eventDate!),
      locationMode.name,
      if (locationMode == EventLocationFilterMode.city) city ?? '',
      if (locationMode == EventLocationFilterMode.nearMe) ...[
        lat?.toString() ?? '',
        long?.toString() ?? '',
        maxDistanceMeters?.toString() ?? '',
      ],
    ];
  }
}
