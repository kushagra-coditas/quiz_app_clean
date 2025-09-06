part of 'quiz_bloc.dart';

abstract class QuizEvent {}

class LoadQuiz extends QuizEvent {}

class SelectAnswer extends QuizEvent {
  final dynamic selectedOption;
  SelectAnswer(this.selectedOption);
}

class SubmitAnswer extends QuizEvent {}

class NextQuestion extends QuizEvent {}
