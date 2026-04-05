/// Event data for when a user logs in.
class LoginEvent {
  final int userId;
  final String userEmail;
  final String userFullName;
  final int productId;

  const LoginEvent({
    required this.userId,
    required this.userEmail,
    required this.userFullName,
    required this.productId,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userEmail': userEmail,
        'userFullName': userFullName,
        'productId': productId,
      };
}
