abstract interface class DevicePinVault {
  Future<bool> hasConfiguredPin();

  Future<void> setPinFromPlain(String pin);

  Future<void> clearPin();

  Future<bool> verifyPin(String plain);
}
