import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_clean/domain/entities/questions_entity.dart';
import 'package:quiz_app_clean/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_app_clean/presentation/widgets/option_tile_widget.dart';

class TrueFalseWidget extends StatelessWidget {
  final LoadedQuiz state;

  const TrueFalseWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final List<String> options = <String>['True', 'False'];
    final QuestionEntity q = state.questions[state.currentIndex];

    return Column(
      children: options.map((String option) {
        final bool isSelected =
            state.selectedOption != null &&
            state.selectedOption.toString() == option;

        final bool isCorrect = q.correctAnswers!
            .map((dynamic e) => e.toString())
            .contains(option);

        return OptionTile(
          isCorrect: isCorrect,
          text: option,
          isSelected: isSelected,
          answered: state.answered,
          onTap: () {
            if (isSelected) {
              context.read<QuizBloc>().add(SelectAnswer(null));
            } else {
              context.read<QuizBloc>().add(SelectAnswer(option));
            }
          },
        );
      }).toList(),
    );
  }
}
