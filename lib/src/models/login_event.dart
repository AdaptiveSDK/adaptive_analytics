/// Login method used when signing in.
enum LoginMethod {
  emailAndPassword,
  google,
  facebook,
  apple,
  x,
  phoneAndPassword;

  String toNativeString() => name
      .replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m.group(0)}')
      .toUpperCase();
}

/// Event data for when a user logs in.
class LoginEvent {
  final LoginMethod loginMethod;
  final String userId;

  const LoginEvent({required this.loginMethod, required this.userId});

  Map<String, dynamic> toMap() => {
    'loginMethod': loginMethod.toNativeString(),
    'userId': userId,
  };
}
