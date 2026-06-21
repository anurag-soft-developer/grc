import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/components/events/event_list_filters.dart';
import 'package:grc/components/events/event_list_filters_bar.dart';
import 'package:grc/components/home/home_section_message.dart';
import 'package:grc/components/home/home_upcoming_slot_card.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';
import 'package:grc/core/components/layout/adaptive_page_container.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/routes/main_tab_routes.dart';
import 'package:grc/registrations/model/run_event_participant_model.dart';
import 'package:grc/registrations/run_event_participants_service.dart';

Duration? _noRetry(int count, Object error) => null;

class RegistrationsScreen extends HookWidget {
  const RegistrationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isActiveTab =
        Uri.parse(Get.currentRoute).path == MainTabRoutes.registrations;
    final filters = useState(EventListFilters.all);
    final queryKey = QueryKeys.myRegistrationsList(
      filters.value.toQueryKeyParts(),
    );

    final query = useInfiniteQuery<PaginatedRunEventParticipants, Object, int>(
      queryKey,
      (ctx) => RunEventParticipantsService.instance.listMine(
        page: ctx.pageParam,
        filters: filters.value,
      ),
      initialPageParam: 1,
      retry: _noRetry,
      enabled: isActiveTab,
      nextPageParamBuilder: (data) {
        final last = data.pages.isNotEmpty ? data.pages.last : null;
        if (last == null || !last.hasMore) return null;
        return last.page + 1;
      },
    );

    final items =
        query.data?.pages.expand((p) => p.data).toList() ??
        const <RunEventParticipantModel>[];

    final segmentMode = filters.value.segmentMode;

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: const Text('Registrations')),
      body: Column(
        children: [
          EventListFiltersBar(
            filters: filters.value,
            onChanged: (next) => filters.value = next,
          ),
          Expanded(
            child: _RegistrationsListContent(
              query: query,
              items: items,
              segmentMode: segmentMode,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrationsListContent extends StatelessWidget {
  final InfiniteQueryResult<PaginatedRunEventParticipants, Object, int> query;
  final List<RunEventParticipantModel> items;
  final EventSegmentFilterMode segmentMode;

  const _RegistrationsListContent({
    required this.query,
    required this.items,
    required this.segmentMode,
  });

  String get _emptyMessage => switch (segmentMode) {
    EventSegmentFilterMode.closed => 'No closed registrations found',
    EventSegmentFilterMode.upcoming => 'No upcoming registrations found',
    EventSegmentFilterMode.all => 'No registrations found',
  };

  @override
  Widget build(BuildContext context) {
    if (query.isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (query.isError && items.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => query.refetch(),
        color: const Color(AppColors.primary),
        child: AdaptivePageContainer(
          maxWidth: EventListFiltersBar.listMaxWidth,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            children: [
              HomeSectionMessage(
                message: 'Could not load your registrations',
                actionLabel: 'Retry',
                onAction: query.refetch,
              ),
            ],
          ),
        ),
      );
    }
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => query.refetch(),
        color: const Color(AppColors.primary),
        child: AdaptivePageContainer(
          maxWidth: EventListFiltersBar.listMaxWidth,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(EventListFiltersBar.horizontalPadding),
            children: [
              if (segmentMode == EventSegmentFilterMode.upcoming)
                HomeSectionMessage(
                  message: _emptyMessage,
                  actionLabel: 'Browse events',
                  onAction: () => Get.find<NavigationController>().changeTab(1),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Text(
                      _emptyMessage,
                      style: const TextStyle(
                        color: Color(AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => query.refetch(),
      color: const Color(AppColors.primary),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (Uri.parse(Get.currentRoute).path != MainTabRoutes.registrations) {
            return false;
          }
          if (n.metrics.extentAfter < 160 &&
              query.hasNextPage &&
              !query.isFetchingNextPage) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              if (Uri.parse(Get.currentRoute).path !=
                  MainTabRoutes.registrations) {
                return;
              }
              if (query.hasNextPage && !query.isFetchingNextPage) {
                query.fetchNextPage();
              }
            });
          }
          return false;
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            EventListFiltersBar.horizontalPadding,
            8,
            EventListFiltersBar.horizontalPadding,
            24,
          ),
          itemCount: items.length + (query.isFetchingNextPage ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index >= items.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: EventListFiltersBar.listMaxWidth,
                ),
                child: HomeUpcomingSlotCard(participant: items[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
