import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/components/events/event_registration_acceptance_dialog.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/registrations/event_registration_binding.dart';
import 'package:grc/registrations/event_registration_controller.dart';
import 'package:grc/registrations/model/event_registration_status.dart';
import 'package:grc/registrations/run_event_participants_service.dart';

Duration? _noRetry(int count, Object error) => null;

class _EventActionConfig {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const _EventActionConfig({
    required this.label,
    required this.icon,
    this.onPressed,
  });
}

class UserEventActions extends HookWidget {
  final RunEventModel event;

  const UserEventActions({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final eventId = event.id;
    final isOpen = event.isOpenForRegistration;

    final statusQuery = useQuery<EventRegistrationStatus, Object>(
      QueryKeys.eventRegistrationStatus(eventId ?? ''),
      (_) => RunEventParticipantsService.instance.getMyRegistrationStatus(
        eventId!,
      ),
      enabled: eventId != null && eventId.isNotEmpty,
      retry: _noRetry,
    );

    final registrationController = useMemoized(() {
      EventRegistrationBinding().dependencies();
      return Get.find<EventRegistrationController>();
    }, const []);

    final config = _resolveAction(
      context: context,
      isOpen: isOpen,
      status: statusQuery.data,
      isLoading: statusQuery.isLoading && statusQuery.data == null,
      hasError: statusQuery.isError,
      event: event,
      controller: registrationController,
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: statusQuery.isLoading && statusQuery.data == null
            ? const SizedBox(
                height: 48,
                child: Center(child: CircularProgressIndicator()),
              )
            : CustomButton(
                text: config.label,
                icon: Icon(config.icon, size: 20),
                onPressed: config.onPressed,
              ),
      ),
    );
  }

  _EventActionConfig _resolveAction({
    required BuildContext context,
    required bool isOpen,
    required EventRegistrationStatus? status,
    required bool isLoading,
    required bool hasError,
    required RunEventModel event,
    required EventRegistrationController controller,
  }) {
    if (isLoading) {
      return const _EventActionConfig(
        label: 'Loading...',
        icon: Icons.hourglass_empty,
      );
    }

    final reg = hasError || status == null
        ? EventRegistrationStatus.none
        : status;

    if (reg.isTicket) {
      final participantId = reg.participantId!;
      return _EventActionConfig(
        label: 'Ticket',
        icon: Icons.confirmation_number_outlined,
        onPressed: () => controller.openTicket(
          participantId,
          eventId: event.id,
        ),
      );
    }

    if (reg.canPayNow(isOpen)) {
      final participantId = reg.participantId!;
      return _EventActionConfig(
        label: 'Pay now',
        icon: Icons.payment_outlined,
        onPressed: () => controller.payNowForEvent(event, participantId),
      );
    }

    if (reg.canContinue(isOpen)) {
      return _EventActionConfig(
        label: 'Continue registration',
        icon: Icons.edit_note_outlined,
        onPressed: () => controller.continueRegistration(event),
      );
    }

    if (reg.canRegister(isOpen)) {
      return _EventActionConfig(
        label: 'Register',
        icon: Icons.how_to_reg_outlined,
        onPressed: () => _startRegistrationWithAcceptance(
          context,
          event,
          controller,
        ),
      );
    }

    return const _EventActionConfig(
      label: 'Registrations closed',
      icon: Icons.lock_outline,
    );
  }
}

Future<void> _startRegistrationWithAcceptance(
  BuildContext context,
  RunEventModel event,
  EventRegistrationController controller,
) async {
  final accepted = await EventRegistrationAcceptanceDialog.show(
    context,
    event: event,
  );
  if (!accepted || !context.mounted) return;
  await controller.startRegistration(event);
}
