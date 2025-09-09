import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_clean/domain/entities/questions_entity.dart';
import 'package:quiz_app_clean/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_app_clean/presentation/widgets/option_tile_widget.dart';

class MultipleChoiceWidget extends StatelessWidget {
  final QuestionEntity q;
  final LoadedQuiz state;

  const MultipleChoiceWidget({super.key, required this.q, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: q.options!.map((String option) {
        final bool isSelected = state.selectedOption != null &&
            state.selectedOption.toString() == option;

         final bool isCorrect =
            q.correctAnswers != null && q.correctAnswers!.contains(option);

        return OptionTile(
          answered: state.answered,
          isCorrect: isCorrect,
          text: option,
          isSelected: isSelected,
          
          onTap: () {
           if (isSelected) {
              context.read<QuizBloc>().add(SelectAnswer(null));
            }
          else {
              context.read<QuizBloc>().add(SelectAnswer(option));
            }
          },
        );
      }).toList(),
    );
  }
}
