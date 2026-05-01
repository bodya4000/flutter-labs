import 'package:flutter/material.dart';
import 'package:unik_mobile/screens/lab2/login_page.dart';
import 'package:unik_mobile/screens/lab2/register_page.dart';
import 'package:unik_mobile/theme/app_theme.dart';
import 'package:unik_mobile/widgets/app_button.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppButton(
          label: 'Edit Profile',
          variant: AppButtonVariant.secondary,
          onPressed: null,
        ),
        const SizedBox(height: AppSpacing.s12),
        AppButton(
          label: 'Go to Login',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const LoginPage(),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.s12),
        AppButton(
          label: 'Go to Register',
          variant: AppButtonVariant.secondary,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const RegisterPage(),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.s12),
        AppButton(
          label: 'Sign Out',
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
