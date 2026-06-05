import 'package:dart_mappable/dart_mappable.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/model/run_event_ref_field_instance.dart';

/// Decodes `runEventId` as an event id ([String]) or populated [RunEventModel].
class RunEventRefHook extends MappingHook {
  const RunEventRefHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value == null) return null;
    if (value is String) return RunEventRefFieldInstance(value);
    if (value is Map) {
      return RunEventRefFieldInstance(
        RunEventModelMapper.fromMap(Map<String, dynamic>.from(value)),
      );
    }
    return value;
  }

  @override
  Object? beforeEncode(Object? value) {
    if (value is! RunEventRefFieldInstance) return value;
    if (value.isIdOnly) return value.getId();
    final event = value.getModel();
    if (event != null) return event.toMap();
    return null;
  }
}
