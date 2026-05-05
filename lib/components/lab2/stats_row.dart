import 'package:flutter/material.dart';
import 'package:unik_mobile/theme/app_theme.dart';
import 'package:unik_mobile/widgets/app_card.dart';

class DashboardStatsRow extends StatelessWidget {
  const DashboardStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    const items = [
      ('12', 'Devices'),
      ('8', 'Active'),
      ('1', 'Alerts'),
    ];
    return Row(
      children: [
        for (final (value, label) in items) ...[
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.s12,
                horizontal: AppSpacing.s8,
              ),
              child: Column(
                children: [
                  Text(value, style: tt.headlineMedium),
                  const SizedBox(height: AppSpacing.s2),
                  Text(label, style: tt.bodyMedium),
                ],
              ),
            ),
          ),
          if (label != 'Alerts')
            const SizedBox(width: AppSpacing.s8),
        ],
      ],
    );
  }
}
