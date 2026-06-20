import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';

class EventFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final priceController = TextEditingController();
  final maxParticipantsController = TextEditingController();

  final Rx<DateTime?> eventDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> reportingTime = Rx<TimeOfDay?>(null);
  final RxList<String> coverImageUrls = <String>[].obs;

  final RxString city = ''.obs;
  final RxString state = ''.obs;
  final RxString address = ''.obs;
  final Rx<double?> lat = Rx<double?>(null);
  final Rx<double?> long = Rx<double?>(null);

  String? editingEventId;

  bool get isEditing => editingEventId != null && editingEventId!.isNotEmpty;

  bool get hasLocation =>
      city.value.trim().isNotEmpty &&
      state.value.trim().isNotEmpty &&
      address.value.trim().isNotEmpty;

  String get reportingTimeLabel {
    final time = reportingTime.value;
    if (time == null) return 'Tap to select';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String? get reportingTimeValue {
    final time = reportingTime.value;
    if (time == null) return null;
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void loadFromEvent(RunEventModel event) {
    editingEventId = event.id;
    titleController.text = event.title;
    descriptionController.text = event.description;
    priceController.text = event.price?.toString() ?? '';
    maxParticipantsController.text = event.maxParticipants?.toString() ?? '';

    if (event.eventDate != null && event.eventDate!.isNotEmpty) {
      eventDate.value = DateTime.parse(event.eventDate!).toLocal();
    } else {
      eventDate.value = null;
    }

    reportingTime.value = _parseReportingTime(event.reportingTime);

    final loc = event.location;
    if (loc != null &&
        loc.address.isNotEmpty &&
        loc.city.isNotEmpty &&
        loc.state.isNotEmpty) {
      setLocation(
        address: loc.address,
        city: loc.city,
        state: loc.state,
        latitude: loc.lat,
        longitude: loc.long,
      );
    } else {
      clearLocation();
    }

    coverImageUrls
      ..clear()
      ..addAll(event.coverImages);
  }

  void resetForCreate() {
    editingEventId = null;
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    cityController.clear();
    stateController.clear();
    priceController.clear();
    maxParticipantsController.clear();
    eventDate.value = null;
    reportingTime.value = null;
    clearLocation();
    coverImageUrls.clear();
  }

  void setLocation({
    required String address,
    required String city,
    required String state,
    double? latitude,
    double? longitude,
  }) {
    _assignControllerText(locationController, address);
    _assignControllerText(cityController, city);
    _assignControllerText(stateController, state);
    syncLocationFromInput(
      address: address,
      city: city,
      state: state,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Updates reactive location values only — does not touch text controllers.
  /// Use while the user is typing so the cursor is not reset.
  void syncLocationFromInput({
    required String address,
    required String city,
    required String state,
    double? latitude,
    double? longitude,
  }) {
    this.address.value = address;
    this.city.value = city;
    this.state.value = state;
    lat.value = latitude;
    long.value = longitude;
  }

  static void _assignControllerText(
    TextEditingController controller,
    String text,
  ) {
    if (controller.text == text) return;
    controller.value = controller.value.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
      composing: TextRange.empty,
    );
  }

  void clearLocation() {
    locationController.clear();
    cityController.clear();
    stateController.clear();
    city.value = '';
    state.value = '';
    address.value = '';
    lat.value = null;
    long.value = null;
  }

  static TimeOfDay? _parseReportingTime(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final match = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
      caseSensitive: false,
    ).firstMatch(value.trim());
    if (match == null) return null;

    var hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final isPm = match.group(3)!.toUpperCase() == 'PM';

    if (hour == 12) {
      hour = isPm ? 12 : 0;
    } else if (isPm) {
      hour += 12;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    cityController.dispose();
    stateController.dispose();
    priceController.dispose();
    maxParticipantsController.dispose();
    super.onClose();
  }
}
