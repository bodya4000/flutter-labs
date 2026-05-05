import 'package:flutter/material.dart';
import 'package:unik_mobile/theme/app_theme.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  static const _size = Size(double.infinity, 52);
  static const _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
  );

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.onPrimary,
            minimumSize: _size,
            shape: _shape,
          ),
          child: Text(label),
        ),
      AppButtonVariant.secondary => ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.secondary,
            foregroundColor: const Color(0xFFFFFFFF),
            minimumSize: _size,
            shape: _shape,
          ),
          child: Text(label),
        ),
      AppButtonVariant.ghost => OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primary,
            minimumSize: _size,
            side: const BorderSide(color: AppTheme.primary),
            shape: _shape,
          ),
          child: Text(label),
        ),
    };
  }
}
