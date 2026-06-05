import 'package:dart_mappable/dart_mappable.dart';
import 'package:grc/core/models/user/user_ref_field_instance.dart';
import 'package:grc/core/models/user/user_ref_hook.dart';
import 'package:grc/core/models/user/user_model.dart';

import 'package:grc/registrations/model/custom_question_model.dart';
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
  final bool isClosed;
  final String? closedAt;
  final String? publishedAt;
  final bool archive;
  @MappableField(key: 'registrationsPaused')
  final bool registrationsPaused;
  @MappableField(key: 'registeredCount')
  final int? registeredCount;
  @MappableField(key: 'createdBy', hook: UserRefHook())
  final UserRefFieldInstance? createdBy;
  final List<CustomQuestionModel> customQuestions;
  final List<String> guidelines;

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
    this.isClosed = false,
    this.closedAt,
    this.publishedAt,
    this.archive = false,
    this.registrationsPaused = false,
    this.registeredCount,
    this.createdBy,
    this.customQuestions = const [],
    this.guidelines = const [],
  });

  /// UI label for status chip (closed overrides published).
  String get displayStatusLabel {
    if (archive) return 'archived';
    if (isClosed) return 'closed';
    if (registrationsPaused) return 'paused';
    return status ?? 'draft';
  }

  bool get isOpenForRegistration =>
      status?.toLowerCase() == 'published' &&
      !isClosed &&
      !registrationsPaused &&
      !archive;

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
  final bool hasMore;

  const PaginatedRunEvents({
    required this.data,
    required this.totalDocuments,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasMore,
  });

  static final fromMap = PaginatedRunEventsMapper.fromMap;

  /// Parses API pagination; treats missing fields and empty `data` as success.
  static PaginatedRunEvents fromApiMap(
    Map<String, dynamic> map, {
    int fallbackPage = 1,
    int fallbackLimit = 10,
  }) {
    final rawData = map['data'];
    final items = rawData is List
        ? rawData
              .whereType<Map>()
              .map((e) => RunEventModel.fromMap(Map<String, dynamic>.from(e)))
              .toList()
        : <RunEventModel>[];

    final totalDocuments = _readInt(map['totalDocuments']) ?? items.length;
    final page = _readInt(map['page']) ?? fallbackPage;
    final limit = _readInt(map['limit']) ?? fallbackLimit;
    final totalPages =
        _readInt(map['totalPages']) ??
        (totalDocuments == 0 ? 1 : (totalDocuments / limit).ceil());
    final hasMore = map['hasMore'] is bool
        ? map['hasMore'] as bool
        : page < totalPages;

    return PaginatedRunEvents(
      data: items,
      totalDocuments: totalDocuments,
      page: page,
      limit: limit,
      totalPages: totalPages,
      hasMore: hasMore,
    );
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return null;
  }
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
  final List<String> guidelines;
  final List<CustomQuestionModel> customQuestions;

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
    this.guidelines = const [],
    this.customQuestions = const [],
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
    'guidelines': guidelines,
    'customQuestions':
        customQuestions.map(CreateRunEventInput.customQuestionToJson).toList(),
  };

  static Map<String, dynamic> customQuestionToJson(CustomQuestionModel q) => {
    'key': q.key,
    'label': q.label,
    'type': q.type.name,
    if (q.options.isNotEmpty) 'options': q.options,
    'required': q.required,
    'order': q.order,
  };
}

/// PATCH body for updating only custom registration questions.
class UpdateRunEventCustomQuestionsInput {
  final List<CustomQuestionModel> customQuestions;

  const UpdateRunEventCustomQuestionsInput({
    required this.customQuestions,
  });

  Map<String, dynamic> toJson() => {
    'customQuestions':
        customQuestions.map(CreateRunEventInput.customQuestionToJson).toList(),
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
  final List<String> guidelines;
  final List<CustomQuestionModel> customQuestions;

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
    this.guidelines = const [],
    this.customQuestions = const [],
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
    guidelines: guidelines,
    customQuestions: customQuestions,
  ).toJson();
}
