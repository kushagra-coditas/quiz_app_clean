import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_clean/data/models/questions_model.dart';
import 'package:quiz_app_clean/domain/entities/questions_entity.dart';
import 'package:quiz_app_clean/domain/usecases/usecases.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final FetchQuestionsUsecase fetchQuestionsUsecase;

  QuizBloc(this.fetchQuestionsUsecase) : super(LoadingQuiz()) {
    on<LoadQuiz>(onLoadQuiz);
    on<SelectAnswer>(onSelectAnswer);
    on<NextQuestion>(onNextQuestion);
    on<SubmitAnswer>(onSubmitAnswer);
  }

  Future<void> onLoadQuiz(LoadQuiz event, Emitter<QuizState> emit) async {
    emit(LoadingQuiz());
    try {
      final List<QuestionEntity> questions = await fetchQuestionsUsecase();
      if (questions.isEmpty) {
        emit(ErrorQuiz('No questions found'));
      } else {
        emit(
          LoadedQuiz(
            questions: questions,
            currentIndex: 0,
            selectedOption: null,
            answered: false,
            points: 0,
          ),
        );
      }
    } catch (e) {
      emit(ErrorQuiz('Failed to load quiz: $e'));
    }
  }

  void onSelectAnswer(SelectAnswer event, Emitter<QuizState> emit) {
    if (state is! LoadedQuiz) return;
    final LoadedQuiz loaded = state as LoadedQuiz;
    final QuestionEntity q = loaded.questions[loaded.currentIndex];

    if (q.type == QuestionType.multipleSelect) {
      final List<String> newSelection = event.selectedOption is List
          ? List<String>.from(
              event.selectedOption.map((dynamic e) => e.toString()),
            )
          : <String>[];

      emit(loaded.copyWith(selectedOption: newSelection));
      return;
    }
    final bool isCorrect = validateAnswer(q, event.selectedOption);
    final int newPoints = isCorrect ? loaded.points + q.points : loaded.points;

    emit(
      loaded.copyWith(
        selectedOption: event.selectedOption,
        answered: true,
        points: newPoints,
      ),
    );
  }

  void onSubmitAnswer(SubmitAnswer event, Emitter<QuizState> emit) {
    if (state is! LoadedQuiz) return;
    final LoadedQuiz loaded = state as LoadedQuiz;
    final QuestionEntity q = loaded.questions[loaded.currentIndex];

    if (q.type == QuestionType.multipleSelect) {
      final dynamic selected = loaded.selectedOption;
      final bool isCorrect = validateAnswer(q, selected);
      final int newPoints = isCorrect
          ? loaded.points + q.points
          : loaded.points;

      emit(loaded.copyWith(answered: true, points: newPoints));
    }
  }

  void onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    if (state is! LoadedQuiz) return;
    final LoadedQuiz loaded = state as LoadedQuiz;
    if (loaded.currentIndex < loaded.questions.length - 1) {
      emit(
        loaded.copyWith(
          currentIndex: loaded.currentIndex + 1,
          selectedOption: null,
          answered: false,
        ),
      );
    }
  }

  bool validateAnswer(QuestionEntity q, dynamic selected) {
    switch (q.type) {
      case QuestionType.multipleChoice:
        return selected != null &&
            q.correctAnswers!
                .map((dynamic e) => e.toString())
                .contains(selected.toString());
      case QuestionType.trueFalse:
        final String selStr = selected is bool
            ? (selected ? 'True' : 'False')
            : selected.toString();
        return q.correctAnswers!
            .map((dynamic e) => e.toString())
            .contains(selStr);
      case QuestionType.multipleSelect:
        if (selected == null) return false;

        final Set<String> correct = Set<String>.from(
          q.correctAnswers!.map((dynamic e) => e.toString()),
        );
        final Set<String> chosen = selected is Iterable
            ? Set<String>.from(selected.map((dynamic e) => e.toString()))
            : <String>{selected.toString()};

        return correct.length == chosen.length && correct.containsAll(chosen);

      case QuestionType.fillBlank:
        if (selected == null) return false;
        final String user = selected.toString().trim().toLowerCase();
        final List<String> accepted = <String>[
          ...q.correctAnswers!.map((dynamic e) => e.toString().toLowerCase()),
          ...?(q.acceptableAnswers?.map(
            (String e) => e.toString().toLowerCase(),
          )),
        ];
        return accepted.contains(user);

      case QuestionType.numerical:
        if (selected == null) return false;
        double userNum;
        double correctNum;
        try {
          userNum = double.parse(selected.toString());
          correctNum = double.parse(q.correctAnswers!.first.toString());
        } catch (e) {
          return false;
        }
        final double tol = q.tolerance ?? 0.0;
        return (userNum - correctNum) <= tol;

     case QuestionType.ordering:
  if (selected == null) return false;

  
  final List<String> chosenOrder = selected is List
      ? selected.map((dynamic e) => e.toString()).toList()
      : <String>[selected.toString()];

 
  final List<String> correctOrder =
      q.correctAnswers?.map((dynamic e) => e.toString()).toList() ?? <String>[];

 
  return chosenOrder.length == correctOrder.length &&
      List<bool>.generate(correctOrder.length,
              (int i) => correctOrder[i] == chosenOrder[i])
          .every((bool match) => match);

      case QuestionType.matching:
        if (selected == null) return false;

        final List<Map<String, String>> chosenPairs =
            List<Map<String, String>>.from(selected);

        final List<Map<String, String>> correctPairs =
            List<Map<String, String>>.from(q.correctAnswers!);

        return Set<dynamic>.from(
              chosenPairs.map(
                (Map<String, String> e) => '${e['left']}|${e['right']}',
              ),
            ).containsAll(
              correctPairs.map(
                (Map<String, String> e) => '${e['left']}|${e['right']}',
              ),
            ) &&
            chosenPairs.length == correctPairs.length;

      default:
        return false;
    }
  }
}
