import 'package:unik_mobile/core/mqtt/mqtt_readings.dart';

final class DashboardState {
  const DashboardState({
    required this.hasInternet,
    required this.mqttLinked,
    required this.readings,
  });

  final bool hasInternet;
  final bool mqttLinked;
  final MqttReadings readings;

  DashboardState copyWith({
    bool? hasInternet,
    bool? mqttLinked,
    MqttReadings? readings,
  }) => DashboardState(
    hasInternet: hasInternet ?? this.hasInternet,
    mqttLinked: mqttLinked ?? this.mqttLinked,
    readings: readings ?? this.readings,
  );
}
