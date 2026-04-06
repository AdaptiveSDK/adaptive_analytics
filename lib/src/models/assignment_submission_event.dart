/// Possible statuses for an assignment submission.
enum SubmissionStatus {
  /// The assignment has been submitted.
  submitted,

  /// The assignment was saved as a draft.
  draft,

  /// The submission has been reopened for editing.
  reopened,
}

/// Event data for an assignment submission action.
class AssignmentSubmissionEvent {
  final int courseId;
  final String courseName;
  final int assignmentId;
  final String assignmentName;

  /// Whether the submission was late.
  final bool isLate;

  /// Which attempt number this submission represents.
  final int attemptNumber;

  /// Due date expressed as a Unix epoch timestamp (seconds).
  final int dueDateTimestamp;

  final SubmissionStatus submissionStatus;

  const AssignmentSubmissionEvent({
    required this.courseId,
    required this.courseName,
    required this.assignmentId,
    required this.assignmentName,
    required this.isLate,
    required this.attemptNumber,
    required this.dueDateTimestamp,
    required this.submissionStatus,
  });

  Map<String, dynamic> toMap() => {
        'courseId': courseId,
        'courseName': courseName,
        'assignmentId': assignmentId,
        'assignmentName': assignmentName,
        'isLate': isLate,
        'attemptNumber': attemptNumber,
        'dueDateTimestamp': dueDateTimestamp,
        'submissionStatus': submissionStatus.name.toUpperCase(),
      };
}
