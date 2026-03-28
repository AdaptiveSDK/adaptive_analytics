/// Completion state of a course module, mirroring Moodle's completion states.
enum ModuleCompletionState {
  /// Module not yet completed.
  incomplete(0),

  /// Module marked complete.
  complete(1),

  /// Module completed with a passing grade.
  completePass(2),

  /// Module completed but with a failing grade.
  completeFail(3);

  final int value;
  const ModuleCompletionState(this.value);
}

/// Event data for when a student completes a single course module.
class ModuleCompletionEvent {
  final String courseId;
  final String moduleId;
  final String courseName;
  final String moduleName;
  final ModuleCompletionState completionState;

  const ModuleCompletionEvent({
    required this.courseId,
    required this.moduleId,
    required this.courseName,
    required this.moduleName,
    required this.completionState,
  });

  Map<String, dynamic> toMap() => {
        'courseId': courseId,
        'moduleId': moduleId,
        'courseName': courseName,
        'moduleName': moduleName,
        'completionState': completionState.value,
      };
}
