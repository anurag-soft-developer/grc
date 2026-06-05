import 'package:grc/admin/events/model/run_event_model.dart';

/// Lean event id ([String]) or populated [RunEventModel] (e.g. participant `runEventId`).
class RunEventRefFieldInstance {
  final dynamic _runEvent;

  const RunEventRefFieldInstance(this._runEvent);

  String? getId() {
    if (_runEvent is String) return _runEvent;
    if (_runEvent is RunEventModel) return _runEvent.id;
    return null;
  }

  RunEventModel? getModel() {
    if (_runEvent is RunEventModel) return _runEvent;
    return null;
  }

  String? getTitle() {
    if (_runEvent is RunEventModel) return _runEvent.title;
    return null;
  }

  String getDisplayTitle() {
    final title = getTitle();
    if (title != null) return title;
    final id = getId();
    return id != null ? 'Event $id' : 'Unknown event';
  }

  bool get isPopulated => _runEvent is RunEventModel;

  bool get isIdOnly => _runEvent is String;
}
