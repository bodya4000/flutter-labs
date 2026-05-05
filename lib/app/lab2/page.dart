import 'package:flutter/material.dart';
import 'package:unik_mobile/app/lab2/profile.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/screens/lab2/device.dart';
import 'package:unik_mobile/screens/lab2/device_card.dart';
import 'package:unik_mobile/screens/lab2/stats_row.dart';
import 'package:unik_mobile/widgets/app_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _goProfile() {
    Navigator.of(context)
        .push<void>(
          MaterialPageRoute<void>(builder: (_) => const ProfilePage()),
        )
        .then((_) {
          if (mounted) {
            setState(() {});
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final user = AppScope.authService.sessionUser;
    final greetingName = user?.fullName ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Dashboard'),
            Text(
              user?.email ?? '',
              style: tt.bodySmall?.copyWith(color: AppTheme.muted),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          AppIcon(
            icon: Icons.person_outline,
            onPressed: _goProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good morning,', style: tt.bodyMedium),
                Text(greetingName, style: tt.headlineMedium),
                const SizedBox(height: AppSpacing.s20),
                const DashboardStatsRow(),
                const SizedBox(height: AppSpacing.s24),
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
            ),
          ),
        ),
      ),
    );
  }
}
