import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grc/admin/events/participant_list_filters.dart';
import 'package:grc/components/events/event_location_filter_field.dart';
import 'package:grc/core/config/app_colors.dart';

class ParticipantListFiltersBar extends HookWidget {
  final ParticipantListFilters filters;
  final ValueChanged<ParticipantListFilters> onChanged;

  static const filterWidth = 160.0;
  static const listMaxWidth = 1120.0;
  static const horizontalPadding = 16.0;
  static const _debounceDuration = Duration(milliseconds: 500);

  const ParticipantListFiltersBar({
    super.key,
    required this.filters,
    required this.onChanged,
  });

  Future<void> _pickSubmittedDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: filters.submittedAt ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onChanged(filters.withSubmittedAt(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);
    final searchController = useTextEditingController(text: filters.search ?? '');
    final debounceTimer = useRef<Timer?>(null);

    useEffect(() {
      final external = filters.search ?? '';
      if (searchController.text != external) {
        searchController.text = external;
      }
      return null;
    }, [filters.search]);

    useEffect(() {
      return () => debounceTimer.value?.cancel();
    }, const []);

    void onSearchChanged(String value) {
      debounceTimer.value?.cancel();
      debounceTimer.value = Timer(_debounceDuration, () {
        onChanged(filters.withSearch(value));
      });
    }

    Widget filtersContent() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Name, email, phone, booking ID…',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: Color(AppColors.textSecondary),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 18,
                        color: Color(AppColors.textSecondary),
                      ),
                      suffixIcon: filters.search?.trim().isNotEmpty == true
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: () {
                                searchController.clear();
                                onChanged(filters.withSearch(null));
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(AppColors.background),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(AppColors.divider),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(AppColors.divider),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: filterWidth,
            child: _PaymentStatusFilterField(
              filters: filters,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: filterWidth,
            child: CompactFilterField(
              fieldLabel: 'Submitted',
              icon: Icons.calendar_today_outlined,
              label: filters.submittedAtLabel,
              hasSelection: filters.submittedAt != null,
              onTap: () => _pickSubmittedDate(context),
              onClear: () => onChanged(filters.withSubmittedAt(null)),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        horizontalPadding,
        8,
        horizontalPadding,
        8,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: listMaxWidth),
          child: Material(
            color: const Color(AppColors.surface),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(AppColors.divider)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => isExpanded.value = !isExpanded.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(AppColors.text),
                          ),
                        ),
                        if (filters.hasActiveFilters) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(AppColors.primary),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Icon(
                          isExpanded.value
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: const Color(AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: isExpanded.value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(AppColors.divider),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                        child: filtersContent(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentStatusFilterField extends StatelessWidget {
  final ParticipantListFilters filters;
  final ValueChanged<ParticipantListFilters> onChanged;

  const _PaymentStatusFilterField({
    required this.filters,
    required this.onChanged,
  });

  bool get _hasSelection =>
      filters.paymentStatus != ParticipantPaymentStatusFilter.all;

  Future<void> _openOptions(BuildContext context) async {
    final box = context.findRenderObject()! as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + box.size.height,
      offset.dx + box.size.width,
      offset.dy,
    );

    final selected = await showMenu<ParticipantPaymentStatusFilter>(
      context: context,
      position: position,
      items: const [
        PopupMenuItem(
          value: ParticipantPaymentStatusFilter.pending,
          child: Text('Pending'),
        ),
        PopupMenuItem(
          value: ParticipantPaymentStatusFilter.paid,
          child: Text('Paid'),
        ),
        PopupMenuItem(
          value: ParticipantPaymentStatusFilter.failed,
          child: Text('Failed'),
        ),
        PopupMenuItem(
          value: ParticipantPaymentStatusFilter.refunded,
          child: Text('Refunded'),
        ),
      ],
    );

    if (selected == null) return;
    onChanged(filters.withPaymentStatus(selected));
  }

  @override
  Widget build(BuildContext context) {
    return CompactFilterField(
      fieldLabel: 'Payment',
      icon: Icons.payments_outlined,
      label: filters.paymentStatusLabel,
      hasSelection: _hasSelection,
      onTap: () => _openOptions(context),
      onClear: () =>
          onChanged(filters.withPaymentStatus(ParticipantPaymentStatusFilter.all)),
    );
  }
}
