import 'package:dart_mappable/dart_mappable.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/model/run_event_ref_field_instance.dart';
import 'package:grc/admin/events/model/run_event_ref_hook.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/models/user/user_ref_field_instance.dart';
import 'package:grc/core/models/user/user_ref_hook.dart';
import 'package:grc/registrations/model/razorpay_order_model.dart';

part 'run_event_participant_model.mapper.dart';

@MappableClass()
class RunEventParticipantModel with RunEventParticipantModelMappable {
  @MappableField(key: '_id')
  final String? id;
  @MappableField(key: 'runEventId', hook: RunEventRefHook())
  final RunEventRefFieldInstance? runEvent;
  @MappableField(key: 'userId', hook: UserRefHook())
  final UserRefFieldInstance? userId;
  final Map<String, dynamic> customQuestionResponses;
  final String? status;
  final double? totalAmount;
  final String? paymentStatus;
  final String? paymentId;
  final String? razorpayOrderId;
  final String? invoiceId;
  final String? paidAt;
  final String? paymentExpiresAt;
  final String? submittedAt;

  const RunEventParticipantModel({
    this.id,
    this.runEvent,
    this.userId,
    this.customQuestionResponses = const {},
    this.status,
    this.totalAmount,
    this.paymentStatus,
    this.paymentId,
    this.razorpayOrderId,
    this.invoiceId,
    this.paidAt,
    this.paymentExpiresAt,
    this.submittedAt,
  });

  bool get isSubmitted => status == 'submitted';
  bool get isPendingPayment => status == 'pending_payment';
  bool get isPaid => paymentStatus == 'paid';

  String? get runEventId => runEvent?.getId();
  RunEventModel? get runEventModel => runEvent?.getModel();
  bool get runEventPopulated => runEvent?.isPopulated ?? false;

  UserModel? get userModel => userId?.getModel();
  bool get userPopulated => userId?.isPopulated ?? false;

  String get displayFullName => userId?.getDisplayName() ?? 'Participant';

  String get displayContact {
    final user = userId?.getModel();
    return user?.phone?.trim() ?? user?.email?.trim() ?? '';
  }

  String? get displayAvatar {
    final avatar = userModel?.avatar?.trim();
    if (avatar != null && avatar.isNotEmpty) return avatar;
    return null;
  }

  static final fromMap = RunEventParticipantModelMapper.fromMap;

  static RunEventParticipantModel fromApiMap(Map<String, dynamic> map) {
    RunEventParticipantModelMapper.ensureInitialized();
    UserModelMapper.ensureInitialized();
    RunEventModelMapper.ensureInitialized();
    return RunEventParticipantModelMapper.fromMap(map);
  }
}

@MappableClass()
class PaginatedRunEventParticipants
    with PaginatedRunEventParticipantsMappable {
  final List<RunEventParticipantModel> data;
  @MappableField(key: 'totalDocuments')
  final int totalDocuments;
  final int page;
  final int limit;
  @MappableField(key: 'totalPages')
  final int totalPages;
  final bool hasMore;

  const PaginatedRunEventParticipants({
    required this.data,
    required this.totalDocuments,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasMore,
  });

  static PaginatedRunEventParticipants fromApiMap(
    Map<String, dynamic> map, {
    int fallbackPage = 1,
    int fallbackLimit = 10,
  }) {
    final rawData = map['data'];
    final items = rawData is List
        ? rawData
              .whereType<Map>()
              .map(
                (e) => RunEventParticipantModel.fromApiMap(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList()
        : <RunEventParticipantModel>[];

    int? readInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return null;
    }

    final totalDocuments = readInt(map['totalDocuments']) ?? items.length;
    final page = readInt(map['page']) ?? fallbackPage;
    final limit = readInt(map['limit']) ?? fallbackLimit;
    final totalPages =
        readInt(map['totalPages']) ??
        (totalDocuments == 0 ? 1 : (totalDocuments / limit).ceil());
    final hasMore = map['hasMore'] is bool
        ? map['hasMore'] as bool
        : page < totalPages;

    return PaginatedRunEventParticipants(
      data: items,
      totalDocuments: totalDocuments,
      page: page,
      limit: limit,
      totalPages: totalPages,
      hasMore: hasMore,
    );
  }
}

class CreateParticipantOrderResponse {
  final RunEventParticipantModel participant;
  final RazorpayOrderModel order;

  const CreateParticipantOrderResponse({
    required this.participant,
    required this.order,
  });

  static CreateParticipantOrderResponse fromApiMap(Map<String, dynamic> map) {
    return CreateParticipantOrderResponse(
      participant: RunEventParticipantModel.fromApiMap(
        Map<String, dynamic>.from(map['participant'] as Map),
      ),
      order: RazorpayOrderModel.fromMap(
        Map<String, dynamic>.from(map['order'] as Map),
      ),
    );
  }
}
