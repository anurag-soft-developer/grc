import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/form/event_form_screen.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/components/admin/event_list_tile.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';

class MyEventsScreen extends HookWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventsQuery = useInfiniteQuery<PaginatedRunEvents, Object, int>(
      QueryKeys.adminEvents,
      (ctx) => RunEventsService.instance.listEvents(page: ctx.pageParam),
      initialPageParam: 1,
      nextPageParamBuilder: (data) {
        final last = data.pages.isNotEmpty ? data.pages.last : null;
        if (last == null || !last.hasMore) return null;
        return last.page + 1;
      },
    );

    final allEvents = eventsQuery.data?.pages
            .expand((p) => p.data)
            .toList() ??
        const <RunEventModel>[];

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: const Text('My Events')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(
          AppConstants.routes.eventForm,
          arguments: eventFormCreate,
        ),
        child: const Icon(Icons.add),
      ),
      body: _buildBody(eventsQuery, allEvents),
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
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(
              height: 240,
              child: Center(
                child: Text('No events yet. Tap + to create one.'),
              ),
            ),
          ],
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
          padding: const EdgeInsets.all(16),
          itemCount: allEvents.length + (eventsQuery.isFetchingNextPage ? 1 : 0),
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
            return AdminEventListTile(event: allEvents[index]);
          },
        ),
      ),
    );
  }
}
