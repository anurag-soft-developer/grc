import 'package:dio/dio.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/core/config/env_config.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/utils/exception_handler.dart';
import 'package:grc/registrations/model/custom_question_model.dart';
import 'package:grc/registrations/model/razorpay_order_model.dart';
import 'package:grc/registrations/model/run_event_participant_model.dart';
import 'package:grc/registrations/model/run_event_registration_context.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/registrations/run_event_participants_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class EventRegistrationController extends GetxController {
  final RunEventParticipantsService _service =
      RunEventParticipantsService.instance;

  late final Razorpay _razorpay;
  String? _pendingParticipantId;
  String? _pendingOrderId;
  String? _eventId;

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final Rxn<RunEventRegistrationContext> context =
      Rxn<RunEventRegistrationContext>();
  final Rxn<RunEventParticipantModel> participant =
      Rxn<RunEventParticipantModel>();
  final RxBool alreadyRegistered = false.obs;

  final Map<String, dynamic> customAnswers = {};
  final Map<String, String> fieldErrors = {};

  /// Bumped when non-text form controls change so [Obx] rebuilds the form.
  final RxInt formRevision = 0.obs;

  void notifyFormChanged() => formRevision.value++;

  void clearFieldError(String key) {
    if (fieldErrors.remove(key) != null) {
      formRevision.value++;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  RunEventModel? get event => context.value?.event;
  List<CustomQuestionModel> get customQuestions {
    final questions = event?.customQuestions ?? const [];
    return List<CustomQuestionModel>.from(questions)
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  Future<void> continueRegistration(RunEventModel runEvent) =>
      startRegistration(runEvent);

  Future<void> payNowForEvent(
    RunEventModel runEvent,
    String participantId,
  ) async {
    final eventId = runEvent.id;
    if (eventId == null || eventId.isEmpty) return;
    _eventId = eventId;
    try {
      final loaded = await _service.getById(participantId);
      if (loaded == null) {
        ExceptionHandler.showErrorToast('Registration not found');
        return;
      }
      await payNowFromDetail(loaded);
    } on DioException catch (e) {
      ExceptionHandler.handleDioException(e);
    } catch (e) {
      ExceptionHandler.handleGenericException(e);
    }
  }

  Future<void> openTicket(
    String participantId, {
    String? eventId,
  }) async {
    if (eventId != null) {
      _eventId = eventId;
    }
    await Get.toNamed(
      AppConstants.routes.registrationDetail,
      arguments: participantId,
    );
    await _invalidateEventRegistrationStatus();
  }

  Future<void> _invalidateEventRegistrationStatus() async {
    final eventId = _eventId;
    if (eventId == null) return;
    await QueryClient().invalidateQueries(
      queryKey: QueryKeys.eventRegistrationStatus(eventId),
    );
  }

  Future<void> startRegistration(RunEventModel runEvent) async {
    final eventId = runEvent.id;
    if (eventId == null || eventId.isEmpty) {
      ExceptionHandler.showErrorToast('Event not found');
      return;
    }
    _eventId = eventId;
    isLoading.value = true;
    alreadyRegistered.value = false;
    try {
      RunEventRegistrationContext? loaded;
      final slug = runEvent.slug?.trim();
      if (slug != null && slug.isNotEmpty) {
        loaded = await _service.getPublicContextBySlug(slug);
      }
      loaded ??= await _service.getRegistrationContext(eventId);
      if (loaded == null) {
        ExceptionHandler.showErrorToast('Could not load registration form');
        return;
      }
      context.value = loaded;
      await _loadDraft(eventId);
      if (alreadyRegistered.value) {
        ExceptionHandler.showErrorToast(
          'You have already registered for this event',
        );
        return;
      }
      if (customQuestions.isEmpty) {
        await submitAndContinue();
        await _invalidateEventRegistrationStatus();
        return;
      }
      isLoading.value = false;
      await Get.toNamed(AppConstants.routes.registrationForm);
      await _invalidateEventRegistrationStatus();
    } on DioException catch (e) {
      ExceptionHandler.handleDioException(e);
    } catch (e) {
      ExceptionHandler.handleGenericException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadForPaymentResume({
    required String eventId,
    required RunEventParticipantModel existing,
  }) async {
    _eventId = eventId;
    isLoading.value = true;
    try {
      context.value =
          await _service.getRegistrationContext(eventId) ??
          RunEventRegistrationContext(
            event: existing.runEventModel ?? const RunEventModel(title: ''),
          );
      participant.value = existing;
      Get.toNamed(AppConstants.routes.registrationForm);
    } on DioException catch (e) {
      ExceptionHandler.handleDioException(e);
    } catch (e) {
      ExceptionHandler.handleGenericException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> payNowFromDetail(RunEventParticipantModel p) async {
    final eventId = p.runEventModel?.id ?? _eventId;
    if (eventId == null) return;
    _eventId = eventId;
    participant.value = p;
    isSubmitting.value = true;
    try {
      final orderResponse = await _service.createOrder(eventId);
      if (orderResponse == null) {
        ExceptionHandler.showErrorToast('Could not start payment');
        return;
      }
      participant.value = orderResponse.participant;
      _openRazorpayCheckout(
        order: orderResponse.order,
        participantModel: orderResponse.participant,
      );
    } on DioException catch (e) {
      ExceptionHandler.handleDioException(e);
    } catch (e) {
      ExceptionHandler.handleGenericException(e);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _loadDraft(String eventId) async {
    try {
      final draft = await _service.getOrCreateDraft(eventId);
      if (draft == null) return;
      participant.value = draft;
      _applyParticipantToForm(draft);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        alreadyRegistered.value = true;
      } else {
        ExceptionHandler.handleDioException(e);
      }
    }
  }

  void _applyParticipantToForm(RunEventParticipantModel p) {
    customAnswers.addAll(p.customQuestionResponses);
  }

  Map<String, dynamic> buildSubmitBody() {
    if (customAnswers.isEmpty) return const {};
    return {
      'customQuestionResponses': Map<String, dynamic>.from(customAnswers),
    };
  }

  bool validateForm() {
    fieldErrors.clear();
    var isValid = true;

    for (final q in customQuestions) {
      if (!q.required) continue;
      final value = customAnswers[q.key];
      if (value == null ||
          (value is String && value.trim().isEmpty) ||
          (value is List && value.isEmpty)) {
        fieldErrors[q.key] = '${q.label} is required';
        isValid = false;
      }
    }

    if (!isValid) {
      formRevision.value++;
    }
    return isValid;
  }

  Future<void> submitAndContinue() async {
    final eventId = _eventId;
    if (eventId == null) return;
    if (!validateForm()) return;

    isSubmitting.value = true;
    try {
      final body = buildSubmitBody();
      await _service.updateDraft(eventId, body);
      final result = await _service.submit(eventId, body);
      if (result == null) {
        ExceptionHandler.showErrorToast('Registration failed');
        return;
      }
      participant.value = result;

      final price = event?.price ?? 0;
      if (price > 0 && result.isPendingPayment) {
        final orderResponse = await _service.createOrder(eventId);
        if (orderResponse == null) {
          ExceptionHandler.showErrorToast('Could not start payment');
          return;
        }
        participant.value = orderResponse.participant;
        _openRazorpayCheckout(
          order: orderResponse.order,
          participantModel: orderResponse.participant,
        );
        return;
      }

      if (result.isSubmitted || result.isPaid) {
        ExceptionHandler.showSuccessToast('Registration successful');
        _goToDetail(result.id);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        alreadyRegistered.value = true;
        ExceptionHandler.showErrorToast(
          'You have already registered for this event',
        );
      } else {
        ExceptionHandler.handleDioException(e);
      }
    } catch (e) {
      ExceptionHandler.handleGenericException(e);
    } finally {
      isSubmitting.value = false;
    }
  }

  void _openRazorpayCheckout({
    required RazorpayOrderModel order,
    required RunEventParticipantModel participantModel,
  }) {
    final key = EnvConfig.razorpayKeyId;
    if (key.isEmpty) {
      ExceptionHandler.showErrorToast(
        'Razorpay key is not configured. Add RAZORPAY_KEY_ID to .env',
      );
      return;
    }

    final participantId = participantModel.id;
    if (participantId == null) return;

    _pendingParticipantId = participantId;
    _pendingOrderId = order.id;

    _razorpay.open({
      'key': key,
      'amount': order.amount,
      'order_id': order.id,
      'name': EnvConfig.appName,
      'description': 'Event registration payment',
      'currency': order.currency,
      'prefill': {'contact': '', 'email': ''},
      'theme': {'color': '#00835A'},
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final eventId = _eventId;
    final participantId = _pendingParticipantId;
    final orderId = _pendingOrderId;
    if (eventId == null ||
        participantId == null ||
        orderId == null ||
        response.paymentId == null ||
        response.signature == null) {
      ExceptionHandler.showErrorToast('Payment verification failed');
      return;
    }

    isSubmitting.value = true;
    try {
      final verified = await _service.verifyPayment(
        eventId,
        participantId: participantId,
        razorpayOrderId: orderId,
        razorpayPaymentId: response.paymentId!,
        razorpaySignature: response.signature!,
      );
      if (verified == null) {
        ExceptionHandler.showErrorToast('Payment verification failed');
        return;
      }
      participant.value = verified;
      ExceptionHandler.showSuccessToast('Payment successful');
      _goToDetail(verified.id);
    } on DioException catch (e) {
      ExceptionHandler.handleDioException(e);
    } catch (e) {
      ExceptionHandler.handleGenericException(e);
    } finally {
      isSubmitting.value = false;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ExceptionHandler.showErrorToast(
      response.message ?? 'Payment failed',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ExceptionHandler.showInfoToast(
      'External wallet: ${response.walletName ?? ''}',
    );
  }

  void _goToDetail(String? participantId) {
    if (participantId == null) return;
    _invalidateEventRegistrationStatus();
    Get.offNamed(
      AppConstants.routes.registrationDetail,
      arguments: participantId,
    );
  }
}
