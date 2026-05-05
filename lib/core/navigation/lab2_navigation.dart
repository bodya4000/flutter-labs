import 'package:flutter/material.dart';
import 'package:unik_mobile/core/navigation/lab2_auth_gate.dart';

abstract final class Lab2Navigation {
  static void restartAuthFlow(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const Lab2AuthGate()),
      (route) => route.isFirst,
    );
  }
}
