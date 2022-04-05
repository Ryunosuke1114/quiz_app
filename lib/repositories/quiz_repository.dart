import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quize_riverpod/repositories/base_quiz_repository.dart';

import '../enums/difficulty.dart';
import '../models/question_model.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

class QizeRepository extends BaseQuizRepository {
  late final Reader _read;

  QuizeRepository(this._read);

  @override
  Future<List<Question>> getQuestions({
    required int numQuestions,
    required int categoryId,
    required Difficulty difficulty,
}) async{
    try{
      final queryParameters ={
        'type': 'multiple',
        'amount': numQuestions,
        'category':categoryId,
      };

      if(difficulty != Difficulty.any){
        queryParameters.addAll(
            {'difficulty': EnumToString(difficulty)},
        );
      }

      final response = await _read(dioProvider).get(
        'https://opentdb.com/api_config.php',
        queryParameters: queryParameters,
      );

      if(response.statusCode == 200){
        final data = Map<String, dynamic>.from(response.data);
        final results = List<Map<String, dynamic>>.from(data['results'] ?? []);
        if(results.isNotEmpty){
          return
        }
      }
    }catch(err){}
  }
}
