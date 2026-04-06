/// Event data for a user's profile properties.
///
/// Field names are camelCase here; the native SDKs handle snake_case JSON
/// serialisation internally (via Gson @SerializedName / Swift CodingKeys).
class UserPropertiesEvent {
  final int yearId;
  final String fcmToken;
  final String userType;
  final String schoolLangType;

  /// Unix epoch timestamp (seconds) of the user's registration date.
  final int registrationDate;

  final int parentId;

  const UserPropertiesEvent({
    required this.yearId,
    required this.fcmToken,
    required this.userType,
    required this.schoolLangType,
    required this.registrationDate,
    required this.parentId,
  });

  Map<String, dynamic> toMap() => {
    'yearId': yearId,
    'fcmToken': fcmToken,
    'userType': userType,
    'schoolLangType': schoolLangType,
    'registrationDate': registrationDate,
    'parentId': parentId,
  };
}
