import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_clean/domain/entities/questions_entity.dart';
import 'package:quiz_app_clean/presentation/bloc/quiz_bloc.dart';

class OrderingWidget extends StatelessWidget {
  final QuestionEntity q;
  final LoadedQuiz state;

  const OrderingWidget({super.key, required this.q, required this.state});

  @override
  Widget build(BuildContext context) {
    final List<String> selectedOrder = state.selectedOption is List
        ? List<String>.from(state.selectedOption)
        : <String>[];

    return Column(
      children: q.options!.map((String option) {
        final int index = selectedOrder.indexOf(option);
        final bool isSelected = index != -1;

        return GestureDetector(
          onTap: () {
            if (!state.answered) {
              final List<String> newOrder = List<String>.from(selectedOrder);

              if (!isSelected) {
                newOrder.add(option);
              } else {
                newOrder.remove(option);
              }

              context.read<QuizBloc>().add(SelectAnswer(newOrder));
            }
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 6),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color.fromARGB(174, 89, 221, 65)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(option),
                if (isSelected)
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.green,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
