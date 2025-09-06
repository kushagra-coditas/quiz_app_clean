import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_clean/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_app_clean/presentation/widgets/option_tile_widget.dart';

class TrueFalseWidget extends StatelessWidget {
  final LoadedQuiz state;

   const TrueFalseWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final List<String> options = <String>['True', 'False'];

    return Column(
      children: options.map((String option) {
        final bool isSelected = state.selectedOption != null &&
            state.selectedOption.toString() == option;
        return OptionTile(
          text: option,
          isSelected: isSelected,
          onTap: () {
            if (!state.answered) {
              context.read<QuizBloc>().add(SelectAnswer(option));
            }
          },
        );
      }).toList(),
    );
  }
}
