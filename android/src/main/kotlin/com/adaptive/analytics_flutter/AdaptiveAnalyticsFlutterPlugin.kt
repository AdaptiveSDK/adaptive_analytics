package com.adaptive.analytics_flutter

import android.os.Handler
import android.os.Looper
import com.adaptive.analytics.AdaptiveAnalytics
import com.adaptive.analytics.events.AssignmentSubmissionEvent
import com.adaptive.analytics.events.BadgeEarnedEvent
import com.adaptive.analytics.events.CourseCompletionEvent
import com.adaptive.analytics.events.CourseEnrollmentEvent
import com.adaptive.analytics.events.EnrollmentMethod
import com.adaptive.analytics.events.GradeChangeEvent
import com.adaptive.analytics.events.GradeStatus
import com.adaptive.analytics.events.ModuleCompletionEvent
import com.adaptive.analytics.events.ModuleCompletionState
import com.adaptive.analytics.events.QuizSubmissionEvent
import com.adaptive.analytics.events.StudentInactivityEvent
import com.adaptive.analytics.events.SubmissionStatus
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** Flutter plugin that bridges the Adaptive Analytics Android SDK. */
class AdaptiveAnalyticsFlutterPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private val mainHandler = Handler(Looper.getMainLooper())

    // ── FlutterPlugin ─────────────────────────────────────────────────────────

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "adaptive_analytics")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // ── MethodCallHandler ─────────────────────────────────────────────────────

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "logGradeChangeEvent" -> {
                    AdaptiveAnalytics.logGradeChangeEvent(
                        GradeChangeEvent(
                            courseId = call.argument("courseId")!!,
                            courseName = call.argument("courseName")!!,
                            previousGrade = call.argument<Double>("previousGrade")!!,
                            newGrade = call.argument<Double>("newGrade")!!,
                            maxGrade = call.argument<Double>("maxGrade")!!,
                            gradeItemName = call.argument("gradeItemName")!!,
                            status = GradeStatus.valueOf(call.argument("status")!!),
                        )
                    )
                    result.success(null)
                }

                "logStudentInactivityEvent" -> {
                    AdaptiveAnalytics.logStudentInactivityEvent(
                        StudentInactivityEvent(
                            lastLoginTimestamp = call.argument<Int>("lastLoginTimestamp")!!.toLong(),
                            inactiveDays = call.argument("inactiveDays")!!,
                            lastAccessedCourseId = call.argument("lastAccessedCourseId")!!,
                        )
                    )
                    result.success(null)
                }

                "logModuleCompletionEvent" -> {
                    val stateValue = call.argument<Int>("completionState") ?: 0
                    val state = ModuleCompletionState.entries.firstOrNull { it.value == stateValue }
                        ?: ModuleCompletionState.INCOMPLETE
                    AdaptiveAnalytics.logModuleCompletionEvent(
                        ModuleCompletionEvent(
                            courseId = call.argument("courseId")!!,
                            moduleId = call.argument("moduleId")!!,
                            courseName = call.argument("courseName")!!,
                            moduleName = call.argument("moduleName")!!,
                            completionState = state,
                        )
                    )
                    result.success(null)
                }

                "logBadgeEarnedEvent" -> {
                    AdaptiveAnalytics.logBadgeEarnedEvent(
                        BadgeEarnedEvent(
                            badgeId = call.argument("badgeId")!!,
                            badgeName = call.argument("badgeName")!!,
                            badgeDescription = call.argument("badgeDescription")!!,
                            issuedBy = call.argument("issuedBy")!!,
                        )
                    )
                    result.success(null)
                }

                "logCourseEnrollmentEvent" -> {
                    AdaptiveAnalytics.logCourseEnrollmentEvent(
                        CourseEnrollmentEvent(
                            courseId = call.argument("courseId")!!,
                            courseName = call.argument("courseName")!!,
                            enrollmentMethod = EnrollmentMethod.valueOf(
                                call.argument("enrollmentMethod")!!
                            ),
                            roleName = call.argument("roleName")!!,
                        )
                    )
                    result.success(null)
                }

                "logAssignmentSubmissionEvent" -> {
                    AdaptiveAnalytics.logAssignmentSubmissionEvent(
                        AssignmentSubmissionEvent(
                            courseId = call.argument("courseId")!!,
                            courseName = call.argument("courseName")!!,
                            assignmentId = call.argument("assignmentId")!!,
                            assignmentName = call.argument("assignmentName")!!,
                            isLate = call.argument("isLate")!!,
                            attemptNumber = call.argument("attemptNumber")!!,
                            dueDateTimestamp = call.argument<Int>("dueDateTimestamp")!!.toLong(),
                            submissionStatus = SubmissionStatus.valueOf(
                                call.argument("submissionStatus")!!
                            ),
                        )
                    )
                    result.success(null)
                }

                "logQuizSubmissionEvent" -> {
                    AdaptiveAnalytics.logQuizSubmissionEvent(
                        QuizSubmissionEvent(
                            courseId = call.argument("courseId")!!,
                            courseName = call.argument("courseName")!!,
                            quizId = call.argument("quizId")!!,
                            quizName = call.argument("quizName")!!,
                            grade = call.argument<Double>("grade")!!,
                            maxGrade = call.argument<Double>("maxGrade")!!,
                            attemptNumber = call.argument("attemptNumber")!!,
                            timeTakenSeconds = call.argument<Int>("timeTakenSeconds")!!.toLong(),
                        )
                    )
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("ANALYTICS_ERROR", e.message, null)
        }
    }
}
