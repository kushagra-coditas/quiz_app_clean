import 'package:quiz_app_clean/domain/entities/questions_entity.dart';

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.difficulty,
    super.id,
    super.type,
    required super.question,
    super.options,
    super.leftColumn,
    super.rightColumn,
    super.correctAnswers,
    super.acceptableAnswers,
    required super.points,
    super.tolerance,
    super.correctOrder,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final QuestionType type = mapType(json['type']?.toString());

    final List<String> options =
        (json['options'] as List<dynamic>?)
            ?.map((dynamic e) => e.toString())
            .toList() ??
        <String>[];

    final dynamic allCorrect = json['correctAnswers'];
    final List<dynamic> normalizedCorrect = <dynamic>[];

    if (allCorrect != null) {
      if (type == QuestionType.multipleChoice ||
          type == QuestionType.multipleSelect) {
        if (allCorrect is List) {
          if (allCorrect.isNotEmpty && allCorrect.first is int) {
            for (final dynamic index in allCorrect) {
              final int i = index as int;
              normalizedCorrect.add(
                i >= 0 && i < options.length ? options[i] : index.toString(),
              );
            }
          } else {
            normalizedCorrect.addAll(
              allCorrect.map((dynamic e) => e.toString()),
            );
          }
        } else {
          normalizedCorrect.add(allCorrect.toString());
        }
      } else if (type == QuestionType.trueFalse) {
        if (allCorrect is List) {
          normalizedCorrect.addAll(
            allCorrect.map((dynamic e) {
              if (e == true) return 'True';
              if (e == false) return 'False';
              return e.toString();
            }),
          );
        } else {
          normalizedCorrect.add(
            allCorrect == true
                ? 'True'
                : (allCorrect == false ? 'False' : allCorrect.toString()),
          );
        }
      } else if (type == QuestionType.numerical) {
        if (allCorrect is List) {
          normalizedCorrect.addAll(allCorrect);
        } else {
          normalizedCorrect.add(allCorrect);
        }
      } else if (type == QuestionType.ordering) {
        if (json['correctOrder'] != null && json['correctOrder'] is List) {
          normalizedCorrect.addAll(
            (json['correctOrder'] as List<dynamic>).map(
              (dynamic e) => e.toString(),
            ),
          );
        }
      } else if (type == QuestionType.matching) {
        if (json['correctMatches'] != null && json['correctMatches'] is List) {
          normalizedCorrect.addAll(
            (json['correctMatches'] as List<dynamic>).map(
              (dynamic e) => Map<String, String>.from(e),
            ),
          );
        }
      } else {
        if (allCorrect is List) {
          normalizedCorrect.addAll(allCorrect.map((dynamic e) => e.toString()));
        } else {
          normalizedCorrect.add(allCorrect.toString());
        }
      }
    }

    final List<dynamic>? correctOrder =
        (json['correctOrder'] as List<dynamic>?)
            ?.map((dynamic e) => e.toString())
            .toList();

    final List<String>? acceptable =
        (json['acceptableAnswers'] as List<dynamic>?)
            ?.map((dynamic e) => e.toString())
            .toList();

    final int points = json['points'] is num
        ? (json['points'] as num).toInt()
        : int.tryParse(json['points']?.toString() ?? '') ?? 1;

    final double? tolerance = json['tolerance'] != null
        ? (json['tolerance'] is num
              ? (json['tolerance'] as num).toDouble()
              : double.tryParse(json['tolerance'].toString()))
        : null;

    return QuestionModel(
      id: json['id']?.toString() ?? '',
      type: type,
      question: json['question']?.toString() ?? '',
      options: options,
      correctOrder: correctOrder,
      leftColumn: (json['leftColumn'] as List<dynamic>?)
          ?.map((dynamic e) => e.toString())
          .toList(),
      rightColumn: (json['rightColumn'] as List<dynamic>?)
          ?.map((dynamic e) => e.toString())
          .toList(),
      correctAnswers: normalizedCorrect,
      acceptableAnswers: acceptable,
      points: points,
      tolerance: tolerance,
      difficulty: json['difficulty']?.toString() ?? '',
    );
  }

  static QuestionType mapType(String? type) {
    switch (type) {
      case 'multiple_choice':
        return QuestionType.multipleChoice;
      case 'true_false':
        return QuestionType.trueFalse;
      case 'fill_blank':
        return QuestionType.fillBlank;
      case 'numerical':
        return QuestionType.numerical;
      case 'multiple_select':
        return QuestionType.multipleSelect;
      case 'ordering':
        return QuestionType.ordering;
      case 'matching':
        return QuestionType.matching;
      default:
        return QuestionType.unknown;
    }
  }
}
