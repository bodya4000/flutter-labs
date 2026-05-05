import 'dart:io';

abstract final class MqttBrokerHost {
  static const int port = 1883;

  static String resolve() {
    const fromEnv = String.fromEnvironment('MQTT_BROKER_HOST');
    if (fromEnv.isNotEmpty) {
      return fromEnv;
    }
    if (Platform.isAndroid) {
      return '10.0.2.2';
    }
    return '127.0.0.1';
  }
}
