import 'package:flutter/services.dart';
import 'models/assignment_submission_event.dart';
import 'models/badge_earned_event.dart';
import 'models/course_completion_event.dart';
import 'models/course_enrollment_event.dart';
import 'models/grade_change_event.dart';
import 'models/login_event.dart';
import 'models/module_completion_event.dart';
import 'models/quiz_submission_event.dart';
import 'models/registration_event.dart';
import 'models/student_inactivity_event.dart';
import 'models/user_properties_event.dart';
import 'adaptive_analytics_exception.dart';

///
/// Requires [AdaptiveCore] to be initialized and a user to be logged in before
/// calling any method.
///
/// ```dart
/// AdaptiveAnalytics.logBadgeEarnedEvent(
///   BadgeEarnedEvent(
///     badgeId: 1,
///     badgeName: 'Top Learner',
///     badgeDescription: 'Awarded for outstanding performance.',
///     issuedBy: 'System',
///   ),
/// );
/// ```
class AdaptiveAnalytics {
  static final MethodChannel _channel = MethodChannel('adaptive_analytics');

  AdaptiveAnalytics._();

  /// Logs a user registration event.
  static Future<void> logRegistrationEvent(RegistrationEvent event) =>
      _log('logRegistrationEvent', event.toMap());

  /// Logs a user login event.
  static Future<void> logLoginEvent(LoginEvent event) =>
      _log('logLoginEvent', event.toMap());

  /// Logs a user properties event.
  static Future<void> logUserPropertiesEvent(UserPropertiesEvent event) =>
      _log('logUserPropertiesEvent', event.toMap());

  /// Logs a grade change event.
  static Future<void> logGradeChangeEvent(GradeChangeEvent event) =>
      _log('logGradeChangeEvent', event.toMap());

  /// Logs a student inactivity event.
  static Future<void> logStudentInactivityEvent(StudentInactivityEvent event) =>
      _log('logStudentInactivityEvent', event.toMap());

  /// Logs a module completion event.
  static Future<void> logModuleCompletionEvent(ModuleCompletionEvent event) =>
      _log('logModuleCompletionEvent', event.toMap());

  /// Logs a badge earned event.
  static Future<void> logBadgeEarnedEvent(BadgeEarnedEvent event) =>
      _log('logBadgeEarnedEvent', event.toMap());

  /// Logs a course enrollment event.
  static Future<void> logCourseEnrollmentEvent(CourseEnrollmentEvent event) =>
      _log('logCourseEnrollmentEvent', event.toMap());

  /// Logs an assignment submission event.
  static Future<void> logAssignmentSubmissionEvent(
    AssignmentSubmissionEvent event,
  ) => _log('logAssignmentSubmissionEvent', event.toMap());

  /// Logs a quiz submission event.
  static Future<void> logQuizSubmissionEvent(QuizSubmissionEvent event) =>
      _log('logQuizSubmissionEvent', event.toMap());

  /// Logs a course completion event.
  static Future<void> logCourseCompletionEvent(CourseCompletionEvent event) =>
      _log('logCourseCompletionEvent', event.toMap());

  // ── Private helpers ────────────────────────────────────────────────────────

  static Future<void> _log(String method, Map<String, dynamic> payload) async {
    try {
      await _channel.invokeMethod<void>(method, payload);
    } on PlatformException catch (e) {
      throw AdaptiveAnalyticsException(code: e.code, message: e.message ?? '');
    }
  }
}
