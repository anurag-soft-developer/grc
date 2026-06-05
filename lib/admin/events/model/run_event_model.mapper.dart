// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'run_event_model.dart';

class RunEventLocationMapper extends ClassMapperBase<RunEventLocation> {
  RunEventLocationMapper._();

  static RunEventLocationMapper? _instance;
  static RunEventLocationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RunEventLocationMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RunEventLocation';

  static String _$city(RunEventLocation v) => v.city;
  static const Field<RunEventLocation, String> _f$city = Field('city', _$city);
  static String _$state(RunEventLocation v) => v.state;
  static const Field<RunEventLocation, String> _f$state = Field(
    'state',
    _$state,
  );
  static String _$address(RunEventLocation v) => v.address;
  static const Field<RunEventLocation, String> _f$address = Field(
    'address',
    _$address,
  );
  static double? _$lat(RunEventLocation v) => v.lat;
  static const Field<RunEventLocation, double> _f$lat = Field(
    'lat',
    _$lat,
    opt: true,
  );
  static double? _$long(RunEventLocation v) => v.long;
  static const Field<RunEventLocation, double> _f$long = Field(
    'long',
    _$long,
    opt: true,
  );

  @override
  final MappableFields<RunEventLocation> fields = const {
    #city: _f$city,
    #state: _f$state,
    #address: _f$address,
    #lat: _f$lat,
    #long: _f$long,
  };

  static RunEventLocation _instantiate(DecodingData data) {
    return RunEventLocation(
      city: data.dec(_f$city),
      state: data.dec(_f$state),
      address: data.dec(_f$address),
      lat: data.dec(_f$lat),
      long: data.dec(_f$long),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RunEventLocation fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RunEventLocation>(map);
  }

  static RunEventLocation fromJson(String json) {
    return ensureInitialized().decodeJson<RunEventLocation>(json);
  }
}

mixin RunEventLocationMappable {
  String toJson() {
    return RunEventLocationMapper.ensureInitialized()
        .encodeJson<RunEventLocation>(this as RunEventLocation);
  }

  Map<String, dynamic> toMap() {
    return RunEventLocationMapper.ensureInitialized()
        .encodeMap<RunEventLocation>(this as RunEventLocation);
  }

  RunEventLocationCopyWith<RunEventLocation, RunEventLocation, RunEventLocation>
  get copyWith =>
      _RunEventLocationCopyWithImpl<RunEventLocation, RunEventLocation>(
        this as RunEventLocation,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RunEventLocationMapper.ensureInitialized().stringifyValue(
      this as RunEventLocation,
    );
  }

  @override
  bool operator ==(Object other) {
    return RunEventLocationMapper.ensureInitialized().equalsValue(
      this as RunEventLocation,
      other,
    );
  }

  @override
  int get hashCode {
    return RunEventLocationMapper.ensureInitialized().hashValue(
      this as RunEventLocation,
    );
  }
}

extension RunEventLocationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RunEventLocation, $Out> {
  RunEventLocationCopyWith<$R, RunEventLocation, $Out>
  get $asRunEventLocation =>
      $base.as((v, t, t2) => _RunEventLocationCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RunEventLocationCopyWith<$R, $In extends RunEventLocation, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? city,
    String? state,
    String? address,
    double? lat,
    double? long,
  });
  RunEventLocationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RunEventLocationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RunEventLocation, $Out>
    implements RunEventLocationCopyWith<$R, RunEventLocation, $Out> {
  _RunEventLocationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RunEventLocation> $mapper =
      RunEventLocationMapper.ensureInitialized();
  @override
  $R call({
    String? city,
    String? state,
    String? address,
    Object? lat = $none,
    Object? long = $none,
  }) => $apply(
    FieldCopyWithData({
      if (city != null) #city: city,
      if (state != null) #state: state,
      if (address != null) #address: address,
      if (lat != $none) #lat: lat,
      if (long != $none) #long: long,
    }),
  );
  @override
  RunEventLocation $make(CopyWithData data) => RunEventLocation(
    city: data.get(#city, or: $value.city),
    state: data.get(#state, or: $value.state),
    address: data.get(#address, or: $value.address),
    lat: data.get(#lat, or: $value.lat),
    long: data.get(#long, or: $value.long),
  );

  @override
  RunEventLocationCopyWith<$R2, RunEventLocation, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RunEventLocationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RunEventModelMapper extends ClassMapperBase<RunEventModel> {
  RunEventModelMapper._();

  static RunEventModelMapper? _instance;
  static RunEventModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RunEventModelMapper._());
      RunEventLocationMapper.ensureInitialized();
      CustomQuestionModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RunEventModel';

  static String? _$id(RunEventModel v) => v.id;
  static const Field<RunEventModel, String> _f$id = Field(
    'id',
    _$id,
    key: r'_id',
    opt: true,
  );
  static String _$title(RunEventModel v) => v.title;
  static const Field<RunEventModel, String> _f$title = Field('title', _$title);
  static String? _$slug(RunEventModel v) => v.slug;
  static const Field<RunEventModel, String> _f$slug = Field(
    'slug',
    _$slug,
    opt: true,
  );
  static String _$description(RunEventModel v) => v.description;
  static const Field<RunEventModel, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
    def: '',
  );
  static String? _$eventDate(RunEventModel v) => v.eventDate;
  static const Field<RunEventModel, String> _f$eventDate = Field(
    'eventDate',
    _$eventDate,
    opt: true,
  );
  static String? _$reportingTime(RunEventModel v) => v.reportingTime;
  static const Field<RunEventModel, String> _f$reportingTime = Field(
    'reportingTime',
    _$reportingTime,
    opt: true,
  );
  static RunEventLocation? _$location(RunEventModel v) => v.location;
  static const Field<RunEventModel, RunEventLocation> _f$location = Field(
    'location',
    _$location,
    opt: true,
  );
  static double? _$price(RunEventModel v) => v.price;
  static const Field<RunEventModel, double> _f$price = Field(
    'price',
    _$price,
    opt: true,
  );
  static String? _$currency(RunEventModel v) => v.currency;
  static const Field<RunEventModel, String> _f$currency = Field(
    'currency',
    _$currency,
    opt: true,
  );
  static int? _$maxParticipants(RunEventModel v) => v.maxParticipants;
  static const Field<RunEventModel, int> _f$maxParticipants = Field(
    'maxParticipants',
    _$maxParticipants,
    opt: true,
  );
  static List<String> _$coverImages(RunEventModel v) => v.coverImages;
  static const Field<RunEventModel, List<String>> _f$coverImages = Field(
    'coverImages',
    _$coverImages,
    opt: true,
    def: const [],
  );
  static String? _$status(RunEventModel v) => v.status;
  static const Field<RunEventModel, String> _f$status = Field(
    'status',
    _$status,
    opt: true,
  );
  static bool _$isClosed(RunEventModel v) => v.isClosed;
  static const Field<RunEventModel, bool> _f$isClosed = Field(
    'isClosed',
    _$isClosed,
    opt: true,
    def: false,
  );
  static String? _$closedAt(RunEventModel v) => v.closedAt;
  static const Field<RunEventModel, String> _f$closedAt = Field(
    'closedAt',
    _$closedAt,
    opt: true,
  );
  static String? _$publishedAt(RunEventModel v) => v.publishedAt;
  static const Field<RunEventModel, String> _f$publishedAt = Field(
    'publishedAt',
    _$publishedAt,
    opt: true,
  );
  static bool _$archive(RunEventModel v) => v.archive;
  static const Field<RunEventModel, bool> _f$archive = Field(
    'archive',
    _$archive,
    opt: true,
    def: false,
  );
  static bool _$registrationsPaused(RunEventModel v) => v.registrationsPaused;
  static const Field<RunEventModel, bool> _f$registrationsPaused = Field(
    'registrationsPaused',
    _$registrationsPaused,
    opt: true,
    def: false,
  );
  static int? _$registeredCount(RunEventModel v) => v.registeredCount;
  static const Field<RunEventModel, int> _f$registeredCount = Field(
    'registeredCount',
    _$registeredCount,
    opt: true,
  );
  static UserRefFieldInstance? _$createdBy(RunEventModel v) => v.createdBy;
  static const Field<RunEventModel, UserRefFieldInstance> _f$createdBy = Field(
    'createdBy',
    _$createdBy,
    opt: true,
    hook: UserRefHook(),
  );
  static List<CustomQuestionModel> _$customQuestions(RunEventModel v) =>
      v.customQuestions;
  static const Field<RunEventModel, List<CustomQuestionModel>>
  _f$customQuestions = Field(
    'customQuestions',
    _$customQuestions,
    opt: true,
    def: const [],
  );
  static List<String> _$guidelines(RunEventModel v) => v.guidelines;
  static const Field<RunEventModel, List<String>> _f$guidelines = Field(
    'guidelines',
    _$guidelines,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<RunEventModel> fields = const {
    #id: _f$id,
    #title: _f$title,
    #slug: _f$slug,
    #description: _f$description,
    #eventDate: _f$eventDate,
    #reportingTime: _f$reportingTime,
    #location: _f$location,
    #price: _f$price,
    #currency: _f$currency,
    #maxParticipants: _f$maxParticipants,
    #coverImages: _f$coverImages,
    #status: _f$status,
    #isClosed: _f$isClosed,
    #closedAt: _f$closedAt,
    #publishedAt: _f$publishedAt,
    #archive: _f$archive,
    #registrationsPaused: _f$registrationsPaused,
    #registeredCount: _f$registeredCount,
    #createdBy: _f$createdBy,
    #customQuestions: _f$customQuestions,
    #guidelines: _f$guidelines,
  };

  static RunEventModel _instantiate(DecodingData data) {
    return RunEventModel(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      slug: data.dec(_f$slug),
      description: data.dec(_f$description),
      eventDate: data.dec(_f$eventDate),
      reportingTime: data.dec(_f$reportingTime),
      location: data.dec(_f$location),
      price: data.dec(_f$price),
      currency: data.dec(_f$currency),
      maxParticipants: data.dec(_f$maxParticipants),
      coverImages: data.dec(_f$coverImages),
      status: data.dec(_f$status),
      isClosed: data.dec(_f$isClosed),
      closedAt: data.dec(_f$closedAt),
      publishedAt: data.dec(_f$publishedAt),
      archive: data.dec(_f$archive),
      registrationsPaused: data.dec(_f$registrationsPaused),
      registeredCount: data.dec(_f$registeredCount),
      createdBy: data.dec(_f$createdBy),
      customQuestions: data.dec(_f$customQuestions),
      guidelines: data.dec(_f$guidelines),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RunEventModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RunEventModel>(map);
  }

  static RunEventModel fromJson(String json) {
    return ensureInitialized().decodeJson<RunEventModel>(json);
  }
}

mixin RunEventModelMappable {
  String toJson() {
    return RunEventModelMapper.ensureInitialized().encodeJson<RunEventModel>(
      this as RunEventModel,
    );
  }

  Map<String, dynamic> toMap() {
    return RunEventModelMapper.ensureInitialized().encodeMap<RunEventModel>(
      this as RunEventModel,
    );
  }

  RunEventModelCopyWith<RunEventModel, RunEventModel, RunEventModel>
  get copyWith => _RunEventModelCopyWithImpl<RunEventModel, RunEventModel>(
    this as RunEventModel,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return RunEventModelMapper.ensureInitialized().stringifyValue(
      this as RunEventModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return RunEventModelMapper.ensureInitialized().equalsValue(
      this as RunEventModel,
      other,
    );
  }

  @override
  int get hashCode {
    return RunEventModelMapper.ensureInitialized().hashValue(
      this as RunEventModel,
    );
  }
}

extension RunEventModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RunEventModel, $Out> {
  RunEventModelCopyWith<$R, RunEventModel, $Out> get $asRunEventModel =>
      $base.as((v, t, t2) => _RunEventModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RunEventModelCopyWith<$R, $In extends RunEventModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  RunEventLocationCopyWith<$R, RunEventLocation, RunEventLocation>?
  get location;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get coverImages;
  ListCopyWith<
    $R,
    CustomQuestionModel,
    CustomQuestionModelCopyWith<$R, CustomQuestionModel, CustomQuestionModel>
  >
  get customQuestions;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get guidelines;
  $R call({
    String? id,
    String? title,
    String? slug,
    String? description,
    String? eventDate,
    String? reportingTime,
    RunEventLocation? location,
    double? price,
    String? currency,
    int? maxParticipants,
    List<String>? coverImages,
    String? status,
    bool? isClosed,
    String? closedAt,
    String? publishedAt,
    bool? archive,
    bool? registrationsPaused,
    int? registeredCount,
    UserRefFieldInstance? createdBy,
    List<CustomQuestionModel>? customQuestions,
    List<String>? guidelines,
  });
  RunEventModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RunEventModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RunEventModel, $Out>
    implements RunEventModelCopyWith<$R, RunEventModel, $Out> {
  _RunEventModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RunEventModel> $mapper =
      RunEventModelMapper.ensureInitialized();
  @override
  RunEventLocationCopyWith<$R, RunEventLocation, RunEventLocation>?
  get location => $value.location?.copyWith.$chain((v) => call(location: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get coverImages => ListCopyWith(
    $value.coverImages,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(coverImages: v),
  );
  @override
  ListCopyWith<
    $R,
    CustomQuestionModel,
    CustomQuestionModelCopyWith<$R, CustomQuestionModel, CustomQuestionModel>
  >
  get customQuestions => ListCopyWith(
    $value.customQuestions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(customQuestions: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get guidelines =>
      ListCopyWith(
        $value.guidelines,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(guidelines: v),
      );
  @override
  $R call({
    Object? id = $none,
    String? title,
    Object? slug = $none,
    String? description,
    Object? eventDate = $none,
    Object? reportingTime = $none,
    Object? location = $none,
    Object? price = $none,
    Object? currency = $none,
    Object? maxParticipants = $none,
    List<String>? coverImages,
    Object? status = $none,
    bool? isClosed,
    Object? closedAt = $none,
    Object? publishedAt = $none,
    bool? archive,
    bool? registrationsPaused,
    Object? registeredCount = $none,
    Object? createdBy = $none,
    List<CustomQuestionModel>? customQuestions,
    List<String>? guidelines,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (title != null) #title: title,
      if (slug != $none) #slug: slug,
      if (description != null) #description: description,
      if (eventDate != $none) #eventDate: eventDate,
      if (reportingTime != $none) #reportingTime: reportingTime,
      if (location != $none) #location: location,
      if (price != $none) #price: price,
      if (currency != $none) #currency: currency,
      if (maxParticipants != $none) #maxParticipants: maxParticipants,
      if (coverImages != null) #coverImages: coverImages,
      if (status != $none) #status: status,
      if (isClosed != null) #isClosed: isClosed,
      if (closedAt != $none) #closedAt: closedAt,
      if (publishedAt != $none) #publishedAt: publishedAt,
      if (archive != null) #archive: archive,
      if (registrationsPaused != null)
        #registrationsPaused: registrationsPaused,
      if (registeredCount != $none) #registeredCount: registeredCount,
      if (createdBy != $none) #createdBy: createdBy,
      if (customQuestions != null) #customQuestions: customQuestions,
      if (guidelines != null) #guidelines: guidelines,
    }),
  );
  @override
  RunEventModel $make(CopyWithData data) => RunEventModel(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    slug: data.get(#slug, or: $value.slug),
    description: data.get(#description, or: $value.description),
    eventDate: data.get(#eventDate, or: $value.eventDate),
    reportingTime: data.get(#reportingTime, or: $value.reportingTime),
    location: data.get(#location, or: $value.location),
    price: data.get(#price, or: $value.price),
    currency: data.get(#currency, or: $value.currency),
    maxParticipants: data.get(#maxParticipants, or: $value.maxParticipants),
    coverImages: data.get(#coverImages, or: $value.coverImages),
    status: data.get(#status, or: $value.status),
    isClosed: data.get(#isClosed, or: $value.isClosed),
    closedAt: data.get(#closedAt, or: $value.closedAt),
    publishedAt: data.get(#publishedAt, or: $value.publishedAt),
    archive: data.get(#archive, or: $value.archive),
    registrationsPaused: data.get(
      #registrationsPaused,
      or: $value.registrationsPaused,
    ),
    registeredCount: data.get(#registeredCount, or: $value.registeredCount),
    createdBy: data.get(#createdBy, or: $value.createdBy),
    customQuestions: data.get(#customQuestions, or: $value.customQuestions),
    guidelines: data.get(#guidelines, or: $value.guidelines),
  );

  @override
  RunEventModelCopyWith<$R2, RunEventModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RunEventModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PaginatedRunEventsMapper extends ClassMapperBase<PaginatedRunEvents> {
  PaginatedRunEventsMapper._();

  static PaginatedRunEventsMapper? _instance;
  static PaginatedRunEventsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PaginatedRunEventsMapper._());
      RunEventModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PaginatedRunEvents';

  static List<RunEventModel> _$data(PaginatedRunEvents v) => v.data;
  static const Field<PaginatedRunEvents, List<RunEventModel>> _f$data = Field(
    'data',
    _$data,
  );
  static int _$totalDocuments(PaginatedRunEvents v) => v.totalDocuments;
  static const Field<PaginatedRunEvents, int> _f$totalDocuments = Field(
    'totalDocuments',
    _$totalDocuments,
  );
  static int _$page(PaginatedRunEvents v) => v.page;
  static const Field<PaginatedRunEvents, int> _f$page = Field('page', _$page);
  static int _$limit(PaginatedRunEvents v) => v.limit;
  static const Field<PaginatedRunEvents, int> _f$limit = Field(
    'limit',
    _$limit,
  );
  static int _$totalPages(PaginatedRunEvents v) => v.totalPages;
  static const Field<PaginatedRunEvents, int> _f$totalPages = Field(
    'totalPages',
    _$totalPages,
  );
  static bool _$hasMore(PaginatedRunEvents v) => v.hasMore;
  static const Field<PaginatedRunEvents, bool> _f$hasMore = Field(
    'hasMore',
    _$hasMore,
  );

  @override
  final MappableFields<PaginatedRunEvents> fields = const {
    #data: _f$data,
    #totalDocuments: _f$totalDocuments,
    #page: _f$page,
    #limit: _f$limit,
    #totalPages: _f$totalPages,
    #hasMore: _f$hasMore,
  };

  static PaginatedRunEvents _instantiate(DecodingData data) {
    return PaginatedRunEvents(
      data: data.dec(_f$data),
      totalDocuments: data.dec(_f$totalDocuments),
      page: data.dec(_f$page),
      limit: data.dec(_f$limit),
      totalPages: data.dec(_f$totalPages),
      hasMore: data.dec(_f$hasMore),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaginatedRunEvents fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaginatedRunEvents>(map);
  }

  static PaginatedRunEvents fromJson(String json) {
    return ensureInitialized().decodeJson<PaginatedRunEvents>(json);
  }
}

mixin PaginatedRunEventsMappable {
  String toJson() {
    return PaginatedRunEventsMapper.ensureInitialized()
        .encodeJson<PaginatedRunEvents>(this as PaginatedRunEvents);
  }

  Map<String, dynamic> toMap() {
    return PaginatedRunEventsMapper.ensureInitialized()
        .encodeMap<PaginatedRunEvents>(this as PaginatedRunEvents);
  }

  PaginatedRunEventsCopyWith<
    PaginatedRunEvents,
    PaginatedRunEvents,
    PaginatedRunEvents
  >
  get copyWith =>
      _PaginatedRunEventsCopyWithImpl<PaginatedRunEvents, PaginatedRunEvents>(
        this as PaginatedRunEvents,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PaginatedRunEventsMapper.ensureInitialized().stringifyValue(
      this as PaginatedRunEvents,
    );
  }

  @override
  bool operator ==(Object other) {
    return PaginatedRunEventsMapper.ensureInitialized().equalsValue(
      this as PaginatedRunEvents,
      other,
    );
  }

  @override
  int get hashCode {
    return PaginatedRunEventsMapper.ensureInitialized().hashValue(
      this as PaginatedRunEvents,
    );
  }
}

extension PaginatedRunEventsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PaginatedRunEvents, $Out> {
  PaginatedRunEventsCopyWith<$R, PaginatedRunEvents, $Out>
  get $asPaginatedRunEvents => $base.as(
    (v, t, t2) => _PaginatedRunEventsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PaginatedRunEventsCopyWith<
  $R,
  $In extends PaginatedRunEvents,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    RunEventModel,
    RunEventModelCopyWith<$R, RunEventModel, RunEventModel>
  >
  get data;
  $R call({
    List<RunEventModel>? data,
    int? totalDocuments,
    int? page,
    int? limit,
    int? totalPages,
    bool? hasMore,
  });
  PaginatedRunEventsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PaginatedRunEventsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaginatedRunEvents, $Out>
    implements PaginatedRunEventsCopyWith<$R, PaginatedRunEvents, $Out> {
  _PaginatedRunEventsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PaginatedRunEvents> $mapper =
      PaginatedRunEventsMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    RunEventModel,
    RunEventModelCopyWith<$R, RunEventModel, RunEventModel>
  >
  get data => ListCopyWith(
    $value.data,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(data: v),
  );
  @override
  $R call({
    List<RunEventModel>? data,
    int? totalDocuments,
    int? page,
    int? limit,
    int? totalPages,
    bool? hasMore,
  }) => $apply(
    FieldCopyWithData({
      if (data != null) #data: data,
      if (totalDocuments != null) #totalDocuments: totalDocuments,
      if (page != null) #page: page,
      if (limit != null) #limit: limit,
      if (totalPages != null) #totalPages: totalPages,
      if (hasMore != null) #hasMore: hasMore,
    }),
  );
  @override
  PaginatedRunEvents $make(CopyWithData data) => PaginatedRunEvents(
    data: data.get(#data, or: $value.data),
    totalDocuments: data.get(#totalDocuments, or: $value.totalDocuments),
    page: data.get(#page, or: $value.page),
    limit: data.get(#limit, or: $value.limit),
    totalPages: data.get(#totalPages, or: $value.totalPages),
    hasMore: data.get(#hasMore, or: $value.hasMore),
  );

  @override
  PaginatedRunEventsCopyWith<$R2, PaginatedRunEvents, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PaginatedRunEventsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

