final class RegisteredUser {
  const RegisteredUser({
    required this.fullName,
    required this.email,
    required this.passwordHash,
    required this.salt,
  });

  final String fullName;
  final String email;
  final String passwordHash;
  final String salt;

  Map<String, Object?> toJson() => <String, Object?>{
    'fullName': fullName,
    'email': email,
    'passwordHash': passwordHash,
    'salt': salt,
  };

  factory RegisteredUser.fromJson(Map<String, Object?> json) {
    return RegisteredUser(
      fullName: json['fullName']! as String,
      email: json['email']! as String,
      passwordHash: json['passwordHash']! as String,
      salt: json['salt']! as String,
    );
  }

  RegisteredUser copyWith({
    String? fullName,
    String? email,
    String? passwordHash,
    String? salt,
  }) {
    return RegisteredUser(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
    );
  }
}
