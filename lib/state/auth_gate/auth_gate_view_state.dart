enum AuthGatePhase { loading, login, pin, home }

final class AuthGateViewState {
  const AuthGateViewState(this.phase, {this.warnOfflineDashboard = false});

  final AuthGatePhase phase;

  /// Shown once on [HomePage] MQTT bootstrap after unlock or direct home.
  final bool warnOfflineDashboard;
}
