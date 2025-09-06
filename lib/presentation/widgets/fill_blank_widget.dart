import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_clean/presentation/bloc/quiz_bloc.dart';

class FillBlankWidget extends StatelessWidget {
  final LoadedQuiz state;

   const FillBlankWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          onSubmitted: (String value) {
            if (!state.answered) {
              context.read<QuizBloc>().add(SelectAnswer(value));
            }
          },
          decoration:  InputDecoration(hintText: 'Enter answer'),
        ),
         SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            if (!state.answered) {
              context.read<QuizBloc>().add(SelectAnswer(controller.text));
            }
          },
          child:  Text('Submit'),
        ),
      ],
    );
  }
}