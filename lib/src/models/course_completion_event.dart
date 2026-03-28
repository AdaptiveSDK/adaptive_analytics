/// Event data for when a student completes an entire course.
class CourseCompletionEvent {
  final String courseId;
  final String courseName;

  /// Final grade achieved (0–100).
  final double finalGrade;

  /// Unix epoch timestamp (seconds) when the course was completed.
  final int completionTimestamp;

  const CourseCompletionEvent({
    required this.courseId,
    required this.courseName,
    required this.finalGrade,
    required this.completionTimestamp,
  });

  Map<String, dynamic> toMap() => {
        'courseId': courseId,
        'courseName': courseName,
        'finalGrade': finalGrade,
        'completionTimestamp': completionTimestamp,
      };
}
