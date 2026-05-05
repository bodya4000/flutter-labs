import 'package:flutter/material.dart';

import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';
import 'package:unik_mobile/widgets/app_button.dart';
import 'package:unik_mobile/widgets/app_input.dart';

class DevicePinBarrier extends StatefulWidget {
  const DevicePinBarrier({required this.onUnlocked, super.key});

  final VoidCallback onUnlocked;

  @override
  State<DevicePinBarrier> createState() => _DevicePinBarrierState();
}

class _DevicePinBarrierState extends State<DevicePinBarrier> {
  final TextEditingController _pin = TextEditingController();
  String? _err;
  bool _busy = false;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final fmt = RegistrationValidator.validatePin(_pin.text);
    setState(() => _err = fmt);
    if (fmt != null) {
      return;
    }
    setState(() => _busy = true);
    final ok = await AppScope.devicePinVault.verifyPin(_pin.text);
    if (!mounted) {
      return;
    }
    setState(() => _busy = false);
    if (!ok) {
      setState(() => _err = 'Wrong PIN');
      return;
    }
    widget.onUnlocked();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.pageHorizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.s32),
                  Text('Device PIN', style: tt.headlineMedium),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    'Enter your PIN to continue',
                    style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
                  ),
                  const SizedBox(height: AppSpacing.s28),
                  AppInput(
                    label: 'PIN',
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    controller: _pin,
                    errorText: _err,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  AppButton(
                    label: _busy ? 'Checking…' : 'Unlock',
                    onPressed: _busy ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
