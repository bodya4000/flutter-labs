import 'package:flutter/material.dart';

import 'package:unik_mobile/app.dart';
import 'package:unik_mobile/core/config/app_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppScope.init();
  runApp(const UnikApp());
}
