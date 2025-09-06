import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_clean/core/di/di.dart' as di;
import 'package:quiz_app_clean/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_app_clean/presentation/screens/quiz_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init(); 

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<QuizBloc>(
        create: (_) => di.dependencyInjection<QuizBloc>()..add(LoadQuiz()),
        child: QuizScreen(),
      ),
    );
  }
}
