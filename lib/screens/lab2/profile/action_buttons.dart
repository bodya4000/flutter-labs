import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/core/navigation/lab2_navigation.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/state/session/session_cubit.dart';
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
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Sign out'),
                content: const Text(
                  'Are you sure you want to leave this session?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            );
            if (ok != true || !context.mounted) {
              return;
            }
            await context.read<SessionCubit>().signOutAndDisconnectMqtt();
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
