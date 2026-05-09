import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/app/lab2/device_pin_barrier.dart';
import 'package:unik_mobile/app/lab2/login.dart';
import 'package:unik_mobile/app/lab2/page.dart';
import 'package:unik_mobile/state/app_registry.dart';
import 'package:unik_mobile/state/auth_gate/auth_gate_cubit.dart';
import 'package:unik_mobile/state/auth_gate/auth_gate_view_state.dart';

class Lab2AuthGate extends StatelessWidget {
  const Lab2AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthGateCubit()..bootstrap(),
      child: BlocConsumer<AuthGateCubit, AuthGateViewState>(
        listenWhen: (p, c) =>
            p.phase != c.phase && c.phase != AuthGatePhase.loading,
        listener: (_, _) => GlobalSession.cubit.syncFromAuthService(),
        builder: (context, s) {
          switch (s.phase) {
            case AuthGatePhase.loading:
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            case AuthGatePhase.login:
              return const LoginPage();
            case AuthGatePhase.pin:
              return DevicePinBarrier(
                onUnlocked: () => context.read<AuthGateCubit>().onPinUnlocked(),
              );
            case AuthGatePhase.home:
              return HomePage(warnOfflineOnOpen: s.warnOfflineDashboard);
          }
        },
      ),
    );
  }
}
