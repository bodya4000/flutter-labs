import 'package:flutter/material.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';

class IdentityHeader extends StatelessWidget {
  const IdentityHeader({
    required this.fullName,
    required this.email,
    super.key,
  });

  final String fullName;
  final String email;

  static String initialsFor(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      final s = parts.single;
      if (s.length >= 2) {
        return s.substring(0, 2).toUpperCase();
      }
      return s.toUpperCase();
    }
    final first = parts.first;
    final last = parts.last;
    return '${first[0]}${last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final initials = initialsFor(fullName);
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: AppTheme.secondary,
          child: Text(
            initials,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        Text(fullName, style: tt.headlineMedium),
        const SizedBox(height: AppSpacing.s4),
        Text(email, style: const TextStyle(color: AppTheme.muted)),
      ],
    );
  }
}
