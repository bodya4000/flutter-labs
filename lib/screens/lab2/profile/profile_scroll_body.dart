import 'package:flutter/material.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/domain/user/registered_user.dart';
import 'package:unik_mobile/screens/lab2/profile/action_buttons.dart';
import 'package:unik_mobile/screens/lab2/profile/identity_header.dart';
import 'package:unik_mobile/screens/lab2/profile/profile_edit_sheet.dart';
import 'package:unik_mobile/screens/lab2/profile/profile_pin_card.dart';
import 'package:unik_mobile/screens/lab2/profile/profile_torch_card.dart';
import 'package:unik_mobile/screens/lab2/profile/stats_row.dart';
import 'package:unik_torch/unik_torch.dart';

final class ProfileScrollBody extends StatefulWidget {
  const ProfileScrollBody({
    required this.user,
    required this.onDeleteAccount,
    super.key,
  });

  final RegisteredUser user;
  final VoidCallback onDeleteAccount;

  @override
  State<ProfileScrollBody> createState() => _ProfileScrollBodyState();
}

final class _ProfileScrollBodyState extends State<ProfileScrollBody> {
  bool _torchLit = false;
  bool _torchBusy = false;

  Future<void> _notice(
    BuildContext context,
    String title,
    String message,
  ) async {
    if (!context.mounted) {
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _applyTorch(BuildContext context, bool wantOn) async {
    if (_torchBusy) {
      return;
    }
    setState(() => _torchBusy = true);
    try {
      try {
        if (wantOn) {
          await UnikTorch.onLight();
        } else {
          await UnikTorch.offLight();
        }
        if (context.mounted) {
          setState(() => _torchLit = wantOn);
        }
      } on UnikTorchUnsupportedPlatform {
        if (!context.mounted) {
          return;
        }
        await _notice(
          context,
          'Not available',
          'The flashlight works on iPhone and '
              'Android devices only.',
        );
      } on UnikTorchUnavailable {
        if (!context.mounted) {
          return;
        }
        await _notice(
          context,
          'Torch',
          'Could not use the camera light on this device. '
              'On Android, allow Camera permission.',
        );
      }
    } finally {
      if (context.mounted) {
        setState(() => _torchBusy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void openSheet() => ProfileEditSheet.open(context, widget.user);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              IdentityHeader(
                fullName: widget.user.fullName,
                email: widget.user.email,
                nickname: widget.user.nickname,
                onAvatarLongPress: () => _applyTorch(context, !_torchLit),
              ),
              const SizedBox(height: AppSpacing.s24),
              ProfileTorchCard(
                lit: _torchLit,
                busy: _torchBusy,
                onChanged: (v) => _applyTorch(context, v),
              ),
              const SizedBox(height: AppSpacing.s24),
              const ProfilePinCard(),
              const SizedBox(height: AppSpacing.s32),
              const StatsRow(),
              const SizedBox(height: AppSpacing.s32),
              ActionButtons(
                onEditProfile: openSheet,
                onDeleteAccount: widget.onDeleteAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
