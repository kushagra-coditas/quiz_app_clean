import 'package:quiz_app_clean/domain/entities/questions_entity.dart';

abstract class QuestionRepository {
  Future<List<QuestionEntity>> questionRepository();
}
