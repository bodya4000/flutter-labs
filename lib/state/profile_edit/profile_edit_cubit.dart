import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/domain/auth/auth_service.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';

final class ProfileEditUi {
  const ProfileEditUi({
    required this.busy,
    this.nameIssue,
    this.emailIssue,
    this.nicknameIssue,
    this.passwordIssue,
    this.confirmIssue,
  });

  final bool busy;
  final String? nameIssue;
  final String? emailIssue;
  final String? nicknameIssue;
  final String? passwordIssue;
  final String? confirmIssue;

  static const ProfileEditUi idle = ProfileEditUi(busy: false);

  ProfileEditUi copyIssues({
    String? nameIssue,
    String? emailIssue,
    String? nicknameIssue,
    String? passwordIssue,
    String? confirmIssue,
  }) => ProfileEditUi(
    busy: busy,
    nameIssue: nameIssue,
    emailIssue: emailIssue,
    nicknameIssue: nicknameIssue,
    passwordIssue: passwordIssue,
    confirmIssue: confirmIssue,
  );
}

final class ProfileEditCubit extends Cubit<ProfileEditUi> {
  ProfileEditCubit(this._auth) : super(ProfileEditUi.idle);

  final AuthService _auth;

  Future<String?> saveDraft({
    required String fullName,
    required String email,
    required String nickname,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final nickErr = RegistrationValidator.firstOf([
      if (nickname.trim().isNotEmpty)
        RegistrationValidator.validateNickname(nickname),
    ]);
    final nameErr = RegistrationValidator.validateFullName(fullName);
    final emailErr = RegistrationValidator.validateEmail(email);
    final pwdErr = RegistrationValidator.validateOptionalNewPassword(
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
    emit(
      ProfileEditUi.idle.copyIssues(
        nameIssue: nameErr,
        emailIssue: emailErr,
        nicknameIssue: nickErr,
        passwordIssue: pwdErr,
        confirmIssue: pwdErr,
      ),
    );
    final invalid =
        nameErr != null ||
        emailErr != null ||
        nickErr != null ||
        pwdErr != null;
    if (invalid) {
      return 'validation';
    }
    emit(const ProfileEditUi(busy: true));
    final outcome = await _auth.updateProfile(
      fullName: fullName,
      email: email,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
      nickname: nickname,
    );
    emit(ProfileEditUi.idle);
    if (!outcome.isSuccess) {
      return outcome.errorMessage ?? 'Update failed';
    }
    return null;
  }
}
