## 1.0.20

* Bumped iOS `AdaptiveAnalytics` CocoaPod dependency pin to `~> 1.0.20`.
* Bumped Android native dependency pin to `adaptive-analytics:1.0.20`.

## 1.0.19

* Bumped iOS `AdaptiveAnalytics` CocoaPod dependency pin to `~> 1.0.19`.
* Bumped Android native dependency pin to `adaptive-analytics:1.0.19`.

## 1.0.12

* **`AdaptiveAnalytics.logUserPropertiesEvent`** – signature changed from the
  fixed `UserPropertiesEvent` model to `Map<String, dynamic>`. Pass any custom
  key–value pairs your integration needs. The `UserPropertiesEvent` Dart class
  has been removed.
* **`AdaptiveAnalytics.logAppLaunchEvent()`** – new method that fires an
  `app-launch` event. The native SDKs also fire this automatically on
  initialisation; call this manually only if you need an additional explicit
  trigger.
* **Android** – `logUserPropertiesEvent` handler in the Flutter plugin now
  forwards the raw map directly to the native SDK.
* **Android** – `InternalHttpClient` now logs a structured `→ REQUEST` /
  `← RESPONSE` block for every HTTP call. Gated by debug mode.
* **Android** – removed `mavenLocal()` from plugin build configuration.
* Bumped Android native dependency pin to `adaptive-analytics:1.0.11`.
* Bumped iOS `AdaptiveAnalytics` CocoaPod dependency pin to `~> 1.0.12`.

## 1.0.8

* Added `AdaptiveAnalytics.logUserPropertiesEvent` — log user profile properties (year, FCM token, user type, school language, registration date, parent ID).
* Fixed iOS plugin to receive numeric IDs as `Int` instead of `String` for all events.
* Updated iOS `logLoginEvent` and `logRegistrationEvent` to use proper enum mapping for `LoginMethod` and `UserType`.
* Added `logLoginEvent` and `logRegistrationEvent` handlers to the Android plugin.
* Moved iOS podspec to `ios/` directory and fixed `source_files` path.
* Pinned `AdaptiveAnalytics` CocoaPod dependency to `~> 1.0.10`.
* Lowered iOS minimum deployment target from 15.0 to 13.0.
* Fixed podspec `license` path to correctly reference `../LICENSE`.
* Fixed `MethodChannel` declaration to use `const` constructor.
* Sorted `dev_dependencies` alphabetically in `pubspec.yaml`.

## 1.0.7

* Added `AdaptiveAnalytics.logLoginEvent` — log user login events.
* Added `AdaptiveAnalytics.logRegistrationEvent` — log new user registration events.

## 1.0.6

* Added iOS platform support (iOS 15.0+).
* Fixed README package name references to use correct pub.dev package names.

## 1.0.0

* Initial release.
* `AdaptiveAnalytics.logGradeChangeEvent` — log grade change events.
* `AdaptiveAnalytics.logBadgeEarnedEvent` — log badge earned events.
* `AdaptiveAnalytics.logCourseEnrollmentEvent` — log course enrollment events.
* `AdaptiveAnalytics.logCourseCompletionEvent` — log course completion events.
* `AdaptiveAnalytics.logModuleCompletionEvent` — log module completion events.
* `AdaptiveAnalytics.logQuizSubmissionEvent` — log quiz submission events.
* `AdaptiveAnalytics.logAssignmentSubmissionEvent` — log assignment submission events.
* `AdaptiveAnalytics.logStudentInactivityEvent` — log student inactivity events.