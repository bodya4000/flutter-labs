import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/state/lab1/spell_state.dart';

final class SpellCounterCubit extends Cubit<SpellState> {
  SpellCounterCubit() : super(SpellState.initial);

  void previewDraft(String next) => emit(state.withDraft(next));

  void cast() {
    final value = state.draftText.trim();
    if (value.toLowerCase() == 'avada kedavra') {
      emit(
        state.afterCast(
          nextCounter: 0,
          nextMessage: 'Dark spell detected. Counter reset to 0.',
        ),
      );
      return;
    }
    final delta = state.parsed;
    if (delta == null) {
      emit(
        state.afterCast(
          nextCounter: state.counter,
          nextMessage: 'Enter a valid integer or Avada Kedavra.',
        ),
      );
      return;
    }
    emit(
      state.afterCast(
        nextCounter: state.counter + delta,
        nextMessage: 'Spell power $delta applied. Counter updated.',
      ),
    );
  }
}
