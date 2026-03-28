import 'package:flutter/material.dart';
import 'package:adaptive_core_flutter/adaptive_core_flutter.dart';
import 'package:adaptive_analytics_flutter/adaptive_analytics_flutter.dart';

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
            userEmail: 'jane@example.com'),
      );
      setState(() {
        _ready = true;
        _status = '✅ Ready — select an event to log';
      });
    } on AdaptiveException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    }
  }

  Future<void> _logBadge() async {
    try {
      await AdaptiveAnalytics.logBadgeEarnedEvent(
        const BadgeEarnedEvent(
          badgeId: 42,
          badgeName: 'Top Learner',
          badgeDescription: 'Awarded for outstanding course performance.',
          issuedBy: 'System',
        ),
      );
      setState(() => _status = '✅ Badge event logged');
    } on AdaptiveAnalyticsException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    }
  }

  Future<void> _logQuiz() async {
    try {
      await AdaptiveAnalytics.logQuizSubmissionEvent(
        const QuizSubmissionEvent(
          courseId: 'COURSE_01',
          courseName: 'Flutter Basics',
          quizId: 'QUIZ_01',
          quizName: 'Widgets Quiz',
          grade: 85,
          maxGrade: 100,
          attemptNumber: 1,
          timeTakenSeconds: 420,
        ),
      );
      setState(() => _status = '✅ Quiz event logged');
    } on AdaptiveAnalyticsException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    }
  }

  Future<void> _logEnrollment() async {
    try {
      await AdaptiveAnalytics.logCourseEnrollmentEvent(
        const CourseEnrollmentEvent(
          courseId: 'COURSE_01',
          courseName: 'Flutter Basics',
          enrollmentMethod: EnrollmentMethod.self,
          roleName: 'student',
        ),
      );
      setState(() => _status = '✅ Enrollment event logged');
    } on AdaptiveAnalyticsException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adaptive Analytics Example')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_status,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
                onPressed: _ready ? null : _setup,
                child: const Text('Initialize & Login')),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _ready ? _logBadge : null,
                child: const Text('Log Badge Earned')),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _ready ? _logQuiz : null,
                child: const Text('Log Quiz Submission')),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _ready ? _logEnrollment : null,
                child: const Text('Log Course Enrollment')),
          ],
        ),
      ),
    );
  }
}
