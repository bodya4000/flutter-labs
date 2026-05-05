import 'package:flutter/material.dart';
import 'package:unik_mobile/app/lab2/login.dart';
import 'package:unik_mobile/app/lab2/page.dart';
import 'package:unik_mobile/core/config/app_scope.dart';

class Lab2AuthGate extends StatefulWidget {
  const Lab2AuthGate({super.key});

  @override
  State<Lab2AuthGate> createState() => _Lab2AuthGateState();
}

class _Lab2AuthGateState extends State<Lab2AuthGate> {
  late final Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = AppScope.authService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data ?? false) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}
