import 'package:flutter/material.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.borderRadius = AppRadius.lg,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(AppSpacing.s16),
    super.key,
  });

  final Widget child;
  final double borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final Color color = backgroundColor ?? AppTheme.surface;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
