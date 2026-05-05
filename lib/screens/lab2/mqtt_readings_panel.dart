import 'package:flutter/material.dart';

import 'package:unik_mobile/core/mqtt/mqtt_readings.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/widgets/app_card.dart';

class MqttReadingsPanel extends StatelessWidget {
  const MqttReadingsPanel({
    required this.hasInternet,
    required this.mqttOnline,
    required this.readings,
    super.key,
  });

  final bool hasInternet;
  final bool mqttOnline;
  final MqttReadings readings;

  String get _statusLine {
    if (!hasInternet) {
      return 'Offline — MQTT needs internet';
    }
    if (!mqttOnline) {
      return 'Not connected — start Mosquitto and the publisher';
    }
    return 'Live MQTT';
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final Color accent = mqttOnline ? AppTheme.primary : AppTheme.muted;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sensors, color: accent, size: 28),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Text('Sensor feed', style: tt.titleMedium),
              ),
            ],
          ),
          Text(
            _statusLine,
            style: tt.bodySmall?.copyWith(color: AppTheme.muted),
          ),
          const SizedBox(height: AppSpacing.s16),
          _MetricTile(
            icon: Icons.device_thermostat,
            label: 'Temperature',
            suffix: '°C',
            value: readings.temperatureC,
          ),
          const Divider(height: AppSpacing.s24),
          _MetricTile(
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            suffix: '%',
            value: readings.humidityPercent,
          ),
          const Divider(height: AppSpacing.s24),
          _MetricTile(
            icon: Icons.bolt,
            label: 'Electricity',
            suffix: 'kW',
            value: readings.electricityKw,
            fractionDigits: 2,
          ),
          const Divider(height: AppSpacing.s24),
          _MetricTile(
            icon: Icons.light_mode_outlined,
            label: 'Light',
            suffix: 'lux',
            value: readings.lightLux,
            fractionDigits: 0,
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.suffix,
    required this.value,
    this.fractionDigits = 1,
  });

  final IconData icon;
  final String label;
  final String suffix;
  final double? value;
  final int fractionDigits;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final formatted = value == null
        ? '—'
        : '${value!.toStringAsFixed(fractionDigits)} $suffix';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: AppTheme.secondary),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: tt.bodySmall?.copyWith(color: AppTheme.muted),
              ),
              Text(
                formatted,
                style: tt.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
