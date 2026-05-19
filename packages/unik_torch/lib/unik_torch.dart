import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

final class UnikTorchUnsupportedPlatform implements Exception {}

final class UnikTorchUnavailable implements Exception {}

abstract final class UnikTorch {
  static const MethodChannel _channel = MethodChannel('unik_torch/channel');

  static Future<void> onLight() async {
    await _invokeTorch(wantOn: true);
  }

  static Future<void> offLight() async {
    await _invokeTorch(wantOn: false);
  }

  static Future<void> _invokeTorch({required bool wantOn}) async {
    _ensureMobileOs();
    final ok = await _channel.invokeMethod<bool>(wantOn ? 'turnOn' : 'turnOff');
    if (ok != true) {
      throw UnikTorchUnavailable();
    }
  }

  static void _ensureMobileOs() {
    if (kIsWeb) {
      throw UnikTorchUnsupportedPlatform();
    }
    if (!Platform.isIOS && !Platform.isAndroid) {
      throw UnikTorchUnsupportedPlatform();
    }
  }
}
