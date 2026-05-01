import 'package:flutter/material.dart';
import 'package:unik_mobile/theme/app_theme.dart';

class IdentityHeader extends StatelessWidget {
  const IdentityHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Column(
      children: [
        const CircleAvatar(
          radius: 48,
          backgroundColor: AppTheme.secondary,
          child: Text(
            'AJ',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        Text('Alex Johnson', style: tt.headlineMedium),
        const SizedBox(height: AppSpacing.s4),
        const Text(
          'alex@unik.io',
          style: TextStyle(color: AppTheme.muted),
        ),
      ],
    );
  }
}
