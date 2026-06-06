import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/utils/date_format_util.dart';
import 'package:grc/registrations/model/run_event_participant_model.dart';
import 'package:grc/registrations/run_event_participants_service.dart';

Duration? _noRetry(int count, Object error) => null;

class EventParticipantsScreen extends HookWidget {
  const EventParticipantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final event = Get.arguments as RunEventModel?;
    final eventId = event?.id;

    final query = useInfiniteQuery<PaginatedRunEventParticipants, Object, int>(
      QueryKeys.eventParticipants(eventId ?? ''),
      (ctx) {
        final id = eventId;
        if (id == null || id.isEmpty) {
          throw Exception('Event id missing');
        }
        return RunEventParticipantsService.instance.listByEvent(
          id,
          page: ctx.pageParam,
        );
      },
      initialPageParam: 1,
      retry: _noRetry,
      enabled: eventId != null && eventId.isNotEmpty,
      nextPageParamBuilder: (data) {
        final last = data.pages.isNotEmpty ? data.pages.last : null;
        if (last == null || !last.hasMore) return null;
        return last.page + 1;
      },
    );

    final items =
        query.data?.pages.expand((p) => p.data).toList() ??
        const <RunEventParticipantModel>[];

    final title = event?.title ?? 'Event';

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(title: Text('Participants · $title')),
      body: eventId == null
          ? const Center(child: Text('Event not found'))
          : _buildBody(context, query, items),
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
      return Center(
        child: Text(query.error?.toString() ?? 'Failed to load participants'),
      );
    }
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => query.refetch(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: Text('No participants yet')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => query.refetch(),
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
          padding: const EdgeInsets.all(16),
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
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final RunEventParticipantModel participant;

  const _ParticipantTile({required this.participant});

  @override
  Widget build(BuildContext context) {
    final name = participant.displayFullName;
    final contact = participant.displayContact;
    final avatar = participant.displayAvatar;
    final submitted = participant.submittedAt;
    final payment = participant.paymentStatus ?? '';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          final id = participant.id;
          if (id == null) return;
          Get.toNamed(AppConstants.routes.registrationDetail, arguments: id);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(AppColors.background),
                backgroundImage: avatar != null ? NetworkImage(avatar) : null,
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
      ),
      child: Text(
        label.replaceAll('_', ' ').capitalizeFirst ?? '',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
