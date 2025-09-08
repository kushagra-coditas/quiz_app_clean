import 'package:quiz_app_clean/domain/entities/questions_entity.dart';
import 'package:quiz_app_clean/domain/repository/repository.dart';

class FetchQuestionsUsecase {
  final QuestionRepository repository;

  FetchQuestionsUsecase(this.repository);

  Future<List<QuestionEntity>> call() async {
    return await repository.questionRepository();
  }
}
