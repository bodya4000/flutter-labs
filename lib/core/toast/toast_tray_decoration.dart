import 'package:flutter/material.dart';

import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/core/toast/toast_contract.dart';

Decoration toastTrayDecoration(AppToastVariant variant) => switch (variant) {
  AppToastVariant.neutral => BoxDecoration(
    color: AppTheme.surface,
    borderRadius: BorderRadius.circular(AppRadius.lg),
    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
    boxShadow: const [
      BoxShadow(
        blurRadius: 28,
        offset: Offset(0, 12),
        color: Color(0x66000000),
      ),
    ],
  ),
  AppToastVariant.error => BoxDecoration(
    color: const Color(0xFF3B1F29),
    borderRadius: BorderRadius.circular(AppRadius.lg),
    border: Border.all(color: AppTheme.error.withValues(alpha: 0.55)),
    boxShadow: const [
      BoxShadow(
        blurRadius: 28,
        offset: Offset(0, 12),
        color: Color(0x66000000),
      ),
    ],
  ),
  AppToastVariant.success => BoxDecoration(
    color: const Color(0xFF1F3B30),
    borderRadius: BorderRadius.circular(AppRadius.lg),
    border: Border.all(color: const Color(0xFF4ADE80).withValues(alpha: 0.45)),
    boxShadow: const [
      BoxShadow(
        blurRadius: 28,
        offset: Offset(0, 12),
        color: Color(0x66000000),
      ),
    ],
  ),
};
