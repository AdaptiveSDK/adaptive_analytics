/// Registration method used during sign-up.
enum RegistrationMethod {
  emailAndPassword,
  google,
  facebook,
  apple,
  x,
  phoneAndPassword;

  String toNativeString() => name
      .replaceAllMapped(
        RegExp(r'[A-Z]'),
        (m) => '_${m.group(0)}',
      )
      .toUpperCase();
}

/// User type for the registered account.
enum UserType {
  student,
  teacher,
  parent;

  String toNativeString() => name.toUpperCase();
}

/// Event data for when a new user registers.
class RegistrationEvent {
  final RegistrationMethod registrationMethod;
  final String userId;
  final String userName;
  final String userMobile;
  final UserType userType;

  const RegistrationEvent({
    required this.registrationMethod,
    required this.userId,
    required this.userName,
    required this.userMobile,
    required this.userType,
  });

  Map<String, dynamic> toMap() => {
    'registrationMethod': registrationMethod.toNativeString(),
    'userId': userId,
    'userName': userName,
    'userMobile': userMobile,
    'userType': userType.toNativeString(),
  };
}
