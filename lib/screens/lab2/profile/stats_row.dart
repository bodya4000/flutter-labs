import 'package:flutter/material.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/widgets/app_card.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    const stats = [('12', 'Devices'), ('4', 'Rooms'), ('7', 'Routines')];
    return Row(
      children: [
        for (final (value, label) in stats) ...[
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.s16,
                horizontal: AppSpacing.s8,
              ),
              child: Column(
                children: [
                  Text(value, style: textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    label,
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          if (label != 'Routines') const SizedBox(width: AppSpacing.s8),
        ],
      ],
    );
  }
}
