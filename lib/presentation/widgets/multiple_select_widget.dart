import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_clean/domain/entities/questions_entity.dart';
import 'package:quiz_app_clean/presentation/bloc/quiz_bloc.dart';

class MultipleSelectWidget extends StatelessWidget {
  final QuestionEntity q;
  final LoadedQuiz state;

  const MultipleSelectWidget({super.key, required this.q, required this.state});

  @override
  Widget build(BuildContext context) {
    final List<String> selectedOptions = state.selectedOption is List
        ? List<String>.from(state.selectedOption)
        : <String>[];

    return Column(
      children: <Widget>[
        ...q.options!.map((String option) {
          final bool isSelected = selectedOptions.contains(option);
          final bool isCorrect =
              q.correctAnswers != null && q.correctAnswers!.contains(option);
          Color tileColor;
          if (state.answered) {
            if (isSelected && isCorrect) {
              tileColor = Colors.green.shade400;
            } else if (isSelected && !isCorrect) {
              tileColor = Colors.red.shade400;
            } else if (!isSelected && isCorrect) {
              tileColor = Colors.green.shade100;
            } else {
              tileColor = Colors.grey.shade200;
            }
          } else {
            tileColor = isSelected
                ? Color.fromARGB(174, 89, 221, 65)
                : Colors.grey.shade200;
          }
          return GestureDetector(
            onTap: () {
              if (!state.answered) {
                final List<String> newOrder = List<String>.from(
                  selectedOptions,
                );
                if (isSelected) {
                  newOrder.remove(option);
                } else {
                  newOrder.add(option);
                }
                context.read<QuizBloc>().add(SelectAnswer(newOrder));
              }
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 6),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(option),
            ),
          );
        }),

        SizedBox(height: 12),

        ElevatedButton(
          onPressed: state.answered
              ? null
              : () {
                  context.read<QuizBloc>().add(SubmitAnswer());
                },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
