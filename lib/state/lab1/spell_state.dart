import 'package:flutter/material.dart';

enum SpellCardTone { neutral, fatal, numeric }

final class SpellState {
  const SpellState({
    required this.counter,
    required this.message,
    required this.draftText,
  });

  final int counter;
  final String message;
  final String draftText;

  static const SpellState initial = SpellState(
    counter: 0,
    message: 'Type a number and press Cast',
    draftText: '',
  );

  bool get isAvada => draftText.trim().toLowerCase() == 'avada kedavra';

  int? get parsed => int.tryParse(draftText.trim());

  int get energy => counter.abs() % 100;

  bool get castEnabled => isAvada || parsed != null;

  SpellCardTone get tone => isAvada
      ? SpellCardTone.fatal
      : parsed != null
      ? SpellCardTone.numeric
      : SpellCardTone.neutral;

  String get modeBadge {
    final hasInput = draftText.trim().isNotEmpty;
    if (!hasInput) {
      return 'Waiting for spell';
    }
    if (isAvada) {
      return 'Fatal spell mode';
    }
    if (parsed != null) {
      return 'Numeric spell ready';
    }
    return 'Unknown spell';
  }

  Color cardTint(ColorScheme scheme) => tone == SpellCardTone.fatal
      ? Colors.red.shade200
      : tone == SpellCardTone.numeric
      ? Colors.green.shade200
      : scheme.surfaceContainerHighest;

  SpellState afterCast({
    required int nextCounter,
    required String nextMessage,
  }) => SpellState(
    counter: nextCounter,
    message: nextMessage,
    draftText: draftText,
  );

  SpellState withDraft(String next) =>
      SpellState(counter: counter, message: message, draftText: next);
}
