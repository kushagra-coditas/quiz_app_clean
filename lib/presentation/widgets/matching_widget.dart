import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_clean/domain/entities/questions_entity.dart';
import 'package:quiz_app_clean/presentation/bloc/quiz_bloc.dart';

class MatchingWidget extends StatelessWidget {
  final QuestionEntity q;
  final LoadedQuiz state;

  const MatchingWidget({super.key, required this.q, required this.state});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> selected = state.selectedOption is List
        ? List<Map<String, String>>.from(state.selectedOption)
        : <Map<String, String>>[];

    String? pendingLeft;
    String? pendingRight;

    return Row(
      children: <Widget>[
   
        Expanded(
          child: Column(
            children: q.leftColumn!.map((String option) {
              final bool isUsed = selected.any(
                (Map<String, String> pair) => pair['left'] == option,
              );
              return tile(
                text: option,
                isSelected: pendingLeft == option,
                isDisabled: isUsed,
                onTap: () {
                  if (!state.answered && !isUsed) {
                    pendingLeft = option;
                    tryPair(context, pendingLeft, pendingRight, selected);
                  }
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 16),
        
        Expanded(
          child: Column(
            children: q.rightColumn!.map((String option) {
              final bool isUsed = selected.any(
                (Map<String, String> pair) => pair['right'] == option,
              );
              return tile(
                text: option,
                isSelected: pendingRight == option,
                isDisabled: isUsed,
                onTap: () {
                  if (!state.answered && !isUsed) {
                    pendingRight = option;
                    tryPair(context, pendingLeft, pendingRight, selected);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget tile({
    required String text,
    required bool isSelected,
    required bool isDisabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.shade300
              : (isSelected ? Colors.blueAccent : Colors.blue.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text),
      ),
    );
  }

  void tryPair(
    BuildContext context,
    String? left,
    String? right,
    List<Map<String, String>> selected,
  ) {
    if (left != null && right != null) {
      final List<Map<String, String>> newPairs = List<Map<String, String>>.from(
        selected,
      )..add(<String, String>{'left': left, 'right': right});
      context.read<QuizBloc>().add(SelectAnswer(newPairs));
    }
  }
}
