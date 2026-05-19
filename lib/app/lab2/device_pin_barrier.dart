import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/state/device_pin/device_pin_verify_cubit.dart';
import 'package:unik_mobile/widgets/app_button.dart';
import 'package:unik_mobile/widgets/app_input.dart';

class DevicePinBarrier extends StatelessWidget {
  const DevicePinBarrier({required this.onUnlocked, super.key});

  final VoidCallback onUnlocked;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DevicePinVerifyCubit(AppScope.devicePinVault),
      child: _DevicePinForm(onUnlocked: onUnlocked),
    );
  }
}

final class _DevicePinForm extends StatefulWidget {
  const _DevicePinForm({required this.onUnlocked});

  final VoidCallback onUnlocked;

  @override
  State<_DevicePinForm> createState() => _DevicePinFormState();
}

final class _DevicePinFormState extends State<_DevicePinForm> {
  final TextEditingController _pin = TextEditingController();

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final verdict = await context.read<DevicePinVerifyCubit>().tryUnlock(
      _pin.text,
    );
    if (!mounted) {
      return;
    }
    if (verdict != true) {
      return;
    }
    widget.onUnlocked();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return BlocBuilder<DevicePinVerifyCubit, DevicePinBarrierView>(
      builder: (context, view) => Scaffold(
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
                      errorText: view.errorHint,
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    AppButton(
                      label: view.busy ? 'Checking…' : 'Unlock',
                      onPressed: view.busy ? null : submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
