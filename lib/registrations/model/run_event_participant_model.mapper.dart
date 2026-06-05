// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'run_event_participant_model.dart';

class RunEventParticipantModelMapper
    extends ClassMapperBase<RunEventParticipantModel> {
  RunEventParticipantModelMapper._();

  static RunEventParticipantModelMapper? _instance;
  static RunEventParticipantModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = RunEventParticipantModelMapper._(),
      );
      RunEventModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RunEventParticipantModel';

  static String? _$id(RunEventParticipantModel v) => v.id;
  static const Field<RunEventParticipantModel, String> _f$id = Field(
    'id',
    _$id,
    key: r'_id',
    opt: true,
  );
  static RunEventModel? _$runEvent(RunEventParticipantModel v) => v.runEvent;
  static const Field<RunEventParticipantModel, RunEventModel> _f$runEvent =
      Field('runEvent', _$runEvent, opt: true);
  static String? _$userId(RunEventParticipantModel v) => v.userId;
  static const Field<RunEventParticipantModel, String> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
  );
  static String? _$fullName(RunEventParticipantModel v) => v.fullName;
  static const Field<RunEventParticipantModel, String> _f$fullName = Field(
    'fullName',
    _$fullName,
    opt: true,
  );
  static String? _$contactNumber(RunEventParticipantModel v) => v.contactNumber;
  static const Field<RunEventParticipantModel, String> _f$contactNumber = Field(
    'contactNumber',
    _$contactNumber,
    opt: true,
  );
  static String? _$gender(RunEventParticipantModel v) => v.gender;
  static const Field<RunEventParticipantModel, String> _f$gender = Field(
    'gender',
    _$gender,
    opt: true,
  );
  static String? _$instagramHandle(RunEventParticipantModel v) =>
      v.instagramHandle;
  static const Field<RunEventParticipantModel, String> _f$instagramHandle =
      Field('instagramHandle', _$instagramHandle, opt: true);
  static String? _$city(RunEventParticipantModel v) => v.city;
  static const Field<RunEventParticipantModel, String> _f$city = Field(
    'city',
    _$city,
    opt: true,
  );
  static List<String> _$howDidYouHearAboutUs(RunEventParticipantModel v) =>
      v.howDidYouHearAboutUs;
  static const Field<RunEventParticipantModel, List<String>>
  _f$howDidYouHearAboutUs = Field(
    'howDidYouHearAboutUs',
    _$howDidYouHearAboutUs,
    opt: true,
    def: const [],
  );
  static bool? _$guidelinesAgreed(RunEventParticipantModel v) =>
      v.guidelinesAgreed;
  static const Field<RunEventParticipantModel, bool> _f$guidelinesAgreed =
      Field('guidelinesAgreed', _$guidelinesAgreed, opt: true);
  static Map<String, dynamic> _$customQuestionResponses(
    RunEventParticipantModel v,
  ) => v.customQuestionResponses;
  static const Field<RunEventParticipantModel, Map<String, dynamic>>
  _f$customQuestionResponses = Field(
    'customQuestionResponses',
    _$customQuestionResponses,
    opt: true,
    def: const {},
  );
  static String? _$status(RunEventParticipantModel v) => v.status;
  static const Field<RunEventParticipantModel, String> _f$status = Field(
    'status',
    _$status,
    opt: true,
  );
  static double? _$totalAmount(RunEventParticipantModel v) => v.totalAmount;
  static const Field<RunEventParticipantModel, double> _f$totalAmount = Field(
    'totalAmount',
    _$totalAmount,
    opt: true,
  );
  static String? _$paymentStatus(RunEventParticipantModel v) => v.paymentStatus;
  static const Field<RunEventParticipantModel, String> _f$paymentStatus = Field(
    'paymentStatus',
    _$paymentStatus,
    opt: true,
  );
  static String? _$paymentId(RunEventParticipantModel v) => v.paymentId;
  static const Field<RunEventParticipantModel, String> _f$paymentId = Field(
    'paymentId',
    _$paymentId,
    opt: true,
  );
  static String? _$razorpayOrderId(RunEventParticipantModel v) =>
      v.razorpayOrderId;
  static const Field<RunEventParticipantModel, String> _f$razorpayOrderId =
      Field('razorpayOrderId', _$razorpayOrderId, opt: true);
  static String? _$invoiceId(RunEventParticipantModel v) => v.invoiceId;
  static const Field<RunEventParticipantModel, String> _f$invoiceId = Field(
    'invoiceId',
    _$invoiceId,
    opt: true,
  );
  static String? _$paidAt(RunEventParticipantModel v) => v.paidAt;
  static const Field<RunEventParticipantModel, String> _f$paidAt = Field(
    'paidAt',
    _$paidAt,
    opt: true,
  );
  static String? _$paymentExpiresAt(RunEventParticipantModel v) =>
      v.paymentExpiresAt;
  static const Field<RunEventParticipantModel, String> _f$paymentExpiresAt =
      Field('paymentExpiresAt', _$paymentExpiresAt, opt: true);
  static String? _$submittedAt(RunEventParticipantModel v) => v.submittedAt;
  static const Field<RunEventParticipantModel, String> _f$submittedAt = Field(
    'submittedAt',
    _$submittedAt,
    opt: true,
  );

  @override
  final MappableFields<RunEventParticipantModel> fields = const {
    #id: _f$id,
    #runEvent: _f$runEvent,
    #userId: _f$userId,
    #fullName: _f$fullName,
    #contactNumber: _f$contactNumber,
    #gender: _f$gender,
    #instagramHandle: _f$instagramHandle,
    #city: _f$city,
    #howDidYouHearAboutUs: _f$howDidYouHearAboutUs,
    #guidelinesAgreed: _f$guidelinesAgreed,
    #customQuestionResponses: _f$customQuestionResponses,
    #status: _f$status,
    #totalAmount: _f$totalAmount,
    #paymentStatus: _f$paymentStatus,
    #paymentId: _f$paymentId,
    #razorpayOrderId: _f$razorpayOrderId,
    #invoiceId: _f$invoiceId,
    #paidAt: _f$paidAt,
    #paymentExpiresAt: _f$paymentExpiresAt,
    #submittedAt: _f$submittedAt,
  };

  static RunEventParticipantModel _instantiate(DecodingData data) {
    return RunEventParticipantModel(
      id: data.dec(_f$id),
      runEvent: data.dec(_f$runEvent),
      userId: data.dec(_f$userId),
      fullName: data.dec(_f$fullName),
      contactNumber: data.dec(_f$contactNumber),
      gender: data.dec(_f$gender),
      instagramHandle: data.dec(_f$instagramHandle),
      city: data.dec(_f$city),
      howDidYouHearAboutUs: data.dec(_f$howDidYouHearAboutUs),
      guidelinesAgreed: data.dec(_f$guidelinesAgreed),
      customQuestionResponses: data.dec(_f$customQuestionResponses),
      status: data.dec(_f$status),
      totalAmount: data.dec(_f$totalAmount),
      paymentStatus: data.dec(_f$paymentStatus),
      paymentId: data.dec(_f$paymentId),
      razorpayOrderId: data.dec(_f$razorpayOrderId),
      invoiceId: data.dec(_f$invoiceId),
      paidAt: data.dec(_f$paidAt),
      paymentExpiresAt: data.dec(_f$paymentExpiresAt),
      submittedAt: data.dec(_f$submittedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RunEventParticipantModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RunEventParticipantModel>(map);
  }

  static RunEventParticipantModel fromJson(String json) {
    return ensureInitialized().decodeJson<RunEventParticipantModel>(json);
  }
}

mixin RunEventParticipantModelMappable {
  String toJson() {
    return RunEventParticipantModelMapper.ensureInitialized()
        .encodeJson<RunEventParticipantModel>(this as RunEventParticipantModel);
  }

  Map<String, dynamic> toMap() {
    return RunEventParticipantModelMapper.ensureInitialized()
        .encodeMap<RunEventParticipantModel>(this as RunEventParticipantModel);
  }

  RunEventParticipantModelCopyWith<
    RunEventParticipantModel,
    RunEventParticipantModel,
    RunEventParticipantModel
  >
  get copyWith =>
      _RunEventParticipantModelCopyWithImpl<
        RunEventParticipantModel,
        RunEventParticipantModel
      >(this as RunEventParticipantModel, $identity, $identity);
  @override
  String toString() {
    return RunEventParticipantModelMapper.ensureInitialized().stringifyValue(
      this as RunEventParticipantModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return RunEventParticipantModelMapper.ensureInitialized().equalsValue(
      this as RunEventParticipantModel,
      other,
    );
  }

  @override
  int get hashCode {
    return RunEventParticipantModelMapper.ensureInitialized().hashValue(
      this as RunEventParticipantModel,
    );
  }
}

extension RunEventParticipantModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RunEventParticipantModel, $Out> {
  RunEventParticipantModelCopyWith<$R, RunEventParticipantModel, $Out>
  get $asRunEventParticipantModel => $base.as(
    (v, t, t2) => _RunEventParticipantModelCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RunEventParticipantModelCopyWith<
  $R,
  $In extends RunEventParticipantModel,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  RunEventModelCopyWith<$R, RunEventModel, RunEventModel>? get runEvent;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get howDidYouHearAboutUs;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>?>
  get customQuestionResponses;
  $R call({
    String? id,
    RunEventModel? runEvent,
    String? userId,
    String? fullName,
    String? contactNumber,
    String? gender,
    String? instagramHandle,
    String? city,
    List<String>? howDidYouHearAboutUs,
    bool? guidelinesAgreed,
    Map<String, dynamic>? customQuestionResponses,
    String? status,
    double? totalAmount,
    String? paymentStatus,
    String? paymentId,
    String? razorpayOrderId,
    String? invoiceId,
    String? paidAt,
    String? paymentExpiresAt,
    String? submittedAt,
  });
  RunEventParticipantModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RunEventParticipantModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RunEventParticipantModel, $Out>
    implements
        RunEventParticipantModelCopyWith<$R, RunEventParticipantModel, $Out> {
  _RunEventParticipantModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RunEventParticipantModel> $mapper =
      RunEventParticipantModelMapper.ensureInitialized();
  @override
  RunEventModelCopyWith<$R, RunEventModel, RunEventModel>? get runEvent =>
      $value.runEvent?.copyWith.$chain((v) => call(runEvent: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get howDidYouHearAboutUs => ListCopyWith(
    $value.howDidYouHearAboutUs,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(howDidYouHearAboutUs: v),
  );
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>?>
  get customQuestionResponses => MapCopyWith(
    $value.customQuestionResponses,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(customQuestionResponses: v),
  );
  @override
  $R call({
    Object? id = $none,
    Object? runEvent = $none,
    Object? userId = $none,
    Object? fullName = $none,
    Object? contactNumber = $none,
    Object? gender = $none,
    Object? instagramHandle = $none,
    Object? city = $none,
    List<String>? howDidYouHearAboutUs,
    Object? guidelinesAgreed = $none,
    Map<String, dynamic>? customQuestionResponses,
    Object? status = $none,
    Object? totalAmount = $none,
    Object? paymentStatus = $none,
    Object? paymentId = $none,
    Object? razorpayOrderId = $none,
    Object? invoiceId = $none,
    Object? paidAt = $none,
    Object? paymentExpiresAt = $none,
    Object? submittedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (runEvent != $none) #runEvent: runEvent,
      if (userId != $none) #userId: userId,
      if (fullName != $none) #fullName: fullName,
      if (contactNumber != $none) #contactNumber: contactNumber,
      if (gender != $none) #gender: gender,
      if (instagramHandle != $none) #instagramHandle: instagramHandle,
      if (city != $none) #city: city,
      if (howDidYouHearAboutUs != null)
        #howDidYouHearAboutUs: howDidYouHearAboutUs,
      if (guidelinesAgreed != $none) #guidelinesAgreed: guidelinesAgreed,
      if (customQuestionResponses != null)
        #customQuestionResponses: customQuestionResponses,
      if (status != $none) #status: status,
      if (totalAmount != $none) #totalAmount: totalAmount,
      if (paymentStatus != $none) #paymentStatus: paymentStatus,
      if (paymentId != $none) #paymentId: paymentId,
      if (razorpayOrderId != $none) #razorpayOrderId: razorpayOrderId,
      if (invoiceId != $none) #invoiceId: invoiceId,
      if (paidAt != $none) #paidAt: paidAt,
      if (paymentExpiresAt != $none) #paymentExpiresAt: paymentExpiresAt,
      if (submittedAt != $none) #submittedAt: submittedAt,
    }),
  );
  @override
  RunEventParticipantModel $make(CopyWithData data) => RunEventParticipantModel(
    id: data.get(#id, or: $value.id),
    runEvent: data.get(#runEvent, or: $value.runEvent),
    userId: data.get(#userId, or: $value.userId),
    fullName: data.get(#fullName, or: $value.fullName),
    contactNumber: data.get(#contactNumber, or: $value.contactNumber),
    gender: data.get(#gender, or: $value.gender),
    instagramHandle: data.get(#instagramHandle, or: $value.instagramHandle),
    city: data.get(#city, or: $value.city),
    howDidYouHearAboutUs: data.get(
      #howDidYouHearAboutUs,
      or: $value.howDidYouHearAboutUs,
    ),
    guidelinesAgreed: data.get(#guidelinesAgreed, or: $value.guidelinesAgreed),
    customQuestionResponses: data.get(
      #customQuestionResponses,
      or: $value.customQuestionResponses,
    ),
    status: data.get(#status, or: $value.status),
    totalAmount: data.get(#totalAmount, or: $value.totalAmount),
    paymentStatus: data.get(#paymentStatus, or: $value.paymentStatus),
    paymentId: data.get(#paymentId, or: $value.paymentId),
    razorpayOrderId: data.get(#razorpayOrderId, or: $value.razorpayOrderId),
    invoiceId: data.get(#invoiceId, or: $value.invoiceId),
    paidAt: data.get(#paidAt, or: $value.paidAt),
    paymentExpiresAt: data.get(#paymentExpiresAt, or: $value.paymentExpiresAt),
    submittedAt: data.get(#submittedAt, or: $value.submittedAt),
  );

  @override
  RunEventParticipantModelCopyWith<$R2, RunEventParticipantModel, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _RunEventParticipantModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PaginatedRunEventParticipantsMapper
    extends ClassMapperBase<PaginatedRunEventParticipants> {
  PaginatedRunEventParticipantsMapper._();

  static PaginatedRunEventParticipantsMapper? _instance;
  static PaginatedRunEventParticipantsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PaginatedRunEventParticipantsMapper._(),
      );
      RunEventParticipantModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PaginatedRunEventParticipants';

  static List<RunEventParticipantModel> _$data(
    PaginatedRunEventParticipants v,
  ) => v.data;
  static const Field<
    PaginatedRunEventParticipants,
    List<RunEventParticipantModel>
  >
  _f$data = Field('data', _$data);
  static int _$totalDocuments(PaginatedRunEventParticipants v) =>
      v.totalDocuments;
  static const Field<PaginatedRunEventParticipants, int> _f$totalDocuments =
      Field('totalDocuments', _$totalDocuments);
  static int _$page(PaginatedRunEventParticipants v) => v.page;
  static const Field<PaginatedRunEventParticipants, int> _f$page = Field(
    'page',
    _$page,
  );
  static int _$limit(PaginatedRunEventParticipants v) => v.limit;
  static const Field<PaginatedRunEventParticipants, int> _f$limit = Field(
    'limit',
    _$limit,
  );
  static int _$totalPages(PaginatedRunEventParticipants v) => v.totalPages;
  static const Field<PaginatedRunEventParticipants, int> _f$totalPages = Field(
    'totalPages',
    _$totalPages,
  );
  static bool _$hasMore(PaginatedRunEventParticipants v) => v.hasMore;
  static const Field<PaginatedRunEventParticipants, bool> _f$hasMore = Field(
    'hasMore',
    _$hasMore,
  );

  @override
  final MappableFields<PaginatedRunEventParticipants> fields = const {
    #data: _f$data,
    #totalDocuments: _f$totalDocuments,
    #page: _f$page,
    #limit: _f$limit,
    #totalPages: _f$totalPages,
    #hasMore: _f$hasMore,
  };

  static PaginatedRunEventParticipants _instantiate(DecodingData data) {
    return PaginatedRunEventParticipants(
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

  static PaginatedRunEventParticipants fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaginatedRunEventParticipants>(map);
  }

  static PaginatedRunEventParticipants fromJson(String json) {
    return ensureInitialized().decodeJson<PaginatedRunEventParticipants>(json);
  }
}

mixin PaginatedRunEventParticipantsMappable {
  String toJson() {
    return PaginatedRunEventParticipantsMapper.ensureInitialized()
        .encodeJson<PaginatedRunEventParticipants>(
          this as PaginatedRunEventParticipants,
        );
  }

  Map<String, dynamic> toMap() {
    return PaginatedRunEventParticipantsMapper.ensureInitialized()
        .encodeMap<PaginatedRunEventParticipants>(
          this as PaginatedRunEventParticipants,
        );
  }

  PaginatedRunEventParticipantsCopyWith<
    PaginatedRunEventParticipants,
    PaginatedRunEventParticipants,
    PaginatedRunEventParticipants
  >
  get copyWith =>
      _PaginatedRunEventParticipantsCopyWithImpl<
        PaginatedRunEventParticipants,
        PaginatedRunEventParticipants
      >(this as PaginatedRunEventParticipants, $identity, $identity);
  @override
  String toString() {
    return PaginatedRunEventParticipantsMapper.ensureInitialized()
        .stringifyValue(this as PaginatedRunEventParticipants);
  }

  @override
  bool operator ==(Object other) {
    return PaginatedRunEventParticipantsMapper.ensureInitialized().equalsValue(
      this as PaginatedRunEventParticipants,
      other,
    );
  }

  @override
  int get hashCode {
    return PaginatedRunEventParticipantsMapper.ensureInitialized().hashValue(
      this as PaginatedRunEventParticipants,
    );
  }
}

extension PaginatedRunEventParticipantsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PaginatedRunEventParticipants, $Out> {
  PaginatedRunEventParticipantsCopyWith<$R, PaginatedRunEventParticipants, $Out>
  get $asPaginatedRunEventParticipants => $base.as(
    (v, t, t2) =>
        _PaginatedRunEventParticipantsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PaginatedRunEventParticipantsCopyWith<
  $R,
  $In extends PaginatedRunEventParticipants,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    RunEventParticipantModel,
    RunEventParticipantModelCopyWith<
      $R,
      RunEventParticipantModel,
      RunEventParticipantModel
    >
  >
  get data;
  $R call({
    List<RunEventParticipantModel>? data,
    int? totalDocuments,
    int? page,
    int? limit,
    int? totalPages,
    bool? hasMore,
  });
  PaginatedRunEventParticipantsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PaginatedRunEventParticipantsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaginatedRunEventParticipants, $Out>
    implements
        PaginatedRunEventParticipantsCopyWith<
          $R,
          PaginatedRunEventParticipants,
          $Out
        > {
  _PaginatedRunEventParticipantsCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<PaginatedRunEventParticipants> $mapper =
      PaginatedRunEventParticipantsMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    RunEventParticipantModel,
    RunEventParticipantModelCopyWith<
      $R,
      RunEventParticipantModel,
      RunEventParticipantModel
    >
  >
  get data => ListCopyWith(
    $value.data,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(data: v),
  );
  @override
  $R call({
    List<RunEventParticipantModel>? data,
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
  PaginatedRunEventParticipants $make(CopyWithData data) =>
      PaginatedRunEventParticipants(
        data: data.get(#data, or: $value.data),
        totalDocuments: data.get(#totalDocuments, or: $value.totalDocuments),
        page: data.get(#page, or: $value.page),
        limit: data.get(#limit, or: $value.limit),
        totalPages: data.get(#totalPages, or: $value.totalPages),
        hasMore: data.get(#hasMore, or: $value.hasMore),
      );

  @override
  PaginatedRunEventParticipantsCopyWith<
    $R2,
    PaginatedRunEventParticipants,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PaginatedRunEventParticipantsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

