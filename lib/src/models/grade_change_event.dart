/// Whether the grade change represents a passing or failing outcome.
enum GradeStatus {
  success,
  fail,
}

/// Event data for when a student's grade changes.
class GradeChangeEvent {
  final int courseId;
  final String courseName;
  final double previousGrade;
  final double newGrade;
  final double maxGrade;
  final int gradeItemName;
  final GradeStatus status;

  const GradeChangeEvent({
    required this.courseId,
    required this.courseName,
    required this.previousGrade,
    required this.newGrade,
    required this.maxGrade,
    required this.gradeItemName,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        'courseId': courseId,
        'courseName': courseName,
        'previousGrade': previousGrade,
        'newGrade': newGrade,
        'maxGrade': maxGrade,
        'gradeItemName': gradeItemName,
        'status': status.name.toUpperCase(),
      };
}
