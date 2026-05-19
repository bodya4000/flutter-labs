import 'package:flutter/material.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/widgets/app_button.dart';
import 'package:unik_mobile/widgets/app_input.dart';

List<Widget> registerAccountInputs({
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController nicknameController,
  required TextEditingController passwordController,
  required TextEditingController confirmController,
  required String? nameError,
  required String? emailError,
  required String? nicknameError,
  required String? passwordError,
  required String? confirmError,
  required bool busy,
  required VoidCallback onSubmit,
  required VoidCallback onBack,
}) {
  return [
    const SizedBox(height: AppSpacing.s16),
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
      label: 'Password',
      obscureText: true,
      controller: passwordController,
      errorText: passwordError,
    ),
    const SizedBox(height: AppSpacing.s16),
    AppInput(
      label: 'Confirm Password',
      obscureText: true,
      controller: confirmController,
      errorText: confirmError,
    ),
    const SizedBox(height: AppSpacing.s28),
    AppButton(
      label: busy ? 'Creating…' : 'Register',
      onPressed: busy ? null : onSubmit,
    ),
    const SizedBox(height: AppSpacing.s12),
    AppButton(
      label: 'Back to Sign In',
      variant: AppButtonVariant.ghost,
      onPressed: busy ? null : onBack,
    ),
    const SizedBox(height: AppSpacing.s24),
  ];
}
