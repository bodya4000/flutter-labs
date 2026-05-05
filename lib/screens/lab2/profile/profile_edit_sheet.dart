import 'package:flutter/material.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';
import 'package:unik_mobile/widgets/app_button.dart';
import 'package:unik_mobile/widgets/app_input.dart';

class ProfileEditSheet extends StatefulWidget {
  const ProfileEditSheet({
    required this.initialFullName,
    required this.initialEmail,
    super.key,
  });

  final String initialFullName;
  final String initialEmail;

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialFullName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nameErr = RegistrationValidator.validateFullName(
      _nameController.text,
    );
    final emailErr = RegistrationValidator.validateEmail(_emailController.text);
    final pwdErr = RegistrationValidator.validateOptionalNewPassword(
      newPassword: _passwordController.text,
      confirmNewPassword: _confirmController.text,
    );
    setState(() {
      _nameError = nameErr;
      _emailError = emailErr;
      _passwordError = pwdErr;
      _confirmError = pwdErr;
    });
    if (nameErr != null || emailErr != null || pwdErr != null) {
      return;
    }
    setState(() => _busy = true);
    final outcome = await AppScope.authService.updateProfile(
      fullName: _nameController.text,
      email: _emailController.text,
      newPassword: _passwordController.text,
      confirmNewPassword: _confirmController.text,
    );
    if (!mounted) {
      return;
    }
    setState(() => _busy = false);
    if (!outcome.isSuccess) {
      AppToast.show(
        context,
        outcome.errorMessage ?? 'Update failed',
        variant: AppToastVariant.error,
      );
      return;
    }
    Navigator.of(context).pop();
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Edit profile', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.s16),
            AppInput(
              label: 'Full Name',
              controller: _nameController,
              errorText: _nameError,
            ),
            const SizedBox(height: AppSpacing.s16),
            AppInput(
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              errorText: _emailError,
            ),
            const SizedBox(height: AppSpacing.s16),
            AppInput(
              label: 'New password (optional)',
              obscureText: true,
              controller: _passwordController,
              errorText: _passwordError,
            ),
            const SizedBox(height: AppSpacing.s16),
            AppInput(
              label: 'Confirm new password',
              obscureText: true,
              controller: _confirmController,
              errorText: _confirmError,
            ),
            const SizedBox(height: AppSpacing.s24),
            AppButton(
              label: _busy ? 'Saving…' : 'Save changes',
              onPressed: _busy ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}
