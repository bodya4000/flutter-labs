import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:unik_mobile/constants/mqtt_events.dart';
import 'package:unik_mobile/core/mqtt/mqtt_broker_host.dart';
import 'package:unik_mobile/core/mqtt/mqtt_readings.dart';

final class MqttService {
  MqttServerClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage?>>>? _subscription;

  final StreamController<MqttReadings> _readings =
      StreamController<MqttReadings>.broadcast();
  final StreamController<bool> _linked = StreamController<bool>.broadcast();

  Stream<MqttReadings> get readingsStream => _readings.stream;
  Stream<bool> get connectionStream => _linked.stream;

  bool _connected = false;

  bool get isConnected => _connected;
  MqttReadings _snapshot = MqttReadings.empty;

  MqttReadings get lastReadings => _snapshot;

  Future<void> connect() async {
    await disconnect();
    const suffix = kIsWeb ? 'w' : 'n';
    final id = 'unik_${DateTime.now().millisecondsSinceEpoch}_$suffix';
    final client = MqttServerClient(MqttBrokerHost.resolve(), id)
      ..port = MqttBrokerHost.port
      ..keepAlivePeriod = 20
      ..logging(on: false)
      ..autoReconnect = false
      ..onDisconnected = () {
        _publishLinked(false);
      };

    try {
      await client.connect();
    } catch (_) {
      _publishLinked(false);
      return;
    }

    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      try {
        client.disconnect();
      } catch (_) {}
      _publishLinked(false);
      return;
    }

    final inbound = client.updates;
    if (inbound == null) {
      try {
        client.disconnect();
      } catch (_) {}
      _publishLinked(false);
      return;
    }

    _subscription = inbound.listen(_onBatch);

    const qos = MqttQos.atLeastOnce;
    client.subscribe(MqttEvents.sensorTemperature, qos);
    client.subscribe(MqttEvents.sensorHumidity, qos);
    client.subscribe(MqttEvents.sensorElectricity, qos);
    client.subscribe(MqttEvents.sensorLight, qos);

    _client = client;
    _publishLinked(true);
  }

  void _onBatch(List<MqttReceivedMessage<MqttMessage?>> batch) {
    for (final envelope in batch) {
      final raw = envelope.payload;
      if (raw is! MqttPublishMessage) {
        continue;
      }
      final text = MqttPublishPayload.bytesToStringAsString(
        raw.payload.message,
      );
      final value = double.tryParse(text.trim());
      if (value == null) {
        continue;
      }
      final topic = envelope.topic;
      _snapshot = MqttReadings(
        temperatureC: topic == MqttEvents.sensorTemperature
            ? value
            : _snapshot.temperatureC,
        humidityPercent: topic == MqttEvents.sensorHumidity
            ? value
            : _snapshot.humidityPercent,
        electricityKw: topic == MqttEvents.sensorElectricity
            ? value
            : _snapshot.electricityKw,
        lightLux: topic == MqttEvents.sensorLight
            ? value
            : _snapshot.lightLux,
      );
      if (!_readings.isClosed) {
        _readings.add(_snapshot);
      }
    }
  }

  void _publishLinked(bool value) {
    if (_connected == value) {
      return;
    }
    _connected = value;
    if (!_linked.isClosed) {
      _linked.add(value);
    }
    if (!value) {
      _snapshot = MqttReadings.empty;
      if (!_readings.isClosed) {
        _readings.add(_snapshot);
      }
    }
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null;
    try {
      _client?.disconnect();
    } catch (_) {}
    _client = null;
    _publishLinked(false);
  }
}
