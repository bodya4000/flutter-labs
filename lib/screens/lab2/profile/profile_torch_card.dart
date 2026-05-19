import 'package:flutter/material.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/widgets/app_card.dart';

final class ProfileTorchCard extends StatelessWidget {
  const ProfileTorchCard({
    required this.lit,
    required this.busy,
    required this.onChanged,
    super.key,
  });

  final bool lit;
  final bool busy;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return AppCard(
      child: Row(
        children: [
          Icon(lit ? Icons.flash_on : Icons.flash_off, color: AppTheme.primary),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Flashlight', style: tt.titleMedium),
                Text(
                  lit ? 'On' : 'Off',
                  style: tt.bodySmall?.copyWith(color: AppTheme.muted),
                ),
              ],
            ),
          ),
          Switch.adaptive(value: lit, onChanged: busy ? null : onChanged),
        ],
      ),
    );
  }
}
