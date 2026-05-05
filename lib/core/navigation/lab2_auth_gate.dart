import 'package:flutter/material.dart';

import 'package:unik_mobile/app/lab2/device_pin_barrier.dart';
import 'package:unik_mobile/app/lab2/login.dart';
import 'package:unik_mobile/app/lab2/page.dart';
import 'package:unik_mobile/core/config/app_scope.dart';

class Lab2AuthGate extends StatefulWidget {
  const Lab2AuthGate({super.key});

  @override
  State<Lab2AuthGate> createState() => _Lab2AuthGateState();
}

class _Lab2AuthGateState extends State<Lab2AuthGate> {
  late Future<({bool loggedIn, bool online, bool pinActive})> _future;
  bool _pinPassed = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<({bool loggedIn, bool online, bool pinActive})> _load() async {
    final loggedIn = await AppScope.authService.isLoggedIn();
    final online = await AppScope.connectivity.checkOnline();
    final pinActive = await AppScope.devicePinVault.hasConfiguredPin();
    return (loggedIn: loggedIn, online: online, pinActive: pinActive);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!data.loggedIn) {
          return const LoginPage();
        }
        final needPin = data.pinActive && !_pinPassed;
        if (needPin) {
          return DevicePinBarrier(
            onUnlocked: () => setState(() => _pinPassed = true),
          );
        }
        return HomePage(warnOfflineOnOpen: !data.online);
      },
    );
  }
}
