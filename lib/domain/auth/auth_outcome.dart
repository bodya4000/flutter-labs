final class AuthOutcome {
  const AuthOutcome._({this.errorMessage});

  final String? errorMessage;

  bool get isSuccess => errorMessage == null;

  static const AuthOutcome success = AuthOutcome._();

  factory AuthOutcome.failure(String message) =>
      AuthOutcome._(errorMessage: message);
}
