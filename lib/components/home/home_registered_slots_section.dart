import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/components/home/home_section_message.dart';
import 'package:grc/components/home/home_upcoming_slot_card.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';
import 'package:grc/registrations/model/run_event_participant_model.dart';

class HomeRegisteredSlotsSection extends StatelessWidget {
  final List<RunEventParticipantModel> slots;
  final bool isLoading;
  final bool isError;
  final VoidCallback onRetry;

  const HomeRegisteredSlotsSection({
    super.key,
    required this.slots,
    required this.isLoading,
    required this.isError,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (isError) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: HomeSectionMessage(
          message: 'Could not load your registrations',
          actionLabel: 'Retry',
          onAction: onRetry,
        ),
      );
    }

    if (slots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: HomeSectionMessage(
          message: 'No upcoming registrations yet',
          actionLabel: 'Browse events',
          onAction: () => Get.find<NavigationController>().changeTab(1),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: slots
            .map(
              (slot) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HomeUpcomingSlotCard(participant: slot),
              ),
            )
            .toList(),
      ),
    );
  }
}
