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
            let event = RegistrationEvent(
                userId:       Int(args["userId"] as? String ?? "0") ?? 0,
                userEmail:    "",
                userFullName: args["userName"]   as? String ?? "",
                productId:    0,
                phoneNumber:  args["userMobile"] as? String ?? ""
            )
            Task { await analytics.logRegistrationEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logLoginEvent":
            let event = LoginEvent(
                userId:       Int(args["userId"] as? String ?? "0") ?? 0,
                userEmail:    "",
                userFullName: "",
                productId:    0
            )
            Task { await analytics.logLoginEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logUserPropertiesEvent":
            let event = UserPropertiesEvent(
                yearId:           (args["yearId"]           as? NSNumber)?.intValue ?? 0,
                fcmToken:          args["fcmToken"]          as? String ?? "",
                userType:          args["userType"]          as? String ?? "",
                schoolLangType:    args["schoolLangType"]    as? String ?? "",
                registrationDate: (args["registrationDate"]  as? NSNumber)?.intValue ?? 0,
                parentId:         (args["parentId"]          as? NSNumber)?.intValue ?? 0
            )
            Task { await analytics.logUserPropertiesEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logCourseEnrollmentEvent":
            guard let courseIdStr         = args["courseId"]         as? String,
                  let courseName          = args["courseName"]        as? String,
                  let enrollmentMethodStr = args["enrollmentMethod"]  as? String,
                  let roleName            = args["roleName"]          as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let enrollmentMethod: EnrollmentMethod = enrollmentMethodStr.uppercased() == "SELF" ? .selfEnrollment : .manualEnrollment
            let event = CourseEnrollmentEvent(courseId: Int(courseIdStr) ?? 0, courseName: courseName, enrollmentMethod: enrollmentMethod, roleName: roleName)
            Task { await analytics.logCourseEnrollmentEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logCourseCompletionEvent":
            guard let courseIdStr = args["courseId"] as? String,
                  let courseName  = args["courseName"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = CourseCompletionEvent(
                courseId:            Int(courseIdStr) ?? 0,
                courseName:          courseName,
                finalGrade:          (args["finalGrade"]         as? NSNumber)?.doubleValue ?? 0.0,
                completionTimestamp: (args["completionTimestamp"] as? NSNumber)?.intValue   ?? 0
            )
            Task { await analytics.logCourseCompletionEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logModuleCompletionEvent":
            guard let courseIdStr = args["courseId"] as? String,
                  let moduleIdStr = args["moduleId"] as? String,
                  let courseName  = args["courseName"] as? String,
                  let moduleName  = args["moduleName"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let stateValue = (args["completionState"] as? NSNumber)?.intValue ?? 0
            let event = ModuleCompletionEvent(
                courseId:        Int(courseIdStr) ?? 0,
                moduleId:        Int(moduleIdStr) ?? 0,
                courseName:      courseName,
                moduleName:      moduleName,
                completionState: ModuleCompletionState(rawValue: stateValue) ?? .incomplete
            )
            Task { await analytics.logModuleCompletionEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logGradeChangeEvent":
            guard let courseIdStr      = args["courseId"]      as? String,
                  let courseName       = args["courseName"]     as? String,
                  let gradeItemNameStr = args["gradeItemName"]  as? String,
                  let statusStr        = args["status"]         as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = GradeChangeEvent(
                courseId:      Int(courseIdStr)      ?? 0,
                courseName:    courseName,
                previousGrade: (args["previousGrade"] as? NSNumber)?.doubleValue ?? 0.0,
                newGrade:      (args["newGrade"]      as? NSNumber)?.doubleValue ?? 0.0,
                maxGrade:      (args["maxGrade"]      as? NSNumber)?.doubleValue ?? 0.0,
                gradeItemName: Int(gradeItemNameStr) ?? 0,
                status:        GradeStatus(rawValue: statusStr.lowercased()) ?? .success
            )
            Task { await analytics.logGradeChangeEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logQuizSubmissionEvent":
            guard let courseIdStr = args["courseId"] as? String,
                  let courseName  = args["courseName"] as? String,
                  let quizIdStr   = args["quizId"]    as? String,
                  let quizName    = args["quizName"]  as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = QuizSubmissionEvent(
                courseId:         Int(courseIdStr) ?? 0,
                courseName:       courseName,
                quizId:           Int(quizIdStr)  ?? 0,
                quizName:         quizName,
                grade:            (args["grade"]            as? NSNumber)?.doubleValue ?? 0.0,
                maxGrade:         (args["maxGrade"]         as? NSNumber)?.doubleValue ?? 0.0,
                attemptNumber:    (args["attemptNumber"]    as? NSNumber)?.intValue    ?? 0,
                timeTakenSeconds: (args["timeTakenSeconds"] as? NSNumber)?.intValue    ?? 0
            )
            Task { await analytics.logQuizSubmissionEvent(data: event); DispatchQueue.main.async { result(nil) } }

        case "logAssignmentSubmissionEvent":
            guard let courseIdStr         = args["courseId"]         as? String,
                  let courseName          = args["courseName"]        as? String,
                  let assignmentIdStr     = args["assignmentId"]      as? String,
                  let assignmentName      = args["assignmentName"]    as? String,
                  let submissionStatusStr = args["submissionStatus"]  as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = AssignmentSubmissionEvent(
                courseId:         Int(courseIdStr)      ?? 0,
                courseName:       courseName,
                assignmentId:     Int(assignmentIdStr)  ?? 0,
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
            guard let lastAccessedCourseIdStr = args["lastAccessedCourseId"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing required fields", details: nil)); return
            }
            let event = StudentInactivityEvent(
                lastLoginTimestamp:   (args["lastLoginTimestamp"] as? NSNumber)?.intValue ?? 0,
                inactiveDays:         (args["inactiveDays"]       as? NSNumber)?.intValue ?? 0,
                lastAccessedCourseId: Int(lastAccessedCourseIdStr) ?? 0
            )
            Task { await analytics.logStudentInactivityEvent(data: event); DispatchQueue.main.async { result(nil) } }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
