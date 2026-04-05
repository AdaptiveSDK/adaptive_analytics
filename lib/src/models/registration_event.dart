/// Event data for when a new user registers.
class RegistrationEvent {
  final int userId;
  final String userEmail;
  final String userFullName;
  final int productId;
  final String phoneNumber;

  const RegistrationEvent({
    required this.userId,
    required this.userEmail,
    required this.userFullName,
    required this.productId,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userEmail': userEmail,
        'userFullName': userFullName,
        'productId': productId,
        'phoneNumber': phoneNumber,
      };
}
