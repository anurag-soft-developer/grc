import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/components/events/public_event_list_tile.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';

/// No automatic retries — empty 200 responses must not loop refetch.
Duration? _noRetry(int count, Object error) => null;

class EventsScreen extends HookWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    final closedTabEnabled = useState(false);

    useEffect(() {
      void onTabChanged() {
        if (tabController.index == 1) {
          closedTabEnabled.value = true;
        }
      }

      tabController.addListener(onTabChanged);
      return () => tabController.removeListener(onTabChanged);
    }, [tabController]);

    final upcomingQuery = useInfiniteQuery<PaginatedRunEvents, Object, int>(
      QueryKeys.publicUpcomingEvents,
      (ctx) => RunEventsService.instance.listPublicEvents(
        segment: 'upcoming',
        page: ctx.pageParam,
      ),
      initialPageParam: 1,
      enabled: true,
      retry: _noRetry,
      nextPageParamBuilder: (data) {
        final last = data.pages.isNotEmpty ? data.pages.last : null;
        if (last == null || !last.hasMore) return null;
        return last.page + 1;
      },
    );

    final closedQuery = useInfiniteQuery<PaginatedRunEvents, Object, int>(
      QueryKeys.publicClosedEvents,
      (ctx) => RunEventsService.instance.listPublicEvents(
        segment: 'closed',
        page: ctx.pageParam,
      ),
      initialPageParam: 1,
      enabled: closedTabEnabled.value,
      retry: _noRetry,
      nextPageParamBuilder: (data) {
        final last = data.pages.isNotEmpty ? data.pages.last : null;
        if (last == null || !last.hasMore) return null;
        return last.page + 1;
      },
    );

    final upcomingEvents =
        upcomingQuery.data?.pages.expand((p) => p.data).toList() ??
        const <RunEventModel>[];

    final closedEvents =
        closedQuery.data?.pages.expand((p) => p.data).toList() ??
        const <RunEventModel>[];

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(
        title: const Text('Events'),
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Closed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _EventsTabContent(
            query: upcomingQuery,
            events: upcomingEvents,
            emptyWidget: const _ComingSoonEmpty(),
            emptyMessage: 'No upcoming events found',
          ),
          _EventsTabContent(
            query: closedQuery,
            events: closedEvents,
            emptyWidget: const _EmptyTabMessage('No closed events yet'),
            emptyMessage: 'No closed events found',
            waitForEnable: !closedTabEnabled.value,
          ),
        ],
      ),
    );
  }
}

class _EventsTabContent extends HookWidget {
  final InfiniteQueryResult<PaginatedRunEvents, Object, int> query;
  final List<RunEventModel> events;
  final Widget emptyWidget;
  final String emptyMessage;
  final bool waitForEnable;

  const _EventsTabContent({
    required this.query,
    required this.events,
    required this.emptyWidget,
    required this.emptyMessage,
    this.waitForEnable = false,
  });

  bool get _hasSettled => query.data != null || query.isError;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();

    if (waitForEnable) {
      return const SizedBox.shrink();
    }

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
              onPressed: () => query.refetch(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (events.isEmpty && _hasSettled) {
      return RefreshIndicator(
        onRefresh: () async => query.refetch(),
        color: const Color(AppColors.primary),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [emptyWidget],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => query.refetch(),
      color: const Color(AppColors.primary),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is! ScrollUpdateNotification) return false;
          if (notification.metrics.extentAfter > 160) return false;
          if (query.hasNextPage && !query.isFetchingNextPage) {
            query.fetchNextPage();
          }
          return false;
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
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
            return PublicEventListTile(event: events[index]);
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

class _EmptyTabMessage extends StatelessWidget {
  final String message;

  const _EmptyTabMessage(this.message);

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
