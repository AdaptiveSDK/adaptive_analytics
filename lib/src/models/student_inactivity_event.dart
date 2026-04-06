/// Event data for when a student has been inactive for a prolonged period.
class StudentInactivityEvent {
  /// Unix epoch timestamp (seconds) of the student's last login.
  final int lastLoginTimestamp;

  /// Number of consecutive days the student has been inactive.
  final int inactiveDays;

  /// The course ID the student last accessed (may be empty).
  final int lastAccessedCourseId;

  const StudentInactivityEvent({
    required this.lastLoginTimestamp,
    required this.inactiveDays,
    required this.lastAccessedCourseId,
  });

  Map<String, dynamic> toMap() => {
        'lastLoginTimestamp': lastLoginTimestamp,
        'inactiveDays': inactiveDays,
        'lastAccessedCourseId': lastAccessedCourseId,
      };
}
