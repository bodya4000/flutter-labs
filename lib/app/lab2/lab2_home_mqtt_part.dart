part of 'page.dart';

mixin HomeDashboardMqtt on State<HomePage> {
  StreamSubscription<List<ConnectivityResult>>? _networkSub;
  StreamSubscription<bool>? _mqttConnSub;
  StreamSubscription<MqttReadings>? _readingsSub;

  bool _hasInternet = true;
  bool _mqttLinked = false;
  MqttReadings _readings = MqttReadings.empty;

  void initMqttDash() {
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

  void disposeMqttDash() {
    _networkSub?.cancel();
    _mqttConnSub?.cancel();
    _readingsSub?.cancel();
    unawaited(AppScope.mqtt.disconnect());
  }
}
