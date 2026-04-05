/// Event data for when a new user registers.
class RegistrationEvent {
  final int userId;
  final String userEmail;
  final String userFullName;
  final String clientId;

  /// Unix epoch timestamp (seconds) of the registration event.
  final int eventTimestamp;

  final int productId;
  final String ipAddress;
  final String userAgent;
  final String phoneNumber;

  const RegistrationEvent({
    required this.userId,
    required this.userEmail,
    required this.userFullName,
    required this.clientId,
    required this.eventTimestamp,
    required this.productId,
    required this.ipAddress,
    required this.userAgent,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userEmail': userEmail,
        'userFullName': userFullName,
        'clientId': clientId,
        'eventTimestamp': eventTimestamp,
        'productId': productId,
        'ipAddress': ipAddress,
        'userAgent': userAgent,
        'phoneNumber': phoneNumber,
      };
}
