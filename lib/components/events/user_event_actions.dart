import 'package:flutter/material.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/core/utils/exception_handler.dart';

class UserEventActions extends StatelessWidget {
  final RunEventModel event;

  const UserEventActions({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final isOpen = event.isOpenForRegistration;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: isOpen ? 'Register' : 'Registrations closed',
          icon: Icon(
            isOpen ? Icons.how_to_reg_outlined : Icons.lock_outline,
            size: 20,
          ),
          onPressed: isOpen
              ? () => ExceptionHandler.showInfoToast(
                  'Registration coming soon',
                )
              : null,
        ),
      ),
    );
  }
}
