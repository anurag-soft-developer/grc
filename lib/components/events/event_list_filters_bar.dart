import 'package:flutter/material.dart';
import 'package:grc/components/events/event_list_filters.dart';
import 'package:grc/components/events/event_location_filter_field.dart';
import 'package:grc/components/events/event_segment_filter_field.dart';
import 'package:grc/core/config/app_colors.dart';

class EventListFiltersBar extends StatelessWidget {
  final EventListFilters filters;
  final ValueChanged<EventListFilters> onChanged;

  static const filterWidth = 160.0;
  static const listMaxWidth = 980.0;
  static const horizontalPadding = 16.0;

  const EventListFiltersBar({
    super.key,
    required this.filters,
    required this.onChanged,
  });

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: filters.eventDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onChanged(filters.withDate(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(AppColors.surface),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          horizontalPadding,
          8,
          horizontalPadding,
          8,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: listMaxWidth),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: filterWidth,
                    child: EventSegmentFilterField(
                      filters: filters,
                      onChanged: onChanged,
                    ),
                  ),
                  SizedBox(
                    width: filterWidth,
                    child: CompactFilterField(
                      fieldLabel: 'Date',
                      icon: Icons.calendar_today_outlined,
                      label: filters.dateLabel,
                      hasSelection: filters.eventDate != null,
                      onTap: () => _pickDate(context),
                      onClear: () => onChanged(filters.withDate(null)),
                    ),
                  ),
                  SizedBox(
                    width: filterWidth,
                    child: EventLocationFilterField(
                      filters: filters,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
