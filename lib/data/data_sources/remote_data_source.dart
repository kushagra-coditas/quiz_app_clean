import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quiz_app_clean/data/models/questions_model.dart';

abstract class RemoteDataSource {
  Future<List<QuestionModel>> fetchQuestions();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  @override
  Future<List<QuestionModel>> fetchQuestions() async {
    final String jsonString = await rootBundle.loadString('lib/assets/quiz_questions.json');
    final Map<String, dynamic> data = jsonDecode(jsonString);

    final List<dynamic> questionsJson = (data['questions'] as List<dynamic>);
    return questionsJson
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> json) => QuestionModel.fromJson(json))
        .toList();
  }
}
