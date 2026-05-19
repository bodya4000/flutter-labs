import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/core/connectivity/connectivity_service.dart';
import 'package:unik_mobile/core/mqtt/mqtt_readings.dart';
import 'package:unik_mobile/core/mqtt/mqtt_service.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/state/dashboard/dashboard_state.dart';

typedef DashboardToast = void Function(String message, AppToastVariant variant);

final class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required MqttService mqtt,
    required ConnectivityService connectivity,
    required DashboardToast onToast,
  }) : _mqtt = mqtt,
       _connectivity = connectivity,
       _onToast = onToast,
       super(
         DashboardState(
           hasInternet: true,
           mqttLinked: mqtt.isConnected,
           readings: mqtt.lastReadings,
         ),
       );

  final MqttService _mqtt;
  final ConnectivityService _connectivity;
  final DashboardToast _onToast;

  StreamSubscription<List<ConnectivityResult>>? _netSub;
  StreamSubscription<bool>? _mqttConnSub;
  StreamSubscription<MqttReadings>? _readingsSub;

  Future<void> start({required bool warnOfflineOnOpen}) async {
    _readingsSub?.cancel();
    _mqttConnSub?.cancel();

    emit(
      state.copyWith(
        readings: _mqtt.lastReadings,
        mqttLinked: _mqtt.isConnected,
      ),
    );

    _readingsSub = _mqtt.readingsStream.listen(
      (value) => emit(state.copyWith(readings: value)),
    );
    _mqttConnSub = _mqtt.connectionStream.listen(
      (linked) => emit(state.copyWith(mqttLinked: linked)),
    );

    final online = await _connectivity.checkOnline();
    emit(state.copyWith(hasInternet: online));
    if (warnOfflineOnOpen && !online) {
      _onToast(
        'Limited mode — no internet. MQTT is paused until online.',
        AppToastVariant.neutral,
      );
    }
    if (online) {
      await _mqtt.connect();
      emit(
        state.copyWith(
          mqttLinked: _mqtt.isConnected,
          readings: _mqtt.lastReadings,
        ),
      );
    }

    await _netSub?.cancel();
    _netSub = _connectivity.onConnectivityChanged.listen(
      (_) => unawaited(_handleConnectivityChange()),
    );
  }

  Future<void> _handleConnectivityChange() async {
    final online = await _connectivity.checkOnline();
    final wasOnline = state.hasInternet;
    if (online == wasOnline) {
      return;
    }
    emit(state.copyWith(hasInternet: online));
    if (!online) {
      _onToast('Network connection lost', AppToastVariant.error);
      await _mqtt.disconnect();
    } else {
      _onToast('Back online', AppToastVariant.success);
      await _mqtt.connect();
      emit(state.copyWith(mqttLinked: _mqtt.isConnected));
    }
  }

  @override
  Future<void> close() async {
    await _netSub?.cancel();
    await _readingsSub?.cancel();
    await _mqttConnSub?.cancel();
    await _mqtt.disconnect();
    return super.close();
  }
}
