import 'package:flutter/material.dart';
import 'package:grc/core/config/app_colors.dart';
import 'package:grc/registrations/model/custom_question_model.dart';
import 'package:grc/registrations/model/custom_question_type.dart';

List<String> _asStringList(List<String> raw) {
  return List<String>.from(raw.map((e) => e.toString()));
}

List<String> _selectedStringList(dynamic value) {
  if (value is! List) return const [];
  return List<String>.from(value.map((e) => e.toString()));
}

dynamic _normalizeAnswer(CustomQuestionType type, dynamic value) {
  if (type == CustomQuestionType.checkbox && value is List) {
    return _selectedStringList(value);
  }
  return value;
}

/// Renders [CustomQuestionModel] fields for registration or admin preview.
class FormRenderer extends StatelessWidget {
  final List<CustomQuestionModel> questions;
  final Map<String, dynamic> answers;
  final Map<String, String>? fieldErrors;
  final void Function(String key, dynamic value)? onAnswerChanged;
  final bool readOnly;
  final String? sectionTitle;
  final String? sectionSubtitle;

  const FormRenderer({
    super.key,
    required this.questions,
    required this.answers,
    this.fieldErrors,
    this.onAnswerChanged,
    this.readOnly = false,
    this.sectionTitle,
    this.sectionSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return const SizedBox.shrink();

    final sorted = List<CustomQuestionModel>.from(questions)
      ..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (sectionTitle != null) ...[
          Text(
            sectionTitle!,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(AppColors.text),
              letterSpacing: -0.2,
            ),
          ),
          if (sectionSubtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              sectionSubtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(AppColors.textSecondary),
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 10),
        ],
        ...sorted.asMap().entries.map(
          (e) => Padding(
            padding: EdgeInsets.only(bottom: e.key < sorted.length - 1 ? 8 : 0),
            child: _QuestionField(
              question: e.value,
              index: e.key,
              value: answers[e.value.key],
              errorText: fieldErrors?[e.value.key],
              readOnly: readOnly,
              onChanged: readOnly
                  ? null
                  : (v) {
                      final normalized = _normalizeAnswer(e.value.type, v);
                      answers[e.value.key] = normalized;
                      onAnswerChanged?.call(e.value.key, normalized);
                    },
            ),
          ),
        ),
      ],
    );
  }
}

class _FormStyles {
  static const fieldRadius = BorderRadius.all(Radius.circular(8));
  static const contentPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 8,
  );
  static const inputStyle = TextStyle(
    fontSize: 14,
    height: 1.25,
    color: Color(AppColors.text),
  );

  static const optionStyle = TextStyle(
    fontSize: 14,
    color: Color(AppColors.text),
  );

  static InputDecoration decoration({String? hintText, String? errorText}) {
    final border = OutlineInputBorder(
      borderRadius: fieldRadius,
      borderSide: const BorderSide(color: Color(AppColors.divider)),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: fieldRadius,
      borderSide: const BorderSide(color: Color(AppColors.error)),
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
      disabledBorder: border,
      errorText: errorText,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      errorStyle: const TextStyle(
        fontSize: 12,
        color: Color(AppColors.error),
        height: 1.3,
      ),
    );
  }
}

class _QuestionField extends StatelessWidget {
  final CustomQuestionModel question;
  final int index;
  final dynamic value;
  final String? errorText;
  final bool readOnly;
  final ValueChanged<dynamic>? onChanged;

  const _QuestionField({
    required this.question,
    required this.index,
    required this.value,
    this.errorText,
    required this.readOnly,
    this.onChanged,
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
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _IndexBadge(number: index + 1),
                const SizedBox(width: 8),
                Expanded(child: _FieldLabel(question: question)),
              ],
            ),
            const SizedBox(height: 8),
            _buildControl(context),
            if (_showsExternalError) ...[
              const SizedBox(height: 6),
              Text(
                errorText!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(AppColors.error),
                  height: 1.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool get _showsExternalError =>
      errorText != null &&
      (question.type == CustomQuestionType.radio ||
          question.type == CustomQuestionType.checkbox);

  List<String> get _options => _asStringList(question.options);

  Widget _buildControl(BuildContext context) {
    switch (question.type) {
      case CustomQuestionType.text:
        return TextFormField(
          initialValue: value?.toString() ?? '',
          readOnly: readOnly,
          style: _FormStyles.inputStyle,
          decoration: _FormStyles.decoration(
            hintText: 'Your answer',
            errorText: errorText,
          ),
          onChanged: onChanged == null ? null : (v) => onChanged!(v),
        );
      case CustomQuestionType.textarea:
        return TextFormField(
          initialValue: value?.toString() ?? '',
          readOnly: readOnly,
          minLines: 2,
          maxLines: 4,
          style: _FormStyles.inputStyle,
          keyboardType: TextInputType.multiline,
          decoration: _FormStyles.decoration(
            hintText: 'Type here...',
            errorText: errorText,
          ),
          onChanged: onChanged == null ? null : (v) => onChanged!(v),
        );
      case CustomQuestionType.select:
        return Theme(
          data: Theme.of(context).copyWith(
            canvasColor: const Color(AppColors.surface),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              surface: const Color(AppColors.surface),
              onSurface: const Color(AppColors.text),
            ),
          ),
          child: DropdownButtonFormField<String>(
            isDense: true,
            isExpanded: true,
            initialValue: value is String && _options.contains(value)
                ? value
                : null,
            hint: const Text(
              'Select an option',
              style: TextStyle(
                fontSize: 13,
                color: Color(AppColors.textSecondary),
              ),
            ),
            style: _FormStyles.inputStyle,
            dropdownColor: const Color(AppColors.surface),
            iconEnabledColor: const Color(AppColors.textSecondary),
            iconDisabledColor: const Color(AppColors.textSecondary),
            decoration: _FormStyles.decoration(errorText: errorText),
            items: _options
                .map(
                  (o) => DropdownMenuItem(
                    value: o,
                    child: Text(
                      o,
                      style: _FormStyles.optionStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            selectedItemBuilder: (context) => _options
                .map(
                  (o) => Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      o,
                      style: _FormStyles.inputStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: readOnly || onChanged == null
                ? null
                : (v) {
                    if (v != null) onChanged!(v);
                  },
          ),
        );
      case CustomQuestionType.radio:
        return _OptionTiles(
          options: _options,
          selected: value is String ? value : null,
          multiSelect: false,
          readOnly: readOnly,
          hasError: errorText != null,
          onChanged: onChanged,
        );
      case CustomQuestionType.checkbox:
        return _OptionTiles(
          options: _options,
          selectedValues: _selectedStringList(value),
          multiSelect: true,
          readOnly: readOnly,
          hasError: errorText != null,
          onChanged: onChanged,
        );
    }
  }
}

class _IndexBadge extends StatelessWidget {
  final int number;

  const _IndexBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(AppColors.primary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(AppColors.primary),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final CustomQuestionModel question;

  const _FieldLabel({required this.question});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(AppColors.text),
          height: 1.3,
        ),
        children: [
          TextSpan(text: question.label),
          if (question.required)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: Color(AppColors.error),
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionTiles extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final List<String>? selectedValues;
  final bool multiSelect;
  final bool readOnly;
  final bool hasError;
  final ValueChanged<dynamic>? onChanged;

  const _OptionTiles({
    required this.options,
    this.selected,
    this.selectedValues,
    required this.multiSelect,
    required this.readOnly,
    this.hasError = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final picked = multiSelect
        ? List<String>.from(selectedValues ?? const [])
        : null;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: options.map((opt) {
        final isSelected = multiSelect
            ? picked!.contains(opt)
            : selected == opt;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: readOnly || onChanged == null
                ? null
                : () {
                    if (multiSelect) {
                      final next = List<String>.from(picked!);
                      if (isSelected) {
                        next.remove(opt);
                      } else {
                        next.add(opt);
                      }
                      onChanged!(next);
                    } else {
                      onChanged!(opt);
                    }
                  },
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(AppColors.primary).withValues(alpha: 0.1)
                    : const Color(AppColors.background),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? const Color(AppColors.primary)
                      : hasError
                      ? const Color(AppColors.error)
                      : const Color(AppColors.divider),
                  width: isSelected || hasError ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    multiSelect
                        ? (isSelected
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded)
                        : (isSelected
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded),
                    size: 16,
                    color: isSelected
                        ? const Color(AppColors.primary)
                        : const Color(AppColors.textSecondary),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    opt,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? const Color(AppColors.text)
                          : const Color(AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
