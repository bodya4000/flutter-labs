import 'package:flutter/material.dart';

import 'package:unik_mobile/app.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/state/app_registry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppScope.init();
  GlobalSession.init();
  runApp(const UnikApp());
}
