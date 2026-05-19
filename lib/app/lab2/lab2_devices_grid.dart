import 'package:flutter/material.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/screens/lab2/device.dart';
import 'package:unik_mobile/screens/lab2/device_card.dart';

class Lab2DevicesGrid extends StatelessWidget {
  const Lab2DevicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Devices', style: tt.titleLarge),
        const SizedBox(height: AppSpacing.s12),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dashboardDevices.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.s8,
            mainAxisSpacing: AppSpacing.s8,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (context, index) =>
              DashboardDeviceCard(device: dashboardDevices[index]),
        ),
      ],
    );
  }
}
