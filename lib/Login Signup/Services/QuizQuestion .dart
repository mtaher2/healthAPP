class QuizQuestion {
  final String scenario;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String rationale;

  QuizQuestion({
    required this.scenario,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.rationale,
  });
}
