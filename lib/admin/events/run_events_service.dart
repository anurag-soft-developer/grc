import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/core/config/api_constants.dart';
import 'package:grc/core/services/api_service.dart';

class RunEventsService {
  static final RunEventsService instance = RunEventsService._();
  RunEventsService._();

  final ApiService _api = ApiService();

  Future<PaginatedRunEvents> listEvents({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.runEvents.list,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
      },
    );
    if (response == null) {
      throw Exception('Failed to load events');
    }
    return PaginatedRunEvents.fromMap(response);
  }

  Future<RunEventModel?> createEvent(CreateRunEventInput input) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.runEvents.create,
      data: input.toJson(),
    );
    if (response == null) return null;
    return RunEventModel.fromMap(response);
  }

  Future<RunEventModel?> getEventById(String id) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConstants.runEvents.eventById(id),
    );
    if (response == null) return null;
    return RunEventModel.fromMap(response);
  }

  Future<RunEventModel?> updateEvent(
    String id,
    UpdateRunEventInput input,
  ) async {
    final response = await _api.patch<Map<String, dynamic>>(
      ApiConstants.runEvents.eventById(id),
      data: input.toJson(),
    );
    if (response == null) return null;
    return RunEventModel.fromMap(response);
  }

  Future<RunEventModel?> publishEvent(String id) async {
    final response = await _api.patch<Map<String, dynamic>>(
      ApiConstants.runEvents.publish(id),
    );
    if (response == null) return null;
    return RunEventModel.fromMap(response);
  }

  Future<RunEventModel?> closeEvent(String id) async {
    final response = await _api.patch<Map<String, dynamic>>(
      ApiConstants.runEvents.close(id),
    );
    if (response == null) return null;
    return RunEventModel.fromMap(response);
  }
}
