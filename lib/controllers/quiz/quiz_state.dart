import 'package:equatable/equatable.dart';

import '../../models/question_model.dart';

enum QuizStatus {
  initial,
  correct,
  incorrect,
  complete,
}

class QuizState extends Equatable {
  final String selectedAnswer;
  final List<Question> correct;
  final List<Question> incorrect;
  final QuizStatus status;

  bool get answered =>
      status == QuizStatus.incorrect || status == QuizStatus.correct;

  const QuizState({
    required this.selectedAnswer,
    required this.correct,
    required this.incorrect,
    required this.status,
  });
}
