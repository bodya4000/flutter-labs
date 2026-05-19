import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/app/lab2/lab2_devices_grid.dart';
import 'package:unik_mobile/app/lab2/lab2_movies_panel.dart';
import 'package:unik_mobile/app/lab2/profile.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/domain/user/registered_user.dart';
import 'package:unik_mobile/screens/lab2/mqtt_readings_panel.dart';
import 'package:unik_mobile/screens/lab2/stats_row.dart';
import 'package:unik_mobile/state/dashboard/dashboard_cubit.dart';
import 'package:unik_mobile/state/dashboard/dashboard_state.dart';
import 'package:unik_mobile/state/session/session_cubit.dart';
import 'package:unik_mobile/widgets/app_icon.dart';

class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return BlocBuilder<SessionCubit, RegisteredUser?>(
      builder: (context, user) {
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
                onPressed: () => HomeDashboardView.goProfile(context),
              ),
            ],
          ),
          body: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, mqtt) => SingleChildScrollView(
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
                      MqttReadingsPanel(
                        hasInternet: mqtt.hasInternet,
                        mqttOnline: mqtt.mqttLinked,
                        readings: mqtt.readings,
                      ),
                      const SizedBox(height: AppSpacing.s20),
                      const DashboardStatsRow(),
                      const SizedBox(height: AppSpacing.s24),
                      const Lab2DevicesGrid(),
                      const SizedBox(height: AppSpacing.s24),
                      const Lab2MoviesPanel(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> goProfile(BuildContext context) async {
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (_) => const ProfilePage()));
    if (!context.mounted) {
      return;
    }
    context.read<SessionCubit>().syncFromAuthService();
  }
}
