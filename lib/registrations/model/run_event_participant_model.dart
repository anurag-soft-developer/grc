import 'package:dart_mappable/dart_mappable.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/model/run_event_ref_field_instance.dart';
import 'package:grc/admin/events/model/run_event_ref_hook.dart';
import 'package:grc/core/models/user/user_model.dart';
import 'package:grc/core/models/user/user_ref_field_instance.dart';
import 'package:grc/core/models/user/user_ref_hook.dart';
import 'package:grc/registrations/model/razorpay_order_model.dart';
import 'package:grc/registrations/model/razorpay_payment_link_model.dart';

part 'run_event_participant_model.mapper.dart';

@MappableClass()
class RunEventParticipantModel with RunEventParticipantModelMappable {
  @MappableField(key: '_id')
  final String? id;
  @MappableField(key: 'runEventId', hook: RunEventRefHook())
  final RunEventRefFieldInstance? runEvent;
  @MappableField(key: 'userId', hook: UserRefHook())
  final UserRefFieldInstance? userId;
  @MappableField(key: 'fullName')
  final String? fullName;
  final String? email;
  final String? phone;
  final Map<String, dynamic> customQuestionResponses;
  final String? status;
  final double? totalAmount;
  final String? paymentStatus;
  final String? razorpayPaymentId;
  final String? razorpayOrderId;
  final String? razorpayPaymentLinkId;
  final String? razorpayPaymentLinkShortUrl;
  final String? razorpayPaymentLinkCallbackUrl;
  final int? bookingId;
  final String? paidAt;
  final String? paymentExpiresAt;
  final String? submittedAt;

  const RunEventParticipantModel({
    this.id,
    this.runEvent,
    this.userId,
    this.fullName,
    this.email,
    this.phone,
    this.customQuestionResponses = const {},
    this.status,
    this.totalAmount,
    this.paymentStatus,
    this.razorpayPaymentId,
    this.razorpayOrderId,
    this.razorpayPaymentLinkId,
    this.razorpayPaymentLinkShortUrl,
    this.razorpayPaymentLinkCallbackUrl,
    this.bookingId,
    this.paidAt,
    this.paymentExpiresAt,
    this.submittedAt,
  });

  bool get isSubmitted => status == 'submitted';
  bool get isPendingPayment => status == 'pending_payment';
  bool get isPaid => paymentStatus == 'paid';

  bool get needsPaymentSync =>
      isPendingPayment &&
      !isPaid &&
      ((razorpayPaymentLinkId?.trim().isNotEmpty ?? false) ||
          (razorpayOrderId?.trim().isNotEmpty ?? false) ||
          (paymentExpiresAt?.trim().isNotEmpty ?? false));

  bool get isPaymentHoldActive {
    if (!isPendingPayment) return false;
    final expiresAt = paymentExpiresAt?.trim();
    if (expiresAt == null || expiresAt.isEmpty) return true;
    return DateTime.parse(expiresAt).isAfter(DateTime.now());
  }

  RazorpayOrderModel? get reusableCheckoutOrder {
    if (!isPaymentHoldActive) return null;

    final orderId = razorpayOrderId?.trim();
    final amount = totalAmount;
    if (orderId == null || orderId.isEmpty || amount == null || amount <= 0) {
      return null;
    }

    final amountInPaise = (amount * 100).round();
    return RazorpayOrderModel(
      id: orderId,
      entity: 'order',
      amount: amountInPaise,
      amountPaid: 0,
      amountDue: amountInPaise,
      currency: 'INR',
      receipt: '',
      status: 'created',
      attempts: 0,
      createdAt: 0,
    );
  }

  RazorpayPaymentLinkModel? get reusablePaymentLink {
    if (!isPaymentHoldActive) return null;

    final linkId = razorpayPaymentLinkId?.trim();
    final shortUrl = razorpayPaymentLinkShortUrl?.trim();
    final callbackUrl = razorpayPaymentLinkCallbackUrl?.trim();
    if (linkId == null ||
        linkId.isEmpty ||
        shortUrl == null ||
        shortUrl.isEmpty) {
      return null;
    }

    return RazorpayPaymentLinkModel(
      id: linkId,
      shortUrl: shortUrl,
      callbackUrl: callbackUrl ?? '',
    );
  }

  bool get hasReusableRazorpayOrder => reusableCheckoutOrder != null;

  bool get hasReusablePaymentLink => reusablePaymentLink != null;

  String? get runEventId => runEvent?.getId();
  RunEventModel? get runEventModel => runEvent?.getModel();
  bool get runEventPopulated => runEvent?.isPopulated ?? false;

  UserModel? get userModel => userId?.getModel();
  bool get userPopulated => userId?.isPopulated ?? false;

  static String? _trimmed(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  String get displayFullName =>
      _trimmed(fullName) ?? _trimmed(userModel?.fullName) ?? 'NA';

  String get displayEmail =>
      _trimmed(email) ?? _trimmed(userModel?.email) ?? 'NA';

  String get displayPhone =>
      _trimmed(phone) ?? _trimmed(userModel?.phone) ?? 'NA';

  String get displayContact {
    final phoneValue = _trimmed(phone) ?? _trimmed(userModel?.phone);
    final emailValue = _trimmed(email) ?? _trimmed(userModel?.email);
    if (phoneValue != null && emailValue != null) {
      return '$phoneValue · $emailValue';
    }
    return phoneValue ?? emailValue ?? '';
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
class PaginatedRunEventParticipants with PaginatedRunEventParticipantsMappable {
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
  final RazorpayOrderModel? order;
  final RazorpayPaymentLinkModel? paymentLink;

  const CreateParticipantOrderResponse({
    required this.participant,
    this.order,
    this.paymentLink,
  });

  static CreateParticipantOrderResponse fromApiMap(Map<String, dynamic> map) {
    return CreateParticipantOrderResponse(
      participant: RunEventParticipantModel.fromApiMap(
        Map<String, dynamic>.from(map['participant'] as Map),
      ),
      order: map['order'] is Map
          ? RazorpayOrderModel.fromMap(
              Map<String, dynamic>.from(map['order'] as Map),
            )
          : null,
      paymentLink: map['paymentLink'] is Map
          ? RazorpayPaymentLinkModel.fromMap(
              Map<String, dynamic>.from(map['paymentLink'] as Map),
            )
          : null,
    );
  }
}
