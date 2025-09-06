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
        return GestureDetector(
          onTap: () {
            
            if (!state.answered) {
              final List<String> newSelection = List<String>.from(selectedOptions);
              if (isSelected) {
                newSelection.remove(option);
              } else {
                newSelection.add(option);
              }
              context.read<QuizBloc>().add(SelectAnswer(newSelection));
            }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? const Color.fromARGB(174, 89, 221, 65) : Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(option),
          ),
        );
      }),

      const SizedBox(height: 12),

      
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