import 'package:equatable/equatable.dart';

class Question extends Equatable {
  late String category;
  late String difficulty;
  late String question;
  late String correctAnswer;
  late List<String> answers;

  Question({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.answers,
  });

  @override
  List<Object> get props => [
        category,
        difficulty,
        question,
        correctAnswer,
        answers,
      ];

  Question? fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return Question(
      category: map['category'] ?? '',
      difficulty: map['difficulty'] ?? '',
      question: map['question'] ?? '',
      correctAnswer: map['correct_answer'] ?? '',
      answers: List<String>.from(map['incorrect_answers'] ?? [])
        ..add(map['correct_answer'] ?? '')
        ..shuffle(),
    );
  }
}
