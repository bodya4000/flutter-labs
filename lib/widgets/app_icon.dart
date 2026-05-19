import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({required this.icon, required this.onPressed, super.key});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Icon(icon));
  }
}
