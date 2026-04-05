package com.adaptive.analytics

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
import com.adaptive.analytics.events.LoginEvent
import com.adaptive.analytics.events.ModuleCompletionEvent
import com.adaptive.analytics.events.ModuleCompletionState
import com.adaptive.analytics.events.QuizSubmissionEvent
import com.adaptive.analytics.events.RegistrationEvent
import com.adaptive.analytics.events.StudentInactivityEvent
import com.adaptive.analytics.events.SubmissionStatus
import com.adaptive.analytics.events.UserPropertiesEvent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** Flutter plugin that bridges the Adaptive Analytics Android SDK. */
class AdaptiveAnalyticsFlutterPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel

    // ── FlutterPlugin ─────────────────────────────────────────────────────────

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "adaptive_analytics")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    /** Safely reads a numeric argument as Double regardless of whether Flutter
     *  encoded it as INT32, INT64, or FLOAT64. */
    private fun MethodCall.double(key: String): Double =
        (argument<Any>(key) as Number).toDouble()

    /** Safely reads a numeric argument as Long regardless of whether Flutter
     *  encoded it as INT32 or INT64 (timestamps, etc.). */
    private fun MethodCall.long(key: String): Long =
        (argument<Any>(key) as Number).toLong()

    /** Safely reads a numeric argument as Int. */
    private fun MethodCall.int(key: String): Int =
        (argument<Any>(key) as Number).toInt()

    // ── MethodCallHandler ─────────────────────────────────────────────────────

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "logRegistrationEvent" -> {
                    AdaptiveAnalytics.logRegistrationEvent(
                        RegistrationEvent(
                            userId       = call.argument("userId")!!,
                            userEmail    = call.argument("userEmail")!!,
                            userFullName = call.argument("userFullName")!!,
                            productId    = call.int("productId"),
                            phoneNumber  = call.argument("phoneNumber")!!,
                        )
                    )
                    result.success(null)
                }

                "logLoginEvent" -> {
                    AdaptiveAnalytics.logLoginEvent(
                        LoginEvent(
                            userId       = call.argument("userId")!!,
                            userEmail    = call.argument("userEmail")!!,
                            userFullName = call.argument("userFullName")!!,
                            productId    = call.int("productId"),
                        )
                    )
                    result.success(null)
                }

                "logUserPropertiesEvent" -> {
                    AdaptiveAnalytics.logUserPropertiesEvent(
                        UserPropertiesEvent(
                            yearId          = call.int("yearId"),
                            fcmToken        = call.argument("fcmToken")!!,
                            userType        = call.argument("userType")!!,
                            schoolLangType  = call.argument("schoolLangType")!!,
                            registrationDate= call.long("registrationDate"),
                            parentId        = call.int("parentId"),
                        )
                    )
                    result.success(null)
                }

                "logGradeChangeEvent" -> {
                    AdaptiveAnalytics.logGradeChangeEvent(
                        GradeChangeEvent(
                            courseId = call.argument("courseId")!!,
                            courseName = call.argument("courseName")!!,
                            previousGrade = call.double("previousGrade"),
                            newGrade = call.double("newGrade"),
                            maxGrade = call.double("maxGrade"),
                            gradeItemName = call.argument("gradeItemName")!!,
                            status = GradeStatus.valueOf(call.argument("status")!!),
                        )
                    )
                    result.success(null)
                }

                "logStudentInactivityEvent" -> {
                    AdaptiveAnalytics.logStudentInactivityEvent(
                        StudentInactivityEvent(
                            lastLoginTimestamp = call.int("lastLoginTimestamp"),
                            inactiveDays = call.int("inactiveDays"),
                            lastAccessedCourseId = call.argument("lastAccessedCourseId")!!,
                        )
                    )
                    result.success(null)
                }

                "logModuleCompletionEvent" -> {
                    val stateValue = call.int("completionState")
                    val state = ModuleCompletionState.entries.firstOrNull { it.ordinal == stateValue }
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
                            badgeId = call.int("badgeId"),
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

                "logCourseCompletionEvent" -> {
                    // logCourseCompletionEvent is not available in adaptive-analytics:1.0.0
                    result.notImplemented()
                }

                "logAssignmentSubmissionEvent" -> {
                    AdaptiveAnalytics.logAssignmentSubmissionEvent(
                        AssignmentSubmissionEvent(
                            courseId = call.argument("courseId")!!,
                            courseName = call.argument("courseName")!!,
                            assignmentId = call.argument("assignmentId")!!,
                            assignmentName = call.argument("assignmentName")!!,
                            isLate = call.argument("isLate")!!,
                            attemptNumber = call.int("attemptNumber"),
                            dueDateTimestamp = call.int("dueDateTimestamp"),
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
                            grade = call.double("grade"),
                            maxGrade = call.double("maxGrade"),
                            attemptNumber = call.int("attemptNumber"),
                            timeTakenSeconds = call.int("timeTakenSeconds"),
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

