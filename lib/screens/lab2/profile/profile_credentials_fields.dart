import 'package:flutter/material.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/widgets/app_input.dart';

class ProfileCredentialsFields extends StatelessWidget {
  const ProfileCredentialsFields({
    required this.nameController,
    required this.emailController,
    required this.nicknameController,
    required this.passwordController,
    required this.confirmController,
    required this.nameError,
    required this.emailError,
    required this.nicknameError,
    required this.passwordError,
    required this.confirmError,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController nicknameController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;

  final String? nameError;
  final String? emailError;
  final String? nicknameError;
  final String? passwordError;
  final String? confirmError;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppInput(
          label: 'Full Name',
          controller: nameController,
          errorText: nameError,
        ),
        const SizedBox(height: AppSpacing.s16),
        AppInput(
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          errorText: emailError,
        ),
        const SizedBox(height: AppSpacing.s16),
        AppInput(
          label: 'Nickname (optional)',
          controller: nicknameController,
          errorText: nicknameError,
        ),
        const SizedBox(height: AppSpacing.s16),
        AppInput(
          label: 'New password (optional)',
          obscureText: true,
          controller: passwordController,
          errorText: passwordError,
        ),
        const SizedBox(height: AppSpacing.s16),
        AppInput(
          label: 'Confirm new password',
          obscureText: true,
          controller: confirmController,
          errorText: confirmError,
        ),
      ],
    );
  }
}
