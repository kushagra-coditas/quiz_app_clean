import 'package:equatable/equatable.dart' show Equatable;

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
  final String difficulty;
  final String question;
  final List<String>? options;
  final List<dynamic>? correctAnswers;
  final List<String>? acceptableAnswers;
  final List<String>? leftColumn;
  final List<String>? rightColumn;
  final int points;
  final double? tolerance;
  final List<dynamic>? correctOrder;

  const QuestionEntity({
    this.id,
    this.type,
    required this.difficulty,
    required this.question,
    this.options,
    this.correctAnswers,
    this.acceptableAnswers,
    this.leftColumn,
    this.rightColumn,
    required this.points,
    this.tolerance,
    this.correctOrder,
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
    difficulty,
    correctOrder,
  ];
}
