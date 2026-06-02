import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/run_events_service.dart';
import 'package:grc/admin/form/event_form_controller.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/components/shared/custom_text_field.dart';
import 'package:grc/components/shared/location_autocomplete_field.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/models/media_upload_models.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/services/media_upload_service.dart';
import 'package:grc/core/utils/exception_handler.dart';
import 'package:image_picker/image_picker.dart';

/// Pass as [Get.arguments] when opening the form to create a new event.
const eventFormCreate = Object();

class EventFormScreen extends HookWidget {
  const EventFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventFormController>();
    final client = useQueryClient();
    final isUploadingCover = useState(false);

    useEffect(() {
      final args = Get.arguments;
      if (args is RunEventModel) {
        controller.loadFromEvent(args);
      } else {
        controller.resetForCreate();
      }
      return () {
        if (Get.isRegistered<EventFormController>()) {
          Get.delete<EventFormController>(force: true);
        }
      };
    }, const []);

    Future<RunEventModel> buildInputAndSubmit() async {
      if (!controller.formKey.currentState!.validate()) {
        throw Exception('Validation failed');
      }
      final date = controller.eventDate.value!;
      final reportingTime = controller.reportingTimeValue!;

      final price = double.tryParse(controller.priceController.text.trim());
      final maxParticipants = int.tryParse(
        controller.maxParticipantsController.text.trim(),
      );

      if (price == null || maxParticipants == null) {
        throw Exception('Invalid numeric fields');
      }

      if (controller.isEditing) {
        final input = UpdateRunEventInput(
          title: controller.titleController.text.trim(),
          description: controller.descriptionController.text.trim(),
          eventDate: date,
          reportingTime: reportingTime,
          lat: controller.lat.value!,
          long: controller.long.value!,
          city: controller.city.value,
          state: controller.state.value,
          address: controller.address.value,
          price: price,
          maxParticipants: maxParticipants,
          coverImages: controller.coverImageUrls.toList(),
        );
        final updated = await RunEventsService.instance.updateEvent(
          controller.editingEventId!,
          input,
        );
        if (updated == null) {
          throw Exception('Failed to update event');
        }
        return updated;
      }

      final input = CreateRunEventInput(
        title: controller.titleController.text.trim(),
        description: controller.descriptionController.text.trim(),
        eventDate: date,
        reportingTime: reportingTime,
        lat: controller.lat.value!,
        long: controller.long.value!,
        city: controller.city.value,
        state: controller.state.value,
        address: controller.address.value,
        price: price,
        maxParticipants: maxParticipants,
        coverImages: controller.coverImageUrls.toList(),
      );

      final created = await RunEventsService.instance.createEvent(input);
      if (created == null) {
        throw Exception('Failed to create event');
      }
      return created;
    }

    final createMutation = useMutation<RunEventModel?, Object, void, void>(
      (_, __) => buildInputAndSubmit(),
      mutationKey: QueryKeys.createEvent,
      onSuccess: (result, _, __, ___) async {
        await client.invalidateQueries(queryKey: QueryKeys.adminEvents);
        ExceptionHandler.showSuccessToast('Event created as draft');
        Get.back();
      },
    );

    final updateMutation = useMutation<RunEventModel?, Object, void, void>(
      (_, __) => buildInputAndSubmit(),
      mutationKey: QueryKeys.updateEvent,
      onSuccess: (result, _, __, ___) async {
        await client.invalidateQueries(queryKey: QueryKeys.adminEvents);
        if (result?.id != null) {
          await client.invalidateQueries(
            queryKey: QueryKeys.adminEvent(result!.id!),
          );
        }
        ExceptionHandler.showSuccessToast('Event updated');
        Get.back(result: result);
      },
    );

    final isEditing = controller.isEditing;
    final submitMutation = isEditing ? updateMutation : createMutation;
    final mutationKey = isEditing
        ? QueryKeys.updateEvent
        : QueryKeys.createEvent;

    Future<void> pickCoverImage() async {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;

      isUploadingCover.value = true;
      try {
        final ref = await MediaUploadService.instance.uploadLocalFile(
          file: File(file.path),
          purpose: MediaUploadPurpose.runEventMedia,
          onProgress: (_) {},
        );
        if (ref != null) {
          controller.coverImageUrls.add(ref.fileUrl);
        }
      } finally {
        isUploadingCover.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Event' : 'Add Event')),
      body: MutationLoadingOverlay(
        mutationKey: mutationKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: controller.titleController,
                  labelText: 'Title',
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller.descriptionController,
                  labelText: 'Description',
                  maxLines: 4,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                FormField<void>(
                  validator: (_) =>
                      controller.eventDate.value == null ? 'Required' : null,
                  builder: (field) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Event date'),
                          subtitle: Text(
                            controller.eventDate.value != null
                                ? controller.eventDate.value!
                                      .toLocal()
                                      .toString()
                                      .split(' ')
                                      .first
                                : 'Tap to select',
                          ),
                          trailing: const Icon(Icons.calendar_today_outlined),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: controller.eventDate.value ??
                                  DateTime.now().add(
                                    const Duration(days: 7),
                                  ),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365 * 2),
                              ),
                            );
                            if (picked != null) {
                              controller.eventDate.value = picked;
                              field.didChange(null);
                            }
                          },
                        ),
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 12),
                          child: Text(
                            field.errorText!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FormField<void>(
                  validator: (_) => controller.reportingTime.value == null
                      ? 'Required'
                      : null,
                  builder: (field) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Reporting time'),
                          subtitle: Text(controller.reportingTimeLabel),
                          trailing:
                              const Icon(Icons.access_time_outlined),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: controller.reportingTime.value ??
                                  TimeOfDay.now(),
                            );
                            if (picked != null) {
                              controller.reportingTime.value = picked;
                              field.didChange(null);
                            }
                          },
                        ),
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 12),
                          child: Text(
                            field.errorText!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FormField<void>(
                  validator: (_) =>
                      controller.hasLocation ? null : 'Select a location',
                  builder: (field) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LocationAutocompleteField(
                        controller: controller.locationController,
                        labelText: 'Location',
                        hintText: 'Search venue or address…',
                        onLocationSelected:
                            ({
                              required address,
                              required city,
                              required state,
                              required latitude,
                              required longitude,
                            }) {
                              controller.setLocation(
                                address: address,
                                city: city,
                                state: state,
                                latitude: latitude,
                                longitude: longitude,
                              );
                              field.didChange(null);
                            },
                      ),
                      Obx(() {
                        if (!controller.hasLocation) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${controller.city.value}, ${controller.state.value}',
                            style: const TextStyle(
                              color: Color(AppColors.textSecondary),
                              fontSize: 13,
                            ),
                          ),
                        );
                      }),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 12),
                          child: Text(
                            field.errorText!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller.priceController,
                  labelText: 'Price (INR)',
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || double.tryParse(v.trim()) == null
                      ? 'Invalid price'
                      : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller.maxParticipantsController,
                  labelText: 'Max participants',
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || int.tryParse(v.trim()) == null
                      ? 'Invalid number'
                      : null,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: isUploadingCover.value ? null : pickCoverImage,
                  icon: isUploadingCover.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.image_outlined),
                  label: Text(
                    isUploadingCover.value
                        ? 'Uploading…'
                        : 'Add cover image (optional)',
                  ),
                ),
                Obx(() {
                  if (controller.coverImageUrls.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SizedBox(
                      height: 108,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.coverImageUrls.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final url = controller.coverImageUrls[index];
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  url,
                                  width: 108,
                                  height: 108,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 108,
                                    height: 108,
                                    color: const Color(AppColors.divider),
                                    child: const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -6,
                                right: -6,
                                child: Material(
                                  color: Colors.black54,
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () => controller.coverImageUrls
                                        .removeAt(index),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                CustomButton(
                  text: isEditing ? 'Save changes' : 'Create event',
                  isLoading: submitMutation.isPending,
                  onPressed: submitMutation.isPending
                      ? null
                      : () => submitMutation.mutate(null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
