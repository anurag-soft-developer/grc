import 'package:flutter/material.dart';
import 'package:grc/components/events/event_list_filters.dart';
import 'package:grc/components/events/event_location_filter_field.dart';

class EventSegmentFilterField extends StatelessWidget {
  final EventListFilters filters;
  final ValueChanged<EventListFilters> onChanged;

  const EventSegmentFilterField({
    super.key,
    required this.filters,
    required this.onChanged,
  });

  bool get _hasSelection => filters.segmentMode != EventSegmentFilterMode.all;

  Future<void> _openOptions(BuildContext context) async {
    final box = context.findRenderObject()! as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + box.size.height,
      offset.dx + box.size.width,
      offset.dy,
    );

    final selected = await showMenu<EventSegmentFilterMode>(
      context: context,
      position: position,
      items: const [
        PopupMenuItem(
          value: EventSegmentFilterMode.upcoming,
          child: Text('Upcoming'),
        ),
        PopupMenuItem(
          value: EventSegmentFilterMode.closed,
          child: Text('Closed'),
        ),
      ],
    );

    if (selected == null) return;

    onChanged(filters.withSegment(selected));
  }

  @override
  Widget build(BuildContext context) {
    return CompactFilterField(
      fieldLabel: 'Status',
      icon: Icons.event_outlined,
      label: filters.segmentDisplayLabel,
      hasSelection: _hasSelection,
      onTap: () => _openOptions(context),
      onClear: () => onChanged(filters.withSegmentAll()),
    );
  }
}
