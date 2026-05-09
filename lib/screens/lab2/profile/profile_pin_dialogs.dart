import 'package:flutter/material.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';

abstract final class ProfilePinDialogs {
  static Future<String?> readConfirmedNewPin(BuildContext outer) async {
    final pin1 = TextEditingController();
    final pin2 = TextEditingController();
    final pin = await showDialog<String?>(
      context: outer,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setLocal) {
          String? err1;
          String? err2;
          return AlertDialog(
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
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final format = RegistrationValidator.validatePin(pin1.text);
                  final match = pin1.text.trim() == pin2.text.trim();
                  setLocal(() {
                    err1 = format;
                    err2 = match ? null : 'PINs do not match';
                  });
                  if (format != null || !match) {
                    return;
                  }
                  Navigator.of(dialogCtx).pop(pin1.text.trim());
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
    pin1.dispose();
    pin2.dispose();
    return pin;
  }

  static Future<String?> readCurrentPinGuess(BuildContext outer) async {
    final pinCtl = TextEditingController();
    final pin = await showDialog<String?>(
      context: outer,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Remove PIN'),
        content: TextField(
          controller: pinCtl,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Current PIN'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(pinCtl.text.trim()),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    pinCtl.dispose();
    return pin;
  }
}
