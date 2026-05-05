import 'package:flutter/material.dart';

import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';

abstract final class ProfilePinDialogs {
  static Future<void> askSet(BuildContext outer) async {
    final pin1 = TextEditingController();
    final pin2 = TextEditingController();
    final saved = await showDialog<bool>(
      context: outer,
      builder: (ctx) {
        String? err1;
        String? err2;
        return StatefulBuilder(
          builder: (context, setLocal) => AlertDialog(
            title: const Text('Set device PIN'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: pin1,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'PIN',
                    errorText: err1,
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                TextField(
                  controller: pin2,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm PIN',
                    errorText: err2,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final format = RegistrationValidator.validatePin(pin1.text);
                  final match = pin1.text.trim() == pin2.text.trim();
                  setLocal(() {
                    err1 = format;
                    err2 =
                        match ? null : 'PINs do not match';
                  });
                  if (format != null || !match) {
                    return;
                  }
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
    if (saved == true) {
      await AppScope.devicePinVault.setPinFromPlain(pin1.text);
    }
    pin1.dispose();
    pin2.dispose();
  }

  static Future<String?> askRemove(BuildContext outer) async {
    final pin = TextEditingController();
    final res = await showDialog<String?>(
      context: outer,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove PIN'),
        content: TextField(
          controller: pin,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Current PIN'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final good = await AppScope.devicePinVault.verifyPin(pin.text);
              if (!ctx.mounted) {
                return;
              }
              Navigator.of(ctx).pop(good ? 'ok' : 'bad');
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    pin.dispose();
    return res;
  }
}
