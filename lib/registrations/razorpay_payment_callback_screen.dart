import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/core/auth/auth_state_controller.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/repositories/auth_repository.dart';
import 'package:grc/core/routes/main_tab_routes.dart';
import 'package:grc/core/utils/exception_handler.dart';
import 'package:grc/registrations/run_event_participants_service.dart';

class RazorpayPaymentCallbackScreen extends StatefulWidget {
  const RazorpayPaymentCallbackScreen({super.key});

  @override
  State<RazorpayPaymentCallbackScreen> createState() =>
      _RazorpayPaymentCallbackScreenState();
}

class _RazorpayPaymentCallbackScreenState
    extends State<RazorpayPaymentCallbackScreen> {
  final RunEventParticipantsService _service =
      RunEventParticipantsService.instance;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _hydrateSession();
    if (!mounted) return;
    await _completePayment();
  }

  Future<void> _hydrateSession() async {
    final auth = Get.find<AuthStateController>();
    if (auth.isLoggedIn) return;

    final stored = await Get.find<AuthRepository>().getStoredUser();
    if (stored != null) {
      auth.setUser(stored);
    }
  }

  Future<void> _completePayment() async {
    try {
      final uri = Uri.base;
      final params = uri.queryParameters;

      final eventId = params['eventId']?.trim();
      final participantId = params['participantId']?.trim();
      final paymentLinkId = params['razorpay_payment_link_id']?.trim();
      final referenceId = params['razorpay_payment_link_reference_id']?.trim();
      final status = params['razorpay_payment_link_status']?.trim();
      final paymentId = params['razorpay_payment_id']?.trim();
      final signature = params['razorpay_signature']?.trim();

      if (eventId == null ||
          eventId.isEmpty ||
          participantId == null ||
          participantId.isEmpty) {
        throw Exception('Missing registration details');
      }

      if (status != 'paid') {
        throw Exception('Payment was not completed');
      }

      if (paymentLinkId == null ||
          paymentLinkId.isEmpty ||
          referenceId == null ||
          referenceId.isEmpty ||
          paymentId == null ||
          paymentId.isEmpty ||
          signature == null ||
          signature.isEmpty) {
        throw Exception('Missing payment verification details');
      }

      final verified = await _service.verifyHostedPayment(
        eventId,
        participantId: participantId,
        razorpayPaymentLinkId: paymentLinkId,
        razorpayPaymentLinkReferenceId: referenceId,
        razorpayPaymentLinkStatus: status!,
        razorpayPaymentId: paymentId,
        razorpaySignature: signature,
      );

      if (verified == null) {
        throw Exception('Payment verification failed');
      }

      ExceptionHandler.showSuccessToast('Payment successful');

      if (!mounted) return;
      Get.offAllNamed(AppConstants.routes.registrationDetailPath(participantId));
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error =
            e.response?.data is Map &&
                (e.response!.data as Map)['message'] is String
            ? (e.response!.data as Map)['message'] as String
            : 'Payment verification failed. Please try again.';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _goToRegistrations() {
    Get.offAllNamed(MainTabRoutes.registrations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isLoading) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text('Verifying your payment...'),
                    ] else ...[
                      Text(
                        _error ?? 'Unable to verify payment.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(AppColors.error)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _goToRegistrations,
                        child: const Text('Go to registrations'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
