import 'package:flutter/material.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/screens/lab1/spell_input_card.dart';

class Lab1Page extends StatefulWidget {
  const Lab1Page({required this.title, super.key});

  final String title;

  @override
  State<Lab1Page> createState() => _Lab1PageState();
}

class _Lab1PageState extends State<Lab1Page> {
  int _counter = 0;
  final TextEditingController _controller = TextEditingController();
  String _message = 'Type a number and press Cast';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isAvada {
    return _controller.text.trim().toLowerCase() == 'avada kedavra';
  }

  int? get _parsedInput {
    return int.tryParse(_controller.text.trim());
  }

  void _castSpell() {
    final String value = _controller.text.trim();
    setState(() {
      if (value.toLowerCase() == 'avada kedavra') {
        _counter = 0;
        _message = 'Dark spell detected. Counter reset to 0.';
        return;
      }

      final int? parsed = int.tryParse(value);
      if (parsed == null) {
        _message = 'Enter a valid integer or Avada Kedavra.';
        return;
      }

      _counter += parsed;
      _message = 'Spell power $parsed applied. Counter updated.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final int energy = _counter.abs() % 100;
    final int? parsedInput = _parsedInput;
    final bool hasInput = _controller.text.trim().isNotEmpty;
    final bool canCast = _isAvada || parsedInput != null;
    final Color cardColor = _isAvada
        ? Colors.red.shade200
        : parsedInput != null
        ? Colors.green.shade200
        : scheme.surfaceContainerHighest;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Counter: $_counter',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: AppSpacing.s16),
            SpellInputCard(
              controller: _controller,
              onChanged: (_) => setState(() {}),
              energy: energy,
              backgroundColor: cardColor,
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(_message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.s8),
            Text(
              hasInput
                  ? _isAvada
                        ? 'Fatal spell mode'
                        : parsedInput != null
                        ? 'Numeric spell ready'
                        : 'Unknown spell'
                  : 'Waiting for spell',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: canCast ? _castSpell : null,
        icon: const Icon(Icons.auto_fix_high),
        label: const Text('Cast'),
      ),
    );
  }
}
