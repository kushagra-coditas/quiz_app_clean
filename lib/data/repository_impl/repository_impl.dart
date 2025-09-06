import 'package:quiz_app_clean/data/data_sources/remote_data_source.dart';
import 'package:quiz_app_clean/data/models/questions_model.dart';
import 'package:quiz_app_clean/domain/entities/questions_entity.dart';
import 'package:quiz_app_clean/domain/repository/repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final RemoteDataSource remoteDataSource;

  QuestionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<QuestionEntity>> questionrepository() async {
    final List<QuestionModel> models = await remoteDataSource.fetchQuestions();
    return models; 
    }
}
