/// Event data for when a student submits a quiz attempt.
class QuizSubmissionEvent {
  final int courseId;
  final String courseName;
  final int quizId;
  final String quizName;

  /// Grade achieved on this attempt (0–[maxGrade]).
  final double grade;
  final double maxGrade;
  final int attemptNumber;

  /// How long the student took to complete the quiz, in seconds.
  final int timeTakenSeconds;

  const QuizSubmissionEvent({
    required this.courseId,
    required this.courseName,
    required this.quizId,
    required this.quizName,
    required this.grade,
    required this.maxGrade,
    required this.attemptNumber,
    required this.timeTakenSeconds,
  });

  Map<String, dynamic> toMap() => {
        'courseId': courseId,
        'courseName': courseName,
        'quizId': quizId,
        'quizName': quizName,
        'grade': grade,
        'maxGrade': maxGrade,
        'attemptNumber': attemptNumber,
        'timeTakenSeconds': timeTakenSeconds,
      };
}
