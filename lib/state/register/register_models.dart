final class RegisterFieldErrors {
  const RegisterFieldErrors({
    this.name,
    this.email,
    this.nickname,
    this.password,
    this.confirm,
  });

  final String? name;
  final String? email;
  final String? nickname;
  final String? password;
  final String? confirm;

  static const RegisterFieldErrors empty = RegisterFieldErrors();

  bool get hasAny =>
      name != null ||
      email != null ||
      nickname != null ||
      password != null ||
      confirm != null;
}

sealed class RegisterEnd {}

final class RegisterEndOffline extends RegisterEnd {}

final class RegisterEndValidation extends RegisterEnd {
  RegisterEndValidation(this.errors);
  final RegisterFieldErrors errors;
}

final class RegisterEndSuccess extends RegisterEnd {}

final class RegisterEndFailure extends RegisterEnd {
  RegisterEndFailure(this.message);
  final String message;
}

final class RegisterRunning {
  RegisterRunning({
    required this.busy,
    this.lastErrors = RegisterFieldErrors.empty,
  });
  final bool busy;
  final RegisterFieldErrors lastErrors;
}
