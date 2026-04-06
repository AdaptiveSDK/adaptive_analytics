/// How the student enrolled in the course.
enum EnrollmentMethod {
  /// The student self-enrolled.
  self,

  /// An administrator enrolled the student manually.
  manual,
}

/// Event data for when a student enrolls in a course.
class CourseEnrollmentEvent {
  final int courseId;
  final String courseName;
  final EnrollmentMethod enrollmentMethod;

  /// The Moodle role name assigned to the student (e.g. "student").
  final String roleName;

  const CourseEnrollmentEvent({
    required this.courseId,
    required this.courseName,
    required this.enrollmentMethod,
    required this.roleName,
  });

  Map<String, dynamic> toMap() => {
        'courseId': courseId,
        'courseName': courseName,
        'enrollmentMethod': enrollmentMethod.name.toUpperCase(),
        'roleName': roleName,
      };
}
