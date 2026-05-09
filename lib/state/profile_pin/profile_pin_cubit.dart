import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';
import 'package:unik_mobile/domain/device/device_pin_vault.dart';

final class ProfilePinChip {
  ProfilePinChip({required this.busyProbe, required this.pinOn});

  final bool busyProbe;
  final bool? pinOn;
}

enum ProfilePinRemovalResult { badPin, cleared }

final class ProfilePinCubit extends Cubit<ProfilePinChip> {
  ProfilePinCubit(this._vault)
    : super(ProfilePinChip(busyProbe: true, pinOn: null));

  final DevicePinVault _vault;

  Future<void> reload() async {
    emit(ProfilePinChip(busyProbe: true, pinOn: state.pinOn));
    final configured = await _vault.hasConfiguredPin();
    emit(ProfilePinChip(busyProbe: false, pinOn: configured));
  }

  Future<String?> finalizePlainPin(String pin) async {
    final format = RegistrationValidator.validatePin(pin);
    if (format != null) {
      return format;
    }
    await _vault.setPinFromPlain(pin);
    await reload();
    return null;
  }

  Future<ProfilePinRemovalResult> tryRemoveVerified(String pinGuess) async {
    final verified = await _vault.verifyPin(pinGuess);
    if (!verified) {
      return ProfilePinRemovalResult.badPin;
    }
    await _vault.clearPin();
    await reload();
    return ProfilePinRemovalResult.cleared;
  }
}
