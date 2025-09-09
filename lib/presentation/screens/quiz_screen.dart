import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_clean/data/data_sources/remote_data_source.dart';
import 'package:quiz_app_clean/data/repository_impl/repository_impl.dart';
import 'package:quiz_app_clean/domain/entities/questions_entity.dart';
import 'package:quiz_app_clean/domain/usecases/usecases.dart';
import 'package:quiz_app_clean/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_app_clean/presentation/widgets/fill_blank_widget.dart';
import 'package:quiz_app_clean/presentation/widgets/matching_widget.dart';
import 'package:quiz_app_clean/presentation/widgets/multiple_select_widget.dart';
import 'package:quiz_app_clean/presentation/widgets/mutliple_choice_widget.dart';
import 'package:quiz_app_clean/presentation/widgets/numerical_widget.dart';
import 'package:quiz_app_clean/presentation/widgets/ordering_widget.dart';
import 'package:quiz_app_clean/presentation/widgets/true_false_widget.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RemoteDataSourceImpl remoteDataSource = RemoteDataSourceImpl();
    final QuestionRepositoryImpl repository = QuestionRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    final FetchQuestionsUsecase fetchQuestionsUsecase = FetchQuestionsUsecase(
      repository,
    );

    return BlocProvider<QuizBloc>(
      create: (_) => QuizBloc(fetchQuestionsUsecase)..add(LoadQuiz()),
      child: BlocBuilder<QuizBloc, QuizState>(
        builder: (BuildContext context, QuizState state) {
          if (state is LoadingQuiz) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (state is ErrorQuiz) {
            return Scaffold(body: Center(child: Text(state.message)));
          } else if (state is LoadedQuiz) {
            final QuestionEntity questionEntity =
                state.questions[state.currentIndex];

            return Scaffold(
              appBar: AppBar(title: Text('Question ${state.currentIndex + 1}')),
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questionEntity.question,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Difficulty Level: ${questionEntity.difficulty}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),
                    Expanded(
                      child: buildQuestionWidget(
                        questionEntity,
                        state,
                        context,
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: state.currentIndex < state.questions.length - 1
                          ? () => context.read<QuizBloc>().add(NextQuestion())
                          : null,
                      child: Text('Next Question'),
                    ),
                    SizedBox(height: 8),
                    Text('Points: ${state.points}'),
                  ],
                ),
              ),
            );
          }
          return Scaffold(body: Center(child: Text('Unknown state')));
        },
      ),
    );
  }

  Widget buildQuestionWidget(
    QuestionEntity questionEntity,
    LoadedQuiz state,
    BuildContext context,
  ) {
    switch (questionEntity.type) {
      case QuestionType.multipleChoice:
        return MultipleChoiceWidget(q: questionEntity, state: state);
      case QuestionType.multipleSelect:
        return MultipleSelectWidget(q: questionEntity, state: state);
      case QuestionType.trueFalse:
        return TrueFalseWidget(state: state);
      case QuestionType.fillBlank:
        return FillBlankWidget(state: state);
      case QuestionType.numerical:
        return NumericalWidget(state: state);
      case QuestionType.ordering:
        return OrderingWidget(q: questionEntity, state: state);
      case QuestionType.matching:
        return MatchingWidget(q: questionEntity, state: state);
      default:
        return const Center(child: Text('Unsupported question type.'));
    }
  }
}
