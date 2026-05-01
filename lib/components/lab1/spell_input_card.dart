import 'package:flutter/material.dart';
import 'package:unik_mobile/theme/app_theme.dart';

class SpellInputCard extends StatelessWidget {
  const SpellInputCard({
    required this.controller,
    required this.onChanged,
    required this.energy,
    required this.backgroundColor,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final int energy;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: <Widget>[
          TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Spell input',
              hintText: 'Type number or Avada Kedavra',
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          LinearProgressIndicator(
            value: energy / 100,
            minHeight: 10,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text('Magic energy: $energy%'),
        ],
      ),
    );
  }
}
