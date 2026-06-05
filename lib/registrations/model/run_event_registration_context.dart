import 'package:grc/admin/events/model/run_event_model.dart';

class RunEventRegistrationContext {
  final RunEventModel event;

  const RunEventRegistrationContext({
    required this.event,
  });

  static RunEventRegistrationContext fromApiMap(Map<String, dynamic> map) {
    final eventRaw = map['event'];
    return RunEventRegistrationContext(
      event: eventRaw is Map
          ? RunEventModel.fromMap(Map<String, dynamic>.from(eventRaw))
          : const RunEventModel(title: ''),
    );
  }
}
