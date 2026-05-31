import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/form/event_form_screen.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/my_events_controller.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/components/admin/event_list_tile.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';

class MyEventsScreen extends HookWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyEventsController>();
    final eventsQuery = useInfiniteQuery<PaginatedRunEvents, Object, int>(
      QueryKeys.adminEvents,
      (ctx) => RunEventsService.instance.listEvents(page: ctx.pageParam),
      initialPageParam: 1,
      nextPageParamBuilder: (data) {
        final last = data.pages.isNotEmpty ? data.pages.last : null;
        if (last == null) return null;
        if (last.page < last.totalPages) return last.page + 1;
        return null;
      },
    );

    useEffect(() {
      void onScroll() {
        final pos = controller.scrollController.position;
        if (pos.pixels >= pos.maxScrollExtent - 240) {
          if (eventsQuery.hasNextPage && !eventsQuery.isFetchingNextPage) {
            eventsQuery.fetchNextPage();
          }
        }
      }

      controller.scrollController.addListener(onScroll);
      return () => controller.scrollController.removeListener(onScroll);
    }, [eventsQuery.hasNextPage, eventsQuery.isFetchingNextPage]);

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
      return const Center(child: Text('No events yet. Tap + to create one.'));
    }

    final controller = Get.find<MyEventsController>();

    return ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: allEvents.length + (eventsQuery.isFetchingNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= allEvents.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return AdminEventListTile(event: allEvents[index]);
      },
    );
  }
}
