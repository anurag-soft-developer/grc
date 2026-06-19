import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/components/admin/event_list_tile.dart';
import 'package:grc/components/events/event_list_filters.dart';
import 'package:grc/components/events/event_list_filters_bar.dart';
import 'package:grc/core/components/layout/adaptive_page_container.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';

class MyEventsScreen extends HookWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = useState(EventListFilters.all);
    final queryKey = useMemoized(
      () => QueryKeys.adminEventsList(filters.value.toQueryKeyParts()),
      [filters.value],
    );

    final eventsQuery = useInfiniteQuery<PaginatedRunEvents, Object, int>(
      queryKey,
      (ctx) => RunEventsService.instance.listEvents(
        page: ctx.pageParam,
        filters: filters.value,
      ),
      initialPageParam: 1,
      nextPageParamBuilder: (data) {
        final last = data.pages.isNotEmpty ? data.pages.last : null;
        if (last == null || !last.hasMore) return null;
        return last.page + 1;
      },
    );

    final allEvents =
        eventsQuery.data?.pages.expand((p) => p.data).toList() ??
        const <RunEventModel>[];

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: const Text('My Events')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppConstants.routes.eventForm),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          EventListFiltersBar(
            filters: filters.value,
            onChanged: (next) => filters.value = next,
          ),
          Expanded(child: _buildBody(eventsQuery, allEvents)),
        ],
      ),
    );
  }

  Widget _buildBody(
    InfiniteQueryResult<PaginatedRunEvents, Object, int> eventsQuery,
    List<RunEventModel> allEvents,
  ) {
    if (eventsQuery.isLoading && allEvents.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventsQuery.isError && allEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Failed to load events'),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => eventsQuery.refetch(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (allEvents.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => eventsQuery.refetch(),
        color: const Color(AppColors.primary),
        child: AdaptivePageContainer(
          maxWidth: EventListFiltersBar.listMaxWidth,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(EventListFiltersBar.horizontalPadding),
            children: const [
              SizedBox(
                height: 240,
                child: Center(
                  child: Text('No events yet. Tap + to create one.'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => eventsQuery.refetch(),
      color: const Color(AppColors.primary),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent - 160) {
            if (eventsQuery.hasNextPage && !eventsQuery.isFetchingNextPage) {
              eventsQuery.fetchNextPage();
            }
          }
          return false;
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(EventListFiltersBar.horizontalPadding),
          itemCount:
              allEvents.length + (eventsQuery.isFetchingNextPage ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= allEvents.length) {
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
                child: AdminEventListTile(event: allEvents[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
