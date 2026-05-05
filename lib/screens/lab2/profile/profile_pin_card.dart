import 'package:flutter/material.dart';

import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/screens/lab2/profile/profile_pin_dialogs.dart';
import 'package:unik_mobile/widgets/app_button.dart';
import 'package:unik_mobile/widgets/app_card.dart';

class ProfilePinCard extends StatefulWidget {
  const ProfilePinCard({super.key});

  @override
  State<ProfilePinCard> createState() => _ProfilePinCardState();
}

class _ProfilePinCardState extends State<ProfilePinCard> {
  bool? _on;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final v = await AppScope.devicePinVault.hasConfiguredPin();
    if (!mounted) {
      return;
    }
    setState(() => _on = v);
  }

  Future<void> _onSet() async {
    await ProfilePinDialogs.askSet(context);
    await _refresh();
  }

  Future<void> _onClear() async {
    final tag = await ProfilePinDialogs.askRemove(context);
    if (!mounted) {
      return;
    }
    if (tag == 'ok') {
      await AppScope.devicePinVault.clearPin();
      if (!mounted) {
        return;
      }
      AppToast.show(
        context,
        'PIN removed',
        variant: AppToastVariant.success,
      );
    } else if (tag == 'bad') {
      AppToast.show(
        context,
        'Wrong PIN',
        variant: AppToastVariant.error,
      );
    }
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final on = _on;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Device PIN', style: tt.titleMedium),
          const SizedBox(height: AppSpacing.s4),
          Text(
            'When set, you enter it after sign-in to open the dashboard.',
            style: tt.bodySmall?.copyWith(color: AppTheme.muted),
          ),
          const SizedBox(height: AppSpacing.s16),
          if (on == null)
            const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (on)
            AppButton(
              label: 'Remove PIN',
              variant: AppButtonVariant.ghost,
              onPressed: _onClear,
            )
          else
            AppButton(
              label: 'Set PIN',
              onPressed: _onSet,
            ),
        ],
      ),
    );
  }
}
