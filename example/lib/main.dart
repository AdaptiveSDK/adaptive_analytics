import 'package:adaptive_analytics/adaptive_analytics.dart';
import 'package:adaptive_core/adaptive_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Analytics Example',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _ready = false;
  String _status = 'Not ready — initialize and login first.';

  Future<void> _setup() async {
    try {
      await AdaptiveCore.initialize(clientId: 'YOUR_CLIENT_ID', debug: true);
      await AdaptiveCore.login(
        const AdaptiveUser(
          userId: '1001',
          userName: 'Jane Doe',
          userEmail: 'jane@example.com', phoneNumber: '24234235345',
        ),
      );
      setState(() {
        _ready = true;
        _status = '✅ Ready — tap an event to log it';
      });
    } on AdaptiveException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    } catch (e) {
      setState(() => _status = '❌ $e');
    }
  }

  Future<void> _run(String label, Future<void> Function() action) async {
    try {
      await action();
      setState(() => _status = '✅ $label logged');
    } on AdaptiveAnalyticsException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    } catch (e) {
      setState(() => _status = '❌ $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adaptive Analytics Example')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _status,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _ready ? null : _setup,
            icon: const Icon(Icons.rocket_launch),
            label: const Text('Initialize & Login'),
          ),
          const Divider(height: 32),
          _EventButton(
            label: 'Course Enrollment',
            enabled: _ready,
            onTap: () => _run(
              'Course Enrollment',
              () => AdaptiveAnalytics.logCourseEnrollmentEvent(
                const CourseEnrollmentEvent(
                  courseId: 9,
                  courseName: 'Flutter Basics',
                  enrollmentMethod: EnrollmentMethod.self,
                  roleName: 'student',
                ),
              ),
            ),
          ),
          _EventButton(
            label: 'Course Completion',
            enabled: _ready,
            onTap: () => _run(
              'Course Completion',
              () => AdaptiveAnalytics.logCourseCompletionEvent(
                CourseCompletionEvent(
                  courseId: 33,
                  courseName: 'Flutter Basics',
                  finalGrade: 92.5,
                  completionTimestamp:
                      DateTime.now().millisecondsSinceEpoch ~/ 1000,
                ),
              ),
            ),
          ),
          _EventButton(
            label: 'Module Completion',
            enabled: _ready,
            onTap: () => _run(
              'Module Completion',
              () => AdaptiveAnalytics.logModuleCompletionEvent(
                const ModuleCompletionEvent(
                  courseId: 434,
                  moduleId: 34,
                  courseName: 'Flutter Basics',
                  moduleName: 'State Management',
                  completionState: ModuleCompletionState.completePass,
                ),
              ),
            ),
          ),
          _EventButton(
            label: 'Grade Change',
            enabled: _ready,
            onTap: () => _run(
              'Grade Change',
              () => AdaptiveAnalytics.logGradeChangeEvent(
                const GradeChangeEvent(
                  courseId: 4354,
                  courseName: 'Flutter Basics',
                  previousGrade: 70.0,
                  newGrade: 85.0,
                  maxGrade: 100.0,
                  gradeItemName: 323,
                  status: GradeStatus.success,
                ),
              ),
            ),
          ),
          _EventButton(
            label: 'Quiz Submission',
            enabled: _ready,
            onTap: () => _run(
              'Quiz Submission',
              () => AdaptiveAnalytics.logQuizSubmissionEvent(
                const QuizSubmissionEvent(
                  courseId: 43,
                  courseName: 'Flutter Basics',
                  quizId: 34,
                  quizName: 'Widgets Quiz',
                  grade: 85,
                  maxGrade: 100,
                  attemptNumber: 1,
                  timeTakenSeconds: 420,
                ),
              ),
            ),
          ),
          _EventButton(
            label: 'Assignment Submission',
            enabled: _ready,
            onTap: () => _run(
              'Assignment Submission',
              () => AdaptiveAnalytics.logAssignmentSubmissionEvent(
                AssignmentSubmissionEvent(
                  courseId: 43,
                  courseName: 'Flutter Basics',
                  assignmentId: 43,
                  assignmentName: 'Final Project',
                  isLate: false,
                  attemptNumber: 1,
                  dueDateTimestamp:
                      DateTime.now().millisecondsSinceEpoch ~/ 1000,
                  submissionStatus: SubmissionStatus.submitted,
                ),
              ),
            ),
          ),
          _EventButton(
            label: 'Badge Earned',
            enabled: _ready,
            onTap: () => _run(
              'Badge Earned',
              () => AdaptiveAnalytics.logBadgeEarnedEvent(
                const BadgeEarnedEvent(
                  badgeId: 42,
                  badgeName: 'Top Learner',
                  badgeDescription: 'Awarded for outstanding performance.',
                  issuedBy: 'System',
                ),
              ),
            ),
          ),
          _EventButton(
            label: 'Student Inactivity',
            enabled: _ready,
            onTap: () => _run(
              'Student Inactivity',
              () => AdaptiveAnalytics.logStudentInactivityEvent(
                StudentInactivityEvent(
                  lastLoginTimestamp:
                      DateTime.now().millisecondsSinceEpoch ~/ 1000 - 604800,
                  inactiveDays: 7,
                  lastAccessedCourseId: 324,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _EventButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        child: Text('Log $label'),
      ),
    );
  }
}
