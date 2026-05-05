import 'package:flutter/material.dart';
import 'package:unik_mobile/components/lab2/device.dart';
import 'package:unik_mobile/components/lab2/device_card.dart';
import 'package:unik_mobile/components/lab2/stats_row.dart';
import 'package:unik_mobile/screens/lab2/profile_page.dart';
import 'package:unik_mobile/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _goProfile(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => _goProfile(context),
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
                Text('Alex Johnson', style: tt.headlineMedium),
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
