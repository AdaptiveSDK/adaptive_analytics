# adaptive_analytics_flutter

[![pub version](https://img.shields.io/pub/v/adaptive_analytics_flutter.svg)](https://pub.dev/packages/adaptive_analytics_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-android-green.svg)](https://pub.dev/packages/adaptive_analytics_flutter)

Flutter plugin for the **Adaptive SDK Analytics** module. Tracks learning-related events and sends them to the Adaptive e-learning platform backend.

Supported events:

| Event | Description |
|-------|-------------|
| `GradeChangeEvent` | A student's grade was updated |
| `BadgeEarnedEvent` | A student earned a badge |
| `CourseEnrollmentEvent` | A student enrolled in a course |
| `CourseCompletionEvent` | A student completed a course |
| `ModuleCompletionEvent` | A student completed a course module |
| `QuizSubmissionEvent` | A student submitted a quiz |
| `AssignmentSubmissionEvent` | A student submitted an assignment |
| `StudentInactivityEvent` | A student has been inactive for N days |

> **Requires** [`adaptive_core_flutter`](https://pub.dev/packages/adaptive_core_flutter) to be initialized first.  
> **Android only.**

---

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Prerequisites](#prerequisites)
  - [Log Events](#log-events)
- [Event Reference](#event-reference)
- [Error Handling](#error-handling)
- [API Reference](#api-reference)
- [Contributing](#contributing)
- [License](#license)

---

## Requirements

| Requirement | Minimum Version |
|-------------|----------------|
| Flutter | 3.10.0 |
| Dart | 3.0.0 |
| Android `minSdk` | 24 (Android 7.0) |
| `adaptive_core_flutter` | 1.0.0 |

---

## Installation

```yaml
dependencies:
  adaptive_core_flutter: ^1.0.0
  adaptive_analytics_flutter: ^1.0.0
```

```bash
flutter pub get
```

---

## Usage

### Prerequisites

You **must** initialize the Core SDK and log in a user before logging any event:

```dart
import 'package:adaptive_core_flutter/adaptive_core_flutter.dart';
import 'package:adaptive_analytics_flutter/adaptive_analytics_flutter.dart';

// In main() or your app's init logic:
await AdaptiveCore.initialize(clientId: 'YOUR_API_KEY');
await AdaptiveCore.login(
  const AdaptiveUser(userId: '1001', userName: 'Jane', userEmail: 'jane@example.com'),
);
```

### Log Events

All log methods are fire-and-forget — they launch an internal coroutine on Android and return immediately. The underlying SDK queues events when offline.

```dart
// Badge earned
await AdaptiveAnalytics.logBadgeEarnedEvent(
  const BadgeEarnedEvent(
    badgeId: 42,
    badgeName: 'Top Learner',
    badgeDescription: 'Awarded for outstanding performance.',
    issuedBy: 'System',
  ),
);

// Grade change
await AdaptiveAnalytics.logGradeChangeEvent(
  const GradeChangeEvent(
    courseId: 'COURSE_01',
    courseName: 'Flutter Basics',
    previousGrade: 60,
    newGrade: 85,
    maxGrade: 100,
    gradeItemName: 'Midterm Exam',
    status: GradeStatus.success,
  ),
);

// Course enrollment
await AdaptiveAnalytics.logCourseEnrollmentEvent(
  const CourseEnrollmentEvent(
    courseId: 'COURSE_01',
    courseName: 'Flutter Basics',
    enrollmentMethod: EnrollmentMethod.self,
    roleName: 'student',
  ),
);

// Course completion
await AdaptiveAnalytics.logCourseCompletionEvent(
  CourseCompletionEvent(
    courseId: 'COURSE_01',
    courseName: 'Flutter Basics',
    finalGrade: 88,
    completionTimestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
  ),
);

// Module completion
await AdaptiveAnalytics.logModuleCompletionEvent(
  const ModuleCompletionEvent(
    courseId: 'COURSE_01',
    moduleId: 'MODULE_03',
    courseName: 'Flutter Basics',
    moduleName: 'State Management',
    completionState: ModuleCompletionState.completePass,
  ),
);

// Quiz submission
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

// Assignment submission
await AdaptiveAnalytics.logAssignmentSubmissionEvent(
  AssignmentSubmissionEvent(
    courseId: 'COURSE_01',
    courseName: 'Flutter Basics',
    assignmentId: 'ASSIGN_01',
    assignmentName: 'Build a Todo App',
    isLate: false,
    attemptNumber: 1,
    dueDateTimestamp: DateTime(2026, 4, 1).millisecondsSinceEpoch ~/ 1000,
    submissionStatus: SubmissionStatus.submitted,
  ),
);

// Student inactivity
await AdaptiveAnalytics.logStudentInactivityEvent(
  StudentInactivityEvent(
    lastLoginTimestamp: DateTime.now()
        .subtract(const Duration(days: 14))
        .millisecondsSinceEpoch ~/ 1000,
    inactiveDays: 14,
    lastAccessedCourseId: 'COURSE_01',
  ),
);
```

---

## Event Reference

### `GradeChangeEvent`

| Field | Type | Description |
|-------|------|-------------|
| `courseId` | `String` | Unique course identifier |
| `courseName` | `String` | Human-readable course name |
| `previousGrade` | `double` | Grade before the change |
| `newGrade` | `double` | Grade after the change |
| `maxGrade` | `double` | Maximum possible grade |
| `gradeItemName` | `String` | Name of the graded item |
| `status` | `GradeStatus` | `success` or `fail` |

### `BadgeEarnedEvent`

| Field | Type | Description |
|-------|------|-------------|
| `badgeId` | `int` | Unique badge identifier |
| `badgeName` | `String` | Badge display name |
| `badgeDescription` | `String` | Badge description |
| `issuedBy` | `String` | Issuer name (person or system) |

### `CourseEnrollmentEvent`

| Field | Type | Description |
|-------|------|-------------|
| `courseId` | `String` | Unique course identifier |
| `courseName` | `String` | Human-readable course name |
| `enrollmentMethod` | `EnrollmentMethod` | `self` or `manual` |
| `roleName` | `String` | Moodle role (e.g. `"student"`) |

### `CourseCompletionEvent`

| Field | Type | Description |
|-------|------|-------------|
| `courseId` | `String` | Unique course identifier |
| `courseName` | `String` | Human-readable course name |
| `finalGrade` | `double` | Final grade (0–100) |
| `completionTimestamp` | `int` | Unix epoch seconds |

### `ModuleCompletionEvent`

| Field | Type | Description |
|-------|------|-------------|
| `courseId` | `String` | Unique course identifier |
| `moduleId` | `String` | Unique module identifier |
| `courseName` | `String` | Course name |
| `moduleName` | `String` | Module name |
| `completionState` | `ModuleCompletionState` | `incomplete(0)`, `complete(1)`, `completePass(2)`, `completeFail(3)` |

### `QuizSubmissionEvent`

| Field | Type | Description |
|-------|------|-------------|
| `courseId` | `String` | Unique course identifier |
| `courseName` | `String` | Course name |
| `quizId` | `String` | Unique quiz identifier |
| `quizName` | `String` | Quiz name |
| `grade` | `double` | Score achieved |
| `maxGrade` | `double` | Maximum possible score |
| `attemptNumber` | `int` | Attempt count (1-based) |
| `timeTakenSeconds` | `int` | Time to complete (seconds) |

### `AssignmentSubmissionEvent`

| Field | Type | Description |
|-------|------|-------------|
| `courseId` | `String` | Unique course identifier |
| `courseName` | `String` | Course name |
| `assignmentId` | `String` | Unique assignment identifier |
| `assignmentName` | `String` | Assignment name |
| `isLate` | `bool` | Whether submitted after due date |
| `attemptNumber` | `int` | Attempt count (1-based) |
| `dueDateTimestamp` | `int` | Due date as Unix epoch seconds |
| `submissionStatus` | `SubmissionStatus` | `submitted`, `draft`, or `reopened` |

### `StudentInactivityEvent`

| Field | Type | Description |
|-------|------|-------------|
| `lastLoginTimestamp` | `int` | Last login as Unix epoch seconds |
| `inactiveDays` | `int` | Days since last activity |
| `lastAccessedCourseId` | `String` | Last visited course ID |

---

## Error Handling

```dart
try {
  await AdaptiveAnalytics.logBadgeEarnedEvent(event);
} on AdaptiveAnalyticsException catch (e) {
  print('Analytics error [${e.code}]: ${e.message}');
}
```

### Error codes

| Code | Cause |
|------|-------|
| `ANALYTICS_ERROR` | Generic analytics or SDK error |
| `INVALID_ARGUMENT` | A required argument was missing |

---

## API Reference

### `AdaptiveAnalytics`

| Method | Event type |
|--------|-----------|
| `logGradeChangeEvent(GradeChangeEvent)` | Grade updated |
| `logBadgeEarnedEvent(BadgeEarnedEvent)` | Badge awarded |
| `logCourseEnrollmentEvent(CourseEnrollmentEvent)` | Course enrolled |
| `logCourseCompletionEvent(CourseCompletionEvent)` | Course completed |
| `logModuleCompletionEvent(ModuleCompletionEvent)` | Module completed |
| `logQuizSubmissionEvent(QuizSubmissionEvent)` | Quiz submitted |
| `logAssignmentSubmissionEvent(AssignmentSubmissionEvent)` | Assignment submitted |
| `logStudentInactivityEvent(StudentInactivityEvent)` | Student inactive |

---

## Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/new-event`
3. Commit: `git commit -m 'feat: add new event type'`
4. Push: `git push origin feature/new-event`
5. Open a Pull Request

---

## License

MIT License — see [LICENSE](LICENSE) for details.
