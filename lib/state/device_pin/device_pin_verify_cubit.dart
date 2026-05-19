import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';
import 'package:unik_mobile/domain/device/device_pin_vault.dart';

final class DevicePinBarrierView {
  const DevicePinBarrierView({required this.busy, this.errorHint});

  final bool busy;
  final String? errorHint;
}

final class DevicePinVerifyCubit extends Cubit<DevicePinBarrierView> {
  DevicePinVerifyCubit(this._vault)
    : super(const DevicePinBarrierView(busy: false));

  final DevicePinVault _vault;

  Future<bool?> tryUnlock(String plain) async {
    final fmt = RegistrationValidator.validatePin(plain);
    if (fmt != null) {
      emit(DevicePinBarrierView(busy: false, errorHint: fmt));
      return null;
    }
    emit(const DevicePinBarrierView(busy: true));
    final ok = await _vault.verifyPin(plain);
    emit(DevicePinBarrierView(busy: false, errorHint: ok ? null : 'Wrong PIN'));
    return ok;
  }
}
