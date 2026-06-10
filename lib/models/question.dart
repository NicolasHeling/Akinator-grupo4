enum AnswerOption { yes, no, dontKnow, probablyYes, probablyNo }

extension AnswerOptionExtension on AnswerOption {
  double get value {
    switch (this) {
      case AnswerOption.yes:
        return 1.0;
      case AnswerOption.no:
        return -1.0;
      case AnswerOption.dontKnow:
        return 0.0;
      case AnswerOption.probablyYes:
        return 0.5;
      case AnswerOption.probablyNo:
        return -0.5;
    }
  }
}

class Question {
  final int id;
  final String text;
  Question({required this.id, required this.text});
}
