import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:get/get.dart';
import 'package:grc/admin/events/model/run_event_model.dart';
import 'package:grc/admin/events/questionnaires/event_question_draft.dart';
import 'package:grc/admin/events/questionnaires/form_builder_controller.dart';
import 'package:grc/components/shared/custom_button.dart';
import 'package:grc/core/components/query/mutation_loading_overlay.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/core/config/constants.dart';
import 'package:grc/core/query/query_keys.dart';
import 'package:grc/core/utils/exception_handler.dart';
import 'package:grc/registrations/model/custom_question_type.dart';

class FormBuilderScreen extends HookWidget {
  const FormBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormBuilderController>();
    final client = useQueryClient();
    final theme = Theme.of(context);

    useEffect(() {
      controller.initFromArguments();
      return () {
        if (Get.isRegistered<FormBuilderController>()) {
          Get.delete<FormBuilderController>(force: true);
        }
      };
    }, const []);

    final saveMutation = useMutation<RunEventModel?, Object, void, void>(
      (_, __) async {
        final validationError = controller.validateAll();
        if (validationError != null) {
          ExceptionHandler.showErrorToast(validationError);
          throw Exception(validationError);
        }
        final updated = await controller.save();
        if (updated == null) {
          throw Exception('Failed to save questionnaires');
        }
        return updated;
      },
      mutationKey: QueryKeys.updateEventCustomQuestions,
      onSuccess: (result, _, __, ___) async {
        await client.invalidateQueries(queryKey: QueryKeys.adminEvents);
        if (result?.id != null) {
          await client.invalidateQueries(
            queryKey: QueryKeys.adminEvent(result!.id!),
          );
        }
        ExceptionHandler.showSuccessToast('Questionnaires saved');
        Get.back(result: result);
      },
    );

    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: const Color(AppColors.surface),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.event.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Text(
              'Form builder',
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
      body: MutationLoadingOverlay(
        mutationKey: QueryKeys.updateEventCustomQuestions,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.drafts.isEmpty) {
                  return _EmptyQuestionsState(onAdd: controller.addQuestion);
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  itemCount: controller.drafts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => _QuestionCard(
                    index: index,
                    draft: controller.drafts[index],
                    controller: controller,
                  ),
                );
              }),
            ),
            _BottomActionBar(
              isSaving: saveMutation.isPending,
              onAdd: controller.addQuestion,
              onSave: () => saveMutation.mutate(null),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyQuestionsState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyQuestionsState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 48,
              color: const Color(AppColors.primary).withValues(alpha: 0.35),
            ),
            const SizedBox(height: 12),
            const Text(
              'No questions yet',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(AppColors.text),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Add fields participants fill during registration.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add question'),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onAdd;
  final VoidCallback onSave;

  const _BottomActionBar({
    required this.isSaving,
    required this.onAdd,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: const Color(AppColors.surface),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: isSaving ? null : onAdd,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: 'Save',
                  isLoading: isSaving,
                  onPressed: isSaving ? null : onSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shared compact field styling for this screen only.
class _CompactField {
  static const contentPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 8,
  );
  static const borderRadius = BorderRadius.all(Radius.circular(8));

  static InputDecoration decoration({String? hintText}) {
    final border = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: const BorderSide(color: Color(AppColors.divider)),
    );
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 13,
        color: Color(AppColors.textSecondary),
      ),
      contentPadding: contentPadding,
      filled: true,
      fillColor: const Color(AppColors.background),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(
          color: Color(AppColors.primary),
          width: 1.5,
        ),
      ),
    );
  }

  static TextStyle get inputStyle => const TextStyle(fontSize: 14, height: 1.2);
}

class _CompactTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int minLines;
  final int maxLines;

  const _CompactTextField({
    required this.controller,
    this.hintText,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: _CompactField.inputStyle,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: maxLines > 1 ? TextInputType.multiline : TextInputType.text,
      decoration: _CompactField.decoration(hintText: hintText),
    );
  }
}

class _QuestionOptionsEditor extends StatelessWidget {
  final EventQuestionDraft draft;
  final FormBuilderController controller;

  const _QuestionOptionsEditor({required this.draft, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(AppColors.background),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'Options',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(AppColors.textSecondary),
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  draft.addOption();
                  controller.drafts.refresh();
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          for (var i = 0; i < draft.optionControllers.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 6),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(
                        AppColors.divider,
                      ).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _CompactTextField(
                      controller: draft.optionControllers[i],
                      hintText: 'Option value',
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    tooltip: 'Remove option',
                    onPressed: () {
                      draft.removeOption(i);
                      controller.drafts.refresh();
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: Color(AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RequiredCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _RequiredCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: value,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                side: const BorderSide(
                  color: Color(AppColors.divider),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (v) => onChanged(v ?? false),
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Required',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(AppColors.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final int index;
  final EventQuestionDraft draft;
  final FormBuilderController controller;

  const _QuestionCard({
    required this.index,
    required this.draft,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(AppColors.surface),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 6, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(
                      AppColors.primary,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _CompactTextField(
                    controller: draft.labelController,
                    hintText: 'Question label',
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  tooltip: 'Remove question',
                  onPressed: () => controller.removeQuestion(index),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Color(AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'TYPE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(AppColors.textSecondary),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: CustomQuestionType.values.map((type) {
                final selected = draft.type == type;
                return FilterChip(
                  label: Text(
                    type.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  selected: selected,
                  showCheckmark: false,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                  side: BorderSide(
                    color: selected
                        ? const Color(AppColors.primary)
                        : const Color(AppColors.divider),
                  ),
                  selectedColor: const Color(
                    AppColors.primary,
                  ).withValues(alpha: 0.12),
                  onSelected: (_) {
                    draft.onTypeChanged(type);
                    controller.drafts.refresh();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 6),
            _RequiredCheckbox(
              value: draft.required,
              onChanged: (v) {
                draft.required = v;
                controller.drafts.refresh();
              },
            ),
            if (draft.type.needsOptions) ...[
              const SizedBox(height: 10),
              _QuestionOptionsEditor(draft: draft, controller: controller),
            ],
          ],
        ),
      ),
    );
  }
}
