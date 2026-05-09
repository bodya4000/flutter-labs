import 'package:unik_mobile/state/session/session_cubit.dart';

abstract final class GlobalSession {
  static late SessionCubit cubit;

  static void init() {
    cubit = SessionCubit();
  }
}
