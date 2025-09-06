part of 'quiz_bloc.dart';

abstract class QuizState {}

class LoadingQuiz extends QuizState {}

class LoadedQuiz extends QuizState {
  final List<QuestionEntity> questions;

  final int currentIndex;
  final dynamic selectedOption;
  final bool answered;
  final int points;

  LoadedQuiz({
    required this.questions,
    required this.currentIndex,
    this.selectedOption,
    required this.answered,
    required this.points,
  });

  LoadedQuiz copyWith({
    List<QuestionModel>? questions,
    dynamic currentIndex,
    dynamic selectedOption,
    bool? answered,
    int? points,
    bool? isSelected,
  }) {
    return LoadedQuiz(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOption: selectedOption,
      answered: answered ?? this.answered,
      points: points ?? this.points,
    );
  }
}

class ErrorQuiz extends QuizState {
  final String message;
  ErrorQuiz(this.message);
}
