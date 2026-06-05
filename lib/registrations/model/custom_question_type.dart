import 'package:dart_mappable/dart_mappable.dart';
import 'package:get/get.dart';

part 'custom_question_type.mapper.dart';

@MappableEnum()
enum CustomQuestionType {
  text,
  textarea,
  select,
  radio,
  checkbox;

  String get label {
    return name.capitalizeFirst ?? '';
  }

  bool get needsOptions =>
      this == CustomQuestionType.select ||
      this == CustomQuestionType.radio ||
      this == CustomQuestionType.checkbox;
}
