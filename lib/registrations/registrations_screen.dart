import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/components/home/home_section_message.dart';
import 'package:grc/components/home/home_upcoming_slot_card.dart';
import 'package:grc/core/components/bottom_navigation_panel/navigation_controller.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/registrations/model/run_event_participant_model.dart';
import 'package:grc/registrations/run_event_participants_service.dart';

Duration? _noRetry(int count, Object error) => null;

class RegistrationsScreen extends HookWidget {
  const RegistrationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final query = useInfiniteQuery<PaginatedRunEventParticipants, Object, int>(
      QueryKeys.myRegistrations,
      (ctx) => RunEventParticipantsService.instance.listMine(
        page: ctx.pageParam,
      ),
      initialPageParam: 1,
      retry: _noRetry,
      nextPageParamBuilder: (data) {
        final last = data.pages.isNotEmpty ? data.pages.last : null;
        if (last == null || !last.hasMore) return null;
        return last.page + 1;
      },
    );

    final items =
        query.data?.pages.expand((p) => p.data).toList() ??
        const <RunEventParticipantModel>[];

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: const Text('Registrations')),
      body: _buildBody(context, query, items),
    );
  }

  Widget _buildBody(
    BuildContext context,
    InfiniteQueryResult<PaginatedRunEventParticipants, Object, int> query,
    List<RunEventParticipantModel> items,
  ) {
    if (query.isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (query.isError && items.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => query.refetch(),
        color: const Color(AppColors.primary),
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
      );
    }
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => query.refetch(),
        color: const Color(AppColors.primary),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            HomeSectionMessage(
              message: 'No registrations yet',
              actionLabel: 'Browse events',
              onAction: () => Get.find<NavigationController>().changeTab(1),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => query.refetch(),
      color: const Color(AppColors.primary),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.extentAfter < 160 &&
              query.hasNextPage &&
              !query.isFetchingNextPage) {
            query.fetchNextPage();
          }
          return false;
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          itemCount: items.length + (query.isFetchingNextPage ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index >= items.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return HomeUpcomingSlotCard(participant: items[index]);
          },
        ),
      ),
    );
  }
}
