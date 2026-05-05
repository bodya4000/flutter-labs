import 'package:flutter/material.dart';
import 'package:unik_mobile/app/page.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';

class UnikApp extends StatelessWidget {
  const UnikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UNIK IoT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.data,
      home: const LabsPage(),
    );
  }
}
