class QuestionModel {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  String? imagePath ;

  QuestionModel(
      {required this.question,
      required this.options,
      required this.correctAnswerIndex,
      this.imagePath });
}
