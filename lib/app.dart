import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/app/page.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/state/app_registry.dart';

class UnikApp extends StatelessWidget {
  const UnikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GlobalSession.cubit,
      child: MaterialApp(
        title: 'UNIK IoT',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.data,
        home: const LabsPage(),
      ),
    );
  }
}
