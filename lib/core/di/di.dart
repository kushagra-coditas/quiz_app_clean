import 'package:get_it/get_it.dart';
import 'package:quiz_app_clean/data/data_sources/remote_data_source.dart';
import 'package:quiz_app_clean/data/repository_impl/repository_impl.dart';
import 'package:quiz_app_clean/domain/repository/repository.dart';
import 'package:quiz_app_clean/domain/usecases/usecases.dart';
import 'package:quiz_app_clean/presentation/bloc/quiz_bloc.dart';

final GetIt dependencyInjection = GetIt.instance;

Future<void> init() async {
  dependencyInjection.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(),
  );

  dependencyInjection.registerLazySingleton<QuestionRepository>(
    () => QuestionRepositoryImpl(remoteDataSource: dependencyInjection()),
  );

  dependencyInjection.registerLazySingleton(
    () => FetchQuestionsUsecase(dependencyInjection()),
  );

  dependencyInjection.registerFactory(() => QuizBloc(dependencyInjection()));
}
