import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quize_riverpod/repositories/base_quiz_repository.dart';

import '../enums/difficulty.dart';
import '../models/question_model.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

class QuizRepository extends BaseQuizRepository {
  late final Reader _read;

  QuizRepository(this._read);

  @override
  Future<List<Question>> getQuestions({
    required int numQuestions,
    required int categoryId,
    required Difficulty difficulty,
  }) async {
    try {
      final queryParameters = {
        'type': 'multiple',
        'amount': numQuestions,
        'category': categoryId,
      };

      if (difficulty != Difficulty.any) {
        queryParameters.addAll(
          {'difficulty': EnumToString.convertToString(difficulty)},
        );
      }

      final response = await _read(dioProvider).get(
        'https://opentdb.com/api_config.php',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        final results = List<Map<String, dynamic>>.from(data['results'] ?? []);
        if (results.isNotEmpty) {
          return results.map((e) => Question.fromMap(e)).toString();
        }
      }
      return [];
    } on DioError catch (e) {
      print('error');
      throw Failure(message: e.response?.statusMessage ?? 'Something went wrong');
    }on SocketException (e){
      print(e);
      throw const Failure(message: 'Please check your connection.');
    };
  }
}
