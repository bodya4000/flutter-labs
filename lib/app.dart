import 'package:flutter/material.dart';
import 'package:unik_mobile/screens/labs_page.dart';

class UnikApp extends StatelessWidget {
  const UnikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Counter Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LabsPage(),
    );
  }
}
