import 'package:dart_mappable/dart_mappable.dart';
import 'package:grc/core/models/user/user_ref_field_instance.dart';
import 'package:grc/core/models/user/user_ref_hook.dart';
import 'package:grc/core/models/user/user_model.dart';

part 'run_event_model.mapper.dart';

@MappableClass()
class RunEventLocation with RunEventLocationMappable {
  final String city;
  final String state;
  final String address;
  final double? lat;
  final double? long;

  const RunEventLocation({
    required this.city,
    required this.state,
    required this.address,
    this.lat,
    this.long,
  });

  static final fromMap = RunEventLocationMapper.fromMap;
}

@MappableClass()
class RunEventModel with RunEventModelMappable {
  @MappableField(key: '_id')
  final String? id;
  final String title;
  final String? slug;
  final String description;
  @MappableField(key: 'eventDate')
  final String? eventDate;
  @MappableField(key: 'reportingTime')
  final String? reportingTime;
  final RunEventLocation? location;
  final double? price;
  final String? currency;
  @MappableField(key: 'maxParticipants')
  final int? maxParticipants;
  @MappableField(key: 'coverImages')
  final List<String> coverImages;
  final String? status;
  @MappableField(key: 'createdBy', hook: UserRefHook())
  final UserRefFieldInstance? createdBy;

  const RunEventModel({
    this.id,
    required this.title,
    this.slug,
    this.description = '',
    this.eventDate,
    this.reportingTime,
    this.location,
    this.price,
    this.currency,
    this.maxParticipants,
    this.coverImages = const [],
    this.status,
    this.createdBy,
  });

  String get cityLabel => location?.city ?? '';

  String? get createdById => createdBy?.getId();

  UserModel? get createdByUser => createdBy?.getModel();

  bool get createdByPopulated => createdBy?.isPopulated ?? false;

  bool isOwnedBy(String? userId) =>
      userId != null &&
      userId.isNotEmpty &&
      createdById != null &&
      createdById == userId;

  static final fromMap = RunEventModelMapper.fromMap;
  static final fromJson = RunEventModelMapper.fromJson;
}

@MappableClass()
class PaginatedRunEvents with PaginatedRunEventsMappable {
  final List<RunEventModel> data;
  @MappableField(key: 'totalDocuments')
  final int totalDocuments;
  final int page;
  final int limit;
  @MappableField(key: 'totalPages')
  final int totalPages;

  const PaginatedRunEvents({
    required this.data,
    required this.totalDocuments,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  static final fromMap = PaginatedRunEventsMapper.fromMap;
}

/// Request body for POST /run-events (not deserialized from API).
class CreateRunEventInput {
  final String title;
  final String description;
  final DateTime eventDate;
  final String reportingTime;
  final double lat;
  final double long;
  final String city;
  final String state;
  final String address;
  final double price;
  final int maxParticipants;
  final List<String> coverImages;

  const CreateRunEventInput({
    required this.title,
    required this.description,
    required this.eventDate,
    required this.reportingTime,
    required this.lat,
    required this.long,
    required this.city,
    required this.state,
    required this.address,
    required this.price,
    required this.maxParticipants,
    this.coverImages = const [],
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'eventDate': eventDate.toUtc().toIso8601String(),
    'reportingTime': reportingTime,
    'location': {
      'lat': lat,
      'long': long,
      'city': city,
      'state': state,
      'address': address,
    },
    'price': price,
    'maxParticipants': maxParticipants,
    if (coverImages.isNotEmpty) 'coverImages': coverImages,
  };
}

/// Request body for PATCH /run-events/:id
class UpdateRunEventInput {
  final String title;
  final String description;
  final DateTime eventDate;
  final String reportingTime;
  final double lat;
  final double long;
  final String city;
  final String state;
  final String address;
  final double price;
  final int maxParticipants;
  final List<String> coverImages;

  const UpdateRunEventInput({
    required this.title,
    required this.description,
    required this.eventDate,
    required this.reportingTime,
    required this.lat,
    required this.long,
    required this.city,
    required this.state,
    required this.address,
    required this.price,
    required this.maxParticipants,
    this.coverImages = const [],
  });

  Map<String, dynamic> toJson() => CreateRunEventInput(
    title: title,
    description: description,
    eventDate: eventDate,
    reportingTime: reportingTime,
    lat: lat,
    long: long,
    city: city,
    state: state,
    address: address,
    price: price,
    maxParticipants: maxParticipants,
    coverImages: coverImages,
  ).toJson();
}
