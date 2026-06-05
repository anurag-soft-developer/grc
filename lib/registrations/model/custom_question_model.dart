import 'package:dart_mappable/dart_mappable.dart';
import 'package:grc/registrations/model/custom_question_type.dart';

part 'custom_question_model.mapper.dart';

@MappableClass()
class CustomQuestionModel with CustomQuestionModelMappable {
  final String key;
  final String label;
  final CustomQuestionType type;
  final List<String> options;
  final bool required;
  final int order;

  const CustomQuestionModel({
    required this.key,
    required this.label,
    required this.type,
    this.options = const [],
    this.required = false,
    this.order = 0,
  });

  static final fromMap = CustomQuestionModelMapper.fromMap;
}
