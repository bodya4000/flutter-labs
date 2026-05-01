import 'package:flutter/material.dart';
import 'package:unik_mobile/components/lab2/device.dart';
import 'package:unik_mobile/theme/app_theme.dart';
import 'package:unik_mobile/widgets/app_card.dart';

class DashboardDeviceCard extends StatelessWidget {
  const DashboardDeviceCard({required this.device, super.key});

  final DashboardDevice device;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(device.icon, color: device.color, size: 28),
          const SizedBox(height: AppSpacing.s12),
          Text(device.name, style: tt.titleMedium),
          const SizedBox(height: AppSpacing.s4),
          Text(device.status, style: tt.bodyMedium),
        ],
      ),
    );
  }
}
