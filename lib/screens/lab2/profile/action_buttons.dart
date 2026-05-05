import 'package:flutter/material.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/navigation/lab2_navigation.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/widgets/app_button.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    required this.onEditProfile,
    required this.onDeleteAccount,
    super.key,
  });

  final VoidCallback onEditProfile;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          label: 'Edit Profile',
          variant: AppButtonVariant.secondary,
          onPressed: onEditProfile,
        ),
        const SizedBox(height: AppSpacing.s12),
        AppButton(
          label: 'Sign Out',
          variant: AppButtonVariant.ghost,
          onPressed: () async {
            await AppScope.authService.logout();
            if (!context.mounted) {
              return;
            }
            Lab2Navigation.restartAuthFlow(context);
          },
        ),
        const SizedBox(height: AppSpacing.s12),
        AppButton(
          label: 'Delete Account',
          variant: AppButtonVariant.secondary,
          onPressed: onDeleteAccount,
        ),
      ],
    );
  }
}
