final class MqttReadings {
  const MqttReadings({
    this.temperatureC,
    this.humidityPercent,
    this.electricityKw,
    this.lightLux,
  });

  final double? temperatureC;
  final double? humidityPercent;
  final double? electricityKw;
  final double? lightLux;

  static const MqttReadings empty = MqttReadings();
}
