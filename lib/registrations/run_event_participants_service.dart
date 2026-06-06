import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/core/config/api_constants.dart';
import 'package:grc/core/services/api_service.dart';
import 'package:grc/registrations/model/event_registration_status.dart';
import 'package:grc/registrations/model/run_event_participant_model.dart';
import 'package:grc/registrations/model/run_event_registration_context.dart';

class RunEventParticipantsService {
  static final RunEventParticipantsService instance =
      RunEventParticipantsService._();
  RunEventParticipantsService._();

  final ApiService _api = ApiService();

  Future<RunEventRegistrationContext?> getRegistrationContext(
    String eventId,
  ) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.runEvents.registrationContext(eventId),
    );
    if (response == null) return null;
    return RunEventRegistrationContext.fromApiMap(response);
  }

  Future<RunEventRegistrationContext?> getPublicContextBySlug(
    String slug,
  ) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.runEvents.publicBySlug(slug),
    );
    if (response == null) return null;
    return RunEventRegistrationContext(
      event: RunEventModel.fromMap(response),
    );
  }

  Future<EventRegistrationStatus> getMyRegistrationStatus(String eventId) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.runEventParticipants.myRegistration(eventId),
    );
    if (response == null) {
      return EventRegistrationStatus.none;
    }
    return EventRegistrationStatus.fromMap(response);
  }

  Future<RunEventParticipantModel?> getOrCreateDraft(String eventId) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.runEventParticipants.draft(eventId),
    );
    if (response == null) return null;
    return RunEventParticipantModel.fromApiMap(response);
  }

  Future<RunEventParticipantModel?> updateDraft(
    String eventId,
    Map<String, dynamic> body,
  ) async {
    final response = await _api.patch<Map<String, dynamic>>(
      ApiConstants.runEventParticipants.draft(eventId),
      data: body,
    );
    if (response == null) return null;
    return RunEventParticipantModel.fromApiMap(response);
  }

  Future<RunEventParticipantModel?> submit(
    String eventId,
    Map<String, dynamic> body,
  ) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.runEventParticipants.submitDraft(eventId),
      data: body,
    );
    if (response == null) return null;
    return RunEventParticipantModel.fromApiMap(response);
  }

  Future<CreateParticipantOrderResponse?> createOrder(String eventId) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.runEventParticipants.createOrder(eventId),
    );
    if (response == null) return null;
    return CreateParticipantOrderResponse.fromApiMap(response);
  }

  Future<RunEventParticipantModel?> verifyPayment(
    String eventId, {
    required String participantId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.runEventParticipants.verifyPayment(eventId),
      data: {
        'participantId': participantId,
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
      },
    );
    if (response == null) return null;
    return RunEventParticipantModel.fromApiMap(response);
  }

  Future<PaginatedRunEventParticipants> listByEvent(
    String eventId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.runEventParticipants.listByEvent(eventId),
      queryParameters: {'page': page, 'limit': limit},
    );
    if (response == null) {
      throw Exception('Failed to load participants');
    }
    return PaginatedRunEventParticipants.fromApiMap(
      response,
      fallbackPage: page,
    );
  }

  Future<PaginatedRunEventParticipants> listMine({
    int page = 1,
    int limit = 10,
    String segment = 'all',
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.runEventParticipants.me,
      queryParameters: {
        'page': page,
        'limit': limit,
        'segment': segment,
      },
    );
    if (response == null) {
      throw Exception('Failed to load registrations');
    }
    return PaginatedRunEventParticipants.fromApiMap(
      response,
      fallbackPage: page,
    );
  }

  Future<RunEventParticipantModel?> getById(String id) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.runEventParticipants.byId(id),
    );
    if (response == null) return null;
    return RunEventParticipantModel.fromApiMap(response);
  }
}
