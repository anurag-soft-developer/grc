import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/components/events/event_list_filters.dart';
import 'package:grc/components/events/event_list_filters_bar.dart';
import 'package:grc/components/events/public_event_list_tile.dart';
import 'package:grc/core/components/layout/adaptive_page_container.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/routes/main_tab_routes.dart';

/// No automatic retries — empty 200 responses must not loop refetch.
Duration? _noRetry(int count, Object error) => null;

class EventsScreen extends HookWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isActiveTab =
        Uri.parse(Get.currentRoute).path == MainTabRoutes.events;
    final filters = useState(EventListFilters.all);
    final queryKey = QueryKeys.publicEventsList(
      filters.value.toQueryKeyParts(),
    );

    final eventsQuery = useInfiniteQuery<PaginatedRunEvents, Object, int>(
      queryKey,
      (ctx) => RunEventsService.instance.listPublicEvents(
        segment: filters.value.apiSegment,
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

    final events =
        eventsQuery.data?.pages.expand((p) => p.data).toList() ??
        const <RunEventModel>[];

    final segmentMode = filters.value.segmentMode;

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: const Text('Events')),
      body: Column(
        children: [
          EventListFiltersBar(
            filters: filters.value,
            onChanged: (next) => filters.value = next,
          ),
          Expanded(
            child: _EventsListContent(
              query: eventsQuery,
              events: events,
              emptyWidget: switch (segmentMode) {
                EventSegmentFilterMode.closed => const _EmptyListMessage(
                  'No closed events yet',
                ),
                EventSegmentFilterMode.upcoming => const _ComingSoonEmpty(),
                EventSegmentFilterMode.all => const _EmptyListMessage(
                  'No events found',
                ),
              },
              emptyMessage: switch (segmentMode) {
                EventSegmentFilterMode.closed => 'No closed events found',
                EventSegmentFilterMode.upcoming => 'No upcoming events found',
                EventSegmentFilterMode.all => 'No events found',
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EventsListContent extends StatelessWidget {
  final InfiniteQueryResult<PaginatedRunEvents, Object, int> query;
  final List<RunEventModel> events;
  final Widget emptyWidget;
  final String emptyMessage;

  const _EventsListContent({
    required this.query,
    required this.events,
    required this.emptyWidget,
    required this.emptyMessage,
  });

  bool get _hasSettled => query.data != null || query.isError;

  Future<void> _safeRefetch(BuildContext context) async {
    if (!context.mounted) return;
    await query.refetch();
  }

  void _safeFetchNextPage(BuildContext context) {
    if (!context.mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      if (Uri.parse(Get.currentRoute).path != MainTabRoutes.events) return;
      if (query.hasNextPage && !query.isFetchingNextPage) {
        query.fetchNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (query.data == null && query.isFetching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (query.isError && events.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_busy_outlined,
              size: 48,
              color: Color(AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(emptyMessage),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _safeRefetch(context),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (events.isEmpty && _hasSettled) {
      return RefreshIndicator(
        onRefresh: () => _safeRefetch(context),
        color: const Color(AppColors.primary),
        child: AdaptivePageContainer(
          maxWidth: EventListFiltersBar.listMaxWidth,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(
              EventListFiltersBar.horizontalPadding,
            ),
            children: [emptyWidget],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _safeRefetch(context),
      color: const Color(AppColors.primary),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is! ScrollUpdateNotification) return false;
          if (notification.metrics.extentAfter > 160) return false;
          _safeFetchNextPage(context);
          return false;
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(EventListFiltersBar.horizontalPadding),
          itemCount: events.length + (query.isFetchingNextPage ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= events.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: EventListFiltersBar.listMaxWidth,
                ),
                child: PublicEventListTile(event: events[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ComingSoonEmpty extends StatelessWidget {
  const _ComingSoonEmpty();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.event_outlined,
            size: 48,
            color: Color(AppColors.secondary),
          ),
          SizedBox(height: 12),
          Text(
            'Coming soon',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(AppColors.textSecondary),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'New events will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Color(AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyListMessage extends StatelessWidget {
  final String message;

  const _EmptyListMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Color(AppColors.textSecondary)),
        ),
      ),
    );
  }
}
