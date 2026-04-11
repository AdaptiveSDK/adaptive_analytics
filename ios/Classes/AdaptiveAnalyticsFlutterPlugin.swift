import Flutter
import UIKit
import AdaptiveAnalytics

public class AdaptiveAnalyticsFlutterPlugin: NSObject, FlutterPlugin {

    private let analytics = AdaptiveAnalytics()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "adaptive_analytics",
            binaryMessenger: registrar.messenger()
        )
        let instance = AdaptiveAnalyticsFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any] ?? [:]
        switch call.method {

        case "logRegistrationEvent":
            guard let registrationMethod = args["registrationMethod"] as? String,
                  let userIdStr = args["userId"] as? String,
                  let userName = args["userName"] as? String,
                  let userMobile = args["userMobile"] as? String,
                  let userType = args["userType"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = RegistrationEvent(userId: Int(userIdStr) ?? 0, userType: userType == "parent" ? UserType.parent :userType == "teacher" ? UserType.teacher: UserType.student, userName: userName, registrationMethod: registrationMethod == "google" ? LoginMethod.google : registrationMethod == "x" ? LoginMethod.x : registrationMethod == "apple" ? LoginMethod.apple : registrationMethod == "facebook" ? LoginMethod.facebook : LoginMethod.emailAndPassword, userMobile: userMobile)
            Task { await analytics.logRegistrationEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logLoginEvent":
            guard let loginMethod = args["loginMethod"] as? String,
                  let userId = args["userId"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = LoginEvent(userId: Int(userId) ?? 0, loginMethod: loginMethod == "google" ? LoginMethod.google : loginMethod == "x" ? LoginMethod.x : loginMethod == "apple" ? LoginMethod.apple : loginMethod == "facebook" ? LoginMethod.facebook : LoginMethod.emailAndPassword)
            Task { await analytics.logLoginEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logUserPropertiesEvent":
            let data = args
            Task { await analytics.logUserPropertiesEvent(data: data); DispatchQueue.main.async { result(nil) } }

        case "logAppLaunchEvent":
            Task { DispatchQueue.main.async { result(nil) } }

        case "logCourseEnrollmentEvent":
            guard let courseIdStr         = args["courseId"]         as? Int,
                  let courseName          = args["courseName"]        as? String,
                  let enrollmentMethodStr = args["enrollmentMethod"]  as? String,
                  let roleName            = args["roleName"]          as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let enrollmentMethod: EnrollmentMethod = enrollmentMethodStr.uppercased() == "SELF" ? .selfEnrollment : .manualEnrollment
            let event = CourseEnrollmentEvent(courseId: courseIdStr, courseName: courseName, enrollmentMethod: enrollmentMethod, roleName: roleName)
            Task { await analytics.logCourseEnrollmentEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logCourseCompletionEvent":
            guard let courseIdStr = args["courseId"] as? Int,
                  let courseName  = args["courseName"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = CourseCompletionEvent(
                courseId:            courseIdStr,
                courseName:          courseName,
                finalGrade:          (args["finalGrade"]         as? NSNumber)?.doubleValue ?? 0.0,
                completionTimestamp: (args["completionTimestamp"] as? NSNumber)?.intValue   ?? 0
            )
            Task { await analytics.logCourseCompletionEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logModuleCompletionEvent":
            guard let courseIdStr = args["courseId"] as? Int,
                  let moduleIdStr = args["moduleId"] as? Int,
                  let courseName  = args["courseName"] as? String,
                  let moduleName  = args["moduleName"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let stateValue = (args["completionState"] as? NSNumber)?.intValue ?? 0
            let event = ModuleCompletionEvent(
                courseId:        courseIdStr,
                moduleId:        moduleIdStr,
                courseName:      courseName,
                moduleName:      moduleName,
                completionState: ModuleCompletionState(rawValue: stateValue) ?? .incomplete
            )
            Task { await analytics.logModuleCompletionEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logGradeChangeEvent":
            guard let courseIdStr      = args["courseId"]      as? Int,
                  let courseName       = args["courseName"]     as? String,
                  let gradeItemNameStr = args["gradeItemName"]  as? Int,
                  let statusStr        = args["status"]         as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = GradeChangeEvent(
                courseId:      courseIdStr,
                courseName:    courseName,
                previousGrade: (args["previousGrade"] as? NSNumber)?.doubleValue ?? 0.0,
                newGrade:      (args["newGrade"]      as? NSNumber)?.doubleValue ?? 0.0,
                maxGrade:      (args["maxGrade"]      as? NSNumber)?.doubleValue ?? 0.0,
                gradeItemName: gradeItemNameStr,
                status:        GradeStatus(rawValue: statusStr.lowercased()) ?? .success
            )
            Task { await analytics.logGradeChangeEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logQuizSubmissionEvent":
            guard let courseIdStr = args["courseId"] as? Int,
                  let courseName  = args["courseName"] as? String,
                  let quizIdStr   = args["quizId"]    as? Int,
                  let quizName    = args["quizName"]  as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = QuizSubmissionEvent(
                courseId:         courseIdStr,
                courseName:       courseName,
                quizId:           quizIdStr,
                quizName:         quizName,
                grade:            (args["grade"]            as? NSNumber)?.doubleValue ?? 0.0,
                maxGrade:         (args["maxGrade"]         as? NSNumber)?.doubleValue ?? 0.0,
                attemptNumber:    (args["attemptNumber"]    as? NSNumber)?.intValue    ?? 0,
                timeTakenSeconds: (args["timeTakenSeconds"] as? NSNumber)?.intValue    ?? 0
            )
            Task { await analytics.logQuizSubmissionEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logAssignmentSubmissionEvent":
            guard let courseIdStr         = args["courseId"]         as? Int,
                  let courseName          = args["courseName"]        as? String,
                  let assignmentIdStr     = args["assignmentId"]      as? Int,
                  let assignmentName      = args["assignmentName"]    as? String,
                  let submissionStatusStr = args["submissionStatus"]  as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = AssignmentSubmissionEvent(
                courseId:         courseIdStr,
                courseName:       courseName,
                assignmentId:     assignmentIdStr,
                assignmentName:   assignmentName,
                isLate:           args["isLate"]         as? Bool ?? false,
                attemptNumber:    (args["attemptNumber"]    as? NSNumber)?.intValue ?? 0,
                dueDateTimestamp: (args["dueDateTimestamp"] as? NSNumber)?.intValue ?? 0,
                submissionStatus: SubmissionStatus(rawValue: submissionStatusStr.lowercased()) ?? .submitted
            )
            Task { await analytics.logAssignmentSubmissionEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logBadgeEarnedEvent":
            guard let badgeName        = args["badgeName"]        as? String,
                  let badgeDescription = args["badgeDescription"] as? String,
                  let issuedBy         = args["issuedBy"]         as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = BadgeEarnedEvent(
                badgeId:          (args["badgeId"] as? NSNumber)?.intValue ?? 0,
                badgeName:        badgeName,
                badgeDescription: badgeDescription,
                issuedBy:         issuedBy
            )
            Task { await analytics.logBadgeEarnedEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logStudentInactivityEvent":
            guard let lastAccessedCourseIdStr = args["lastAccessedCourseId"] as? Int else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = StudentInactivityEvent(
                lastLoginTimestamp:   (args["lastLoginTimestamp"] as? NSNumber)?.intValue ?? 0,
                inactiveDays:         (args["inactiveDays"]       as? NSNumber)?.intValue ?? 0,
                lastAccessedCourseId: lastAccessedCourseIdStr
            )
            Task { await analytics.logStudentInactivityEvent(data: event); DispatchQueue.main.async { result(nil) } }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
