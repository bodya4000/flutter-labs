import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:unik_mobile/app/lab2/profile.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/mqtt/mqtt_readings.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/screens/lab2/device.dart';
import 'package:unik_mobile/screens/lab2/device_card.dart';
import 'package:unik_mobile/screens/lab2/mqtt_readings_panel.dart';
import 'package:unik_mobile/screens/lab2/stats_row.dart';
import 'package:unik_mobile/widgets/app_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({this.warnOfflineOnOpen = false, super.key});

  final bool warnOfflineOnOpen;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<List<ConnectivityResult>>? _networkSub;
  StreamSubscription<bool>? _mqttConnSub;
  StreamSubscription<MqttReadings>? _readingsSub;

  bool _hasInternet = true;
  bool _mqttLinked = false;
  MqttReadings _readings = MqttReadings.empty;

  @override
  void initState() {
    super.initState();
    _readings = AppScope.mqtt.lastReadings;
    _mqttLinked = AppScope.mqtt.isConnected;
    _readingsSub = AppScope.mqtt.readingsStream.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() => _readings = value);
    });
    _mqttConnSub = AppScope.mqtt.connectionStream.listen((linked) {
      if (!mounted) {
        return;
      }
      setState(() => _mqttLinked = linked);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_bootstrap());
    });
  }

  Future<void> _bootstrap() async {
    final online = await AppScope.connectivity.checkOnline();
    if (!mounted) {
      return;
    }
    setState(() => _hasInternet = online);
    if (widget.warnOfflineOnOpen && !online) {
      AppToast.show(
        context,
        'Limited mode — no internet. MQTT is paused until you are online.',
      );
    }
    if (online) {
      await AppScope.mqtt.connect();
      if (!mounted) {
        return;
      }
      setState(() {
        _mqttLinked = AppScope.mqtt.isConnected;
        _readings = AppScope.mqtt.lastReadings;
      });
    }
    _networkSub = AppScope.connectivity.onConnectivityChanged.listen((_) {
      unawaited(_handleConnectivityEvent());
    });
  }

  Future<void> _handleConnectivityEvent() async {
    final online = await AppScope.connectivity.checkOnline();
    if (!mounted) {
      return;
    }
    final wasOnline = _hasInternet;
    if (online == wasOnline) {
      return;
    }
    setState(() => _hasInternet = online);
    if (!online) {
      AppToast.show(
        context,
        'Network connection lost',
        variant: AppToastVariant.error,
      );
      await AppScope.mqtt.disconnect();
    } else {
      AppToast.show(
        context,
        'Back online',
        variant: AppToastVariant.success,
      );
      await AppScope.mqtt.connect();
      if (!mounted) {
        return;
      }
      setState(() {
        _mqttLinked = AppScope.mqtt.isConnected;
      });
    }
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
  void dispose() {
    _networkSub?.cancel();
    _mqttConnSub?.cancel();
    _readingsSub?.cancel();
    unawaited(AppScope.mqtt.disconnect());
    super.dispose();
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
