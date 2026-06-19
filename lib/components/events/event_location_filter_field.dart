import 'package:flutter/material.dart';
import 'package:grc/components/events/event_list_filters.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/core/config/preset_cities.dart';

class EventLocationFilterField extends StatelessWidget {
  final EventListFilters filters;
  final ValueChanged<EventListFilters> onChanged;

  const EventLocationFilterField({
    super.key,
    required this.filters,
    required this.onChanged,
  });

  bool get _hasSelection => filters.locationMode != EventLocationFilterMode.all;

  Future<void> _openOptions(BuildContext context) async {
    final box = context.findRenderObject()! as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + box.size.height,
      offset.dx + box.size.width,
      offset.dy,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      items: [
        for (final city in presetFilterCities)
          PopupMenuItem(value: city, child: Text(city)),
      ],
    );

    if (selected == null) return;

    onChanged(filters.withCity(city: selected, label: selected));
  }

  @override
  Widget build(BuildContext context) {
    return CompactFilterField(
      fieldLabel: 'City',
      icon: Icons.location_on_outlined,
      label: filters.locationDisplayLabel,
      hasSelection: _hasSelection,
      onTap: () => _openOptions(context),
      onClear: () => onChanged(filters.withLocationAll()),
    );
  }
}

class CompactFilterField extends StatelessWidget {
  final String? fieldLabel;
  final IconData icon;
  final String label;
  final bool hasSelection;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  static const _height = 40.0;

  const CompactFilterField({
    super.key,
    this.fieldLabel,
    required this.icon,
    required this.label,
    required this.hasSelection,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final field = SizedBox(
      height: _height,
      child: Material(
        color: const Color(AppColors.background),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(AppColors.divider)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: const Color(AppColors.textSecondary),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.2,
                      color: Color(
                        hasSelection ? AppColors.text : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: hasSelection && onClear != null
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: onClear,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (fieldLabel == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          fieldLabel!,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 4),
        field,
      ],
    );
  }
}
