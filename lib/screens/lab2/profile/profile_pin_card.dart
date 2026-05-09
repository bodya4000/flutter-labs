import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/screens/lab2/profile/profile_pin_dialogs.dart';
import 'package:unik_mobile/state/profile_pin/profile_pin_cubit.dart';
import 'package:unik_mobile/widgets/app_button.dart';
import 'package:unik_mobile/widgets/app_card.dart';

class ProfilePinCard extends StatelessWidget {
  const ProfilePinCard({super.key});

  Future<void> _tapSet(BuildContext context) async {
    final confirmed = await ProfilePinDialogs.readConfirmedNewPin(context);
    if (!context.mounted || confirmed == null) {
      return;
    }
    final err = await context.read<ProfilePinCubit>().finalizePlainPin(
      confirmed,
    );
    if (!context.mounted) {
      return;
    }
    if (err != null) {
      AppToast.show(context, err, variant: AppToastVariant.error);
    }
  }

  Future<void> _tapRemove(BuildContext context) async {
    final guess = await ProfilePinDialogs.readCurrentPinGuess(context);
    if (!context.mounted || guess == null || guess.isEmpty) {
      return;
    }
    final res = await context.read<ProfilePinCubit>().tryRemoveVerified(guess);
    if (!context.mounted) {
      return;
    }
    switch (res) {
      case ProfilePinRemovalResult.badPin:
        AppToast.show(context, 'Wrong PIN', variant: AppToastVariant.error);
      case ProfilePinRemovalResult.cleared:
        AppToast.show(context, 'PIN removed', variant: AppToastVariant.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return BlocBuilder<ProfilePinCubit, ProfilePinChip>(
      builder: (context, chip) {
        final on = chip.pinOn;
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Device PIN', style: tt.titleMedium),
              const SizedBox(height: AppSpacing.s4),
              Text(
                'When set, you enter it after sign-in '
                'to open the dashboard.',
                style: tt.bodySmall?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: AppSpacing.s16),
              if (chip.busyProbe)
                const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else if (on == true)
                AppButton(
                  label: 'Remove PIN',
                  variant: AppButtonVariant.ghost,
                  onPressed: () => _tapRemove(context),
                )
              else
                AppButton(label: 'Set PIN', onPressed: () => _tapSet(context)),
            ],
          ),
        );
      },
    );
  }
}
