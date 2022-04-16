import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quize_riverpod/controllers/quiz/quiz_state.dart';

import '../../models/question_model.dart';

final quizControllerProvider =
    StateNotifierProvider.autoDispose<QuizController>(
  (ref) => QuizController(),
);

class QuizController extends StateNotifier<QuizState> {
  QuizController() : super(QuizState.initial());

  void submitAnswer(Question currentQuestion, String answer) {
    if (state.answered) return;
    if (currentQuestion.correctAnswer == answer) {
      state = state.copyWith(
        selectedAnswer: answer,
        correct: state.correct..add(currentQuestion),
        status: QuizStatus.correct,
        incorrect: [],
      );
    } else {
      state = state.copyWith(
        selectedAnswer: answer,
        incorrect: state.incorrect..add(currentQuestion),
        status: QuizStatus.incorrect,
        correct: [],
      );
    }
    void nextQuestion(List<Question> questions, int currentIndex) {
      state = state.copyWith(
        selectedAnswer: '',
        status: currentIndex + 1 < questions.length
            ? QuizStatus.initial
            : QuizStatus.complete,
        incorrect: [],
        correct: [],
      );
      void reset() {
        state = QuizState.initial();
      }
    }
  }
}
