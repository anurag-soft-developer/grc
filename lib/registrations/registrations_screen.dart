import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/core/config/app_colors.dart';
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
      return Center(
        child: Text(
          query.error?.toString() ?? 'Failed to load registrations',
        ),
      );
    }
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => query.refetch(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: Text('No registrations yet')),
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
            return _RegistrationTile(participant: items[index]);
          },
        ),
      ),
    );
  }
}

class _RegistrationTile extends StatelessWidget {
  final RunEventParticipantModel participant;

  const _RegistrationTile({required this.participant});

  @override
  Widget build(BuildContext context) {
    final event = participant.runEventModel;
    final title = event?.title ?? 'Event';
    final date = event?.eventDate;
    final status = participant.status ?? '';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              if (date != null) ...[
                const SizedBox(height: 4),
                Text(
                  _formatDate(date),
                  style: const TextStyle(color: Color(AppColors.textSecondary)),
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _chip(status),
                  if (payment.isNotEmpty) _chip(payment),
                  if (participant.totalAmount != null)
                    _chip('₹${participant.totalAmount!.toStringAsFixed(0)}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return iso;
    }
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(AppColors.background),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.replaceAll('_', ' '),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
