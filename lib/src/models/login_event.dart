/// Event data for when a user logs in.
class LoginEvent {
  final int userId;
  final String userEmail;
  final String userFullName;
  final String clientId;

  /// Unix epoch timestamp (seconds) of the login event.
  final int eventTimestamp;

  final String ipAddress;
  final String userAgent;
  final int productId;

  const LoginEvent({
    required this.userId,
    required this.userEmail,
    required this.userFullName,
    required this.clientId,
    required this.eventTimestamp,
    required this.ipAddress,
    required this.userAgent,
    required this.productId,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userEmail': userEmail,
        'userFullName': userFullName,
        'clientId': clientId,
        'eventTimestamp': eventTimestamp,
        'ipAddress': ipAddress,
        'userAgent': userAgent,
        'productId': productId,
      };
}
