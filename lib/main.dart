import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quize_riverpod/models/failure_model.dart';
import 'package:quize_riverpod/repositories/quiz_repository.dart';

import 'controllers/quiz/quiz_controller.dart';
import 'enums/difficulty.dart';
import 'models/question_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Riverpod Quiz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.yellow,
            bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: Colors.transparent)),
        home: QuizScreen(),
      ),
    );
  }
}

final quizQuestionProvider = FutureProvider.autoDispose<List<Question>>(
  (ref) => ref.watch(quizRepositoryProvider).getQuestions(
        numQuestions: 5,
        categoryId: Random().nextInt(24) + 9,
        difficulty: Difficulty.any,
      ),
);

class QuizScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final quizQuestions = useProvider(quizQuestionProvider);
    final pageController = usePageController();
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFD4418E),
            Color(0xFF0652C5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: quizQuestions.when(
          data: (questions) => _buildBody(context, pageController, questions),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => QuizError(
              message:
                  error is Failure ? error.message : 'something went wrong!'),
        ),
        bottomSheet: quizQuestions.maybeWhen(data: (questions) {
          final QuizState = useProvider(quizControllerProvider.state);
          if (!quizState.answered) return const SizedBox.shrink();
          return CustomButton(
            title: pageController.page.toInt() + 1 < questions.length
                ? 'Next Question'
                : 'See Result',
            onTap: () {
              context
                  .read(quizControllerProvider)
                  .nextQuestion(questions, pageController.page!.toInt());
              if (pageController.page.toInt() + 1 < questions.length) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.linear,
                );
              }
            },
          );
        }),
      ),
    );
  }
}

class QuizError extends StatelessWidget {
  final String message;

  const QuizError({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 20.0),
          CustomButton(
            title: 'Retry',
            onTap: () => context.refresh(quizRepositoryProvider),
          ),
        ],
      ),
    );
  }
}

final List<BoxShadow> boxShadow = [
  const BoxShadow(
    color: Colors.black26,
    offset: Offset(0, 2),
    blurRadius: 4.0,
  ),
];

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomButton({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(20.0),
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.yellow[700],
          boxShadow: boxShadow,
          borderRadius: BorderRadius.circular(25.0),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
