import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/domain/user/registered_user.dart';
import 'package:unik_mobile/screens/lab2/profile/profile_credentials_fields.dart';
import 'package:unik_mobile/state/profile_edit/profile_edit_cubit.dart';
import 'package:unik_mobile/state/session/session_cubit.dart';
import 'package:unik_mobile/widgets/app_button.dart';

abstract final class ProfileEditSheet {
  static Future<void> open(BuildContext context, RegisteredUser user) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetCtx) => BlocProvider(
        create: (_) => ProfileEditCubit(AppScope.authService),
        child: _ProfileEditHost(user: user),
      ),
    ).whenComplete(() {
      if (context.mounted) {
        context.read<SessionCubit>().syncFromAuthService();
      }
    });
  }
}

final class _ProfileEditHost extends StatefulWidget {
  const _ProfileEditHost({required this.user});

  final RegisteredUser user;

  @override
  State<_ProfileEditHost> createState() => _ProfileEditHostState();
}

final class _ProfileEditHostState extends State<_ProfileEditHost> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _nickname;
  late final TextEditingController _password;
  late final TextEditingController _confirm;

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _name = TextEditingController(text: u.fullName);
    _email = TextEditingController(text: u.email);
    _nickname = TextEditingController(text: u.nickname);
    _password = TextEditingController();
    _confirm = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _nickname.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.s24,
        right: AppSpacing.s24,
        top: AppSpacing.s24,
        bottom: bottomInset + AppSpacing.s24,
      ),
      child: BlocBuilder<ProfileEditCubit, ProfileEditUi>(
        builder: (context, ui) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit profile',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.s16),
                ProfileCredentialsFields(
                  nameController: _name,
                  emailController: _email,
                  nicknameController: _nickname,
                  passwordController: _password,
                  confirmController: _confirm,
                  nameError: ui.nameIssue,
                  emailError: ui.emailIssue,
                  nicknameError: ui.nicknameIssue,
                  passwordError: ui.passwordIssue,
                  confirmError: ui.confirmIssue,
                ),
                const SizedBox(height: AppSpacing.s24),
                AppButton(
                  label: ui.busy ? 'Saving…' : 'Save changes',
                  onPressed: ui.busy ? null : () => persist(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> persist(BuildContext outer) async {
    final cubit = outer.read<ProfileEditCubit>();
    final outcome = await cubit.saveDraft(
      fullName: _name.text,
      email: _email.text,
      nickname: _nickname.text,
      newPassword: _password.text,
      confirmNewPassword: _confirm.text,
    );
    if (!outer.mounted) {
      return;
    }
    if (outcome == 'validation') {
      return;
    }
    if (outcome != null) {
      AppToast.show(outer, outcome, variant: AppToastVariant.error);
      return;
    }
    Navigator.of(outer).pop();
  }
}
