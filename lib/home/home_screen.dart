import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/components/home/home_registered_slots_section.dart';
import 'package:grc/components/home/home_upcoming_events_carousel.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/registrations/model/run_event_participant_model.dart';
import 'package:grc/registrations/run_event_participants_service.dart';

Duration? _noRetry(int count, Object error) => null;

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventsQuery = useQuery<PaginatedRunEvents, Object>(
      QueryKeys.homeUpcomingEvents,
      (_) => RunEventsService.instance.listPublicEvents(
        segment: 'upcoming',
        page: 1,
        limit: 5,
      ),
      retry: _noRetry,
    );

    final registrationsQuery = useQuery<PaginatedRunEventParticipants, Object>(
      QueryKeys.myUpcomingRegistrations,
      (_) => RunEventParticipantsService.instance.listMine(
        page: 1,
        limit: 20,
        segment: 'upcoming',
      ),
      retry: _noRetry,
    );

    final events = eventsQuery.data?.data ?? const <RunEventModel>[];
    final slots =
        registrationsQuery.data?.data ?? const <RunEventParticipantModel>[];

    Future<void> onRefresh() async {
      await Future.wait([eventsQuery.refetch(), registrationsQuery.refetch()]);
    }

    final isInitialLoading =
        (eventsQuery.isLoading && events.isEmpty) &&
        (registrationsQuery.isLoading && slots.isEmpty);

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: const Text('Home')),
      body: isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: onRefresh,
              color: const Color(AppColors.primary),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: Text(
                      'Upcoming events',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(AppColors.text),
                      ),
                    ),
                  ),
                  HomeUpcomingEventsCarousel(
                    events: events,
                    isLoading: eventsQuery.isLoading && events.isEmpty,
                    isError: eventsQuery.isError && events.isEmpty,
                    onRetry: eventsQuery.refetch,
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your registrations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(AppColors.text),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Get.find<NavigationController>().changeTab(2),
                          child: const Text('View all'),
                        ),
                      ],
                    ),
                  ),
                  HomeRegisteredSlotsSection(
                    slots: slots,
                    isLoading: registrationsQuery.isLoading && slots.isEmpty,
                    isError: registrationsQuery.isError && slots.isEmpty,
                    onRetry: registrationsQuery.refetch,
                  ),
                ],
              ),
            ),
    );
  }
}
