final class RegisteredUser {
  const RegisteredUser({
    required this.fullName,
    required this.email,
    required this.passwordHash,
    required this.salt,
    this.nickname = '',
    this.accessToken,
  });

  final String fullName;
  final String email;
  final String nickname;
  final String passwordHash;
  final String salt;
  final String? accessToken;

  Map<String, Object?> toJson() => <String, Object?>{
    'fullName': fullName,
    'email': email,
    'nickname': nickname,
    'passwordHash': passwordHash,
    'salt': salt,
    'accessToken': accessToken,
  };

  factory RegisteredUser.fromJson(Map<String, Object?> json) {
    return RegisteredUser(
      fullName: json['fullName']! as String,
      email: json['email']! as String,
      nickname: json['nickname'] as String? ?? '',
      passwordHash: json['passwordHash'] as String? ?? '',
      salt: json['salt'] as String? ?? '',
      accessToken: json['accessToken'] as String?,
    );
  }

  RegisteredUser clearAccessToken() {
    return RegisteredUser(
      fullName: fullName,
      email: email,
      nickname: nickname,
      passwordHash: passwordHash,
      salt: salt,
    );
  }

  RegisteredUser copyWith({
    String? fullName,
    String? email,
    String? nickname,
    String? passwordHash,
    String? salt,
    String? accessToken,
  }) {
    return RegisteredUser(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
