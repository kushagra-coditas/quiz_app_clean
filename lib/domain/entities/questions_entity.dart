import 'package:equatable/equatable.dart';

enum QuestionType {
  multipleChoice,
  trueFalse,
  fillBlank,
  numerical,
  multipleSelect,
  ordering,
  matching,
  unknown,
}

class QuestionEntity extends Equatable {
  final String? id;
  final QuestionType? type;
  final String question;
  final List<String>? options;
  final List<dynamic>? correctAnswers;
  final List<String>? acceptableAnswers;
  final List<String>? leftColumn;
  final List<String>? rightColumn;
  final int points;
  final double? tolerance;

  const QuestionEntity({
    this.id,
    this.type,
    required this.question,
    this.options,
    this.leftColumn,
    this.rightColumn,
    this.correctAnswers,
    this.acceptableAnswers,
    required this.points,
    this.tolerance,
  });

  @override
  List<Object?> get props => <Object?>[
    id,
    type,
    question,
    options,
    correctAnswers,
    acceptableAnswers,
    points,
    tolerance,
  ];
}
