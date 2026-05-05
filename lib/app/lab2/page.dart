import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:unik_mobile/app/lab2/lab2_devices_grid.dart';
import 'package:unik_mobile/app/lab2/lab2_movies_panel.dart';
import 'package:unik_mobile/app/lab2/profile.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/mqtt/mqtt_readings.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/screens/lab2/mqtt_readings_panel.dart';
import 'package:unik_mobile/screens/lab2/stats_row.dart';
import 'package:unik_mobile/widgets/app_icon.dart';

part 'lab2_home_mqtt_part.dart';

class HomePage extends StatefulWidget {
  const HomePage({this.warnOfflineOnOpen = false, super.key});

  final bool warnOfflineOnOpen;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeDashboardMqtt {
  @override
  void initState() {
    super.initState();
    initMqttDash();
  }

  @override
  void dispose() {
    disposeMqttDash();
    super.dispose();
  }

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
                MqttReadingsPanel(
                  hasInternet: _hasInternet,
                  mqttOnline: _mqttLinked,
                  readings: _readings,
                ),
                const SizedBox(height: AppSpacing.s20),
                const DashboardStatsRow(),
                const SizedBox(height: AppSpacing.s24),
                const Lab2DevicesGrid(),
                const SizedBox(height: AppSpacing.s24),
                Lab2MoviesPanel(catalog: AppScope.moviesCatalog),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
