import 'package:flutter/material.dart';
import 'package:grc/core/navigation/app_navigation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/participant_list_filters.dart';
import 'package:grc/admin/events/participant_list_filters_bar.dart';
import 'package:grc/core/components/app_bar/app_breadcrumbs.dart';
import 'package:grc/core/components/app_bar/grc_app_bar.dart';
import 'package:grc/core/components/layout/adaptive_page_container.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/core/components/query/query_async_body.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/utils/date_format_util.dart';
import 'package:grc/registrations/model/run_event_participant_model.dart';
import 'package:grc/registrations/run_event_participants_service.dart';

Duration? _noRetry(int count, Object error) => null;

class EventParticipantsScreen extends HookWidget {
  const EventParticipantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = useMemoized(() => Get.parameters['id']);
    final filters = useState(ParticipantListFilters.empty);

    final eventQuery = useQuery<RunEventModel?, Object>(
      QueryKeys.adminEvent(id ?? ''),
      (_) async {
        final routeId = id;
        if (routeId == null || routeId.isEmpty) return null;
        return RunEventsService.instance.getEventById(routeId);
      },
      enabled: id != null && id.isNotEmpty,
    );

    final queryKey = QueryKeys.eventParticipants(
      id ?? '',
      filters.value.toQueryKeyParts(),
    );

    final query = useInfiniteQuery<PaginatedRunEventParticipants, Object, int>(
      queryKey,
      (ctx) {
        final routeId = id;
        if (routeId == null || routeId.isEmpty) {
          throw Exception('Event id missing');
        }
        return RunEventParticipantsService.instance.listByEvent(
          routeId,
          page: ctx.pageParam,
          filters: filters.value,
        );
      },
      initialPageParam: 1,
      retry: _noRetry,
      enabled: id != null && id.isNotEmpty,
      nextPageParamBuilder: (data) {
        final last = data.pages.isNotEmpty ? data.pages.last : null;
        if (last == null || !last.hasMore) return null;
        return last.page + 1;
      },
    );

    final items =
        query.data?.pages.expand((p) => p.data).toList() ??
        const <RunEventParticipantModel>[];

    final title = eventQuery.data?.title ?? 'Event';

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: GrcAppBar(
        title: 'Participants · $title',
        breadcrumbs: id != null && id.isNotEmpty
            ? AppBreadcrumbs.adminEventChild(
                eventId: id,
                eventTitle: title,
                pageTitle: 'Participants',
              )
            : null,
      ),
      body: id == null || id.isEmpty
          ? const Center(child: Text('Event not found'))
          : QueryAsyncBody<RunEventModel?, dynamic>(
              state: eventQuery,
              onRetry: eventQuery.refetch,
              data: (_) => Column(
                children: [
                  ParticipantListFiltersBar(
                    filters: filters.value,
                    onChanged: (next) => filters.value = next,
                  ),
                  Expanded(child: _buildBody(context, query, items, filters.value)),
                ],
              ),
            ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    InfiniteQueryResult<PaginatedRunEventParticipants, Object, int> query,
    List<RunEventParticipantModel> items,
    ParticipantListFilters filters,
  ) {
    final emptyMessage = filters.hasActiveFilters
        ? 'No participants match your filters'
        : 'No participants yet';

    if (query.isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (query.isError && items.isEmpty) {
      return Center(
        child: Text(query.error?.toString() ?? 'Failed to load participants'),
      );
    }
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => query.refetch(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 120),
            Center(child: Text(emptyMessage)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => query.refetch(),
      child: AdaptivePageContainer(
        maxWidth: ParticipantListFiltersBar.listMaxWidth,
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
            padding: const EdgeInsets.all(
              ParticipantListFiltersBar.horizontalPadding,
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
              return _ParticipantTile(participant: items[index]);
            },
          ),
        ),
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final RunEventParticipantModel participant;

  const _ParticipantTile({required this.participant});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 1000;
    final name = participant.displayFullName;
    final contact = participant.displayContact;
    final avatar = participant.displayAvatar;
    final submitted = participant.submittedAt;
    final payment = participant.paymentStatus ?? '';

    return Material(
      color: const Color(AppColors.surface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(AppColors.divider)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          final id = participant.id;
          if (id == null) return;
          AppNavigation.toNamed(AppConstants.routes.registrationDetailPath(id));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(AppColors.background),
                      backgroundImage: avatar != null
                          ? NetworkImage(avatar)
                          : null,
                      child: avatar != null
                          ? null
                          : const Icon(
                              Icons.person_rounded,
                              color: Color(AppColors.textSecondary),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(AppColors.text),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        contact,
                        style: const TextStyle(
                          color: Color(AppColors.textSecondary),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        submitted != null
                            ? formatEventDateNumeric(submitted)
                            : '—',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(AppColors.textSecondary),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        alignment: WrapAlignment.end,
                        children: [
                          _chip(participant.status ?? 'submitted'),
                          if (payment.isNotEmpty) _chip(payment),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(AppColors.background),
                      backgroundImage: avatar != null
                          ? NetworkImage(avatar)
                          : null,
                      child: avatar != null
                          ? null
                          : const Icon(
                              Icons.person_rounded,
                              color: Color(AppColors.textSecondary),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(AppColors.text),
                            ),
                          ),
                          if (contact.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              contact,
                              style: const TextStyle(
                                color: Color(AppColors.textSecondary),
                              ),
                            ),
                          ],
                          if (submitted != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              formatEventDateNumeric(submitted),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(AppColors.textSecondary),
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _chip(participant.status ?? 'submitted'),
                              if (payment.isNotEmpty) _chip(payment),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(AppColors.background),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(AppColors.divider)),
      ),
      child: Text(
        label.replaceAll('_', ' ').capitalizeFirst ?? '',
        style: const TextStyle(
          fontSize: 12,
          color: Color(AppColors.textSecondary),
        ),
      ),
    );
  }
}
