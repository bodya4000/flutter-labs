import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/screens/lab1/spell_input_card.dart';
import 'package:unik_mobile/state/lab1/spell_counter_cubit.dart';
import 'package:unik_mobile/state/lab1/spell_state.dart';

class Lab1Page extends StatelessWidget {
  const Lab1Page({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpellCounterCubit(),
      child: _Lab1SpellInputScope(title: title),
    );
  }
}

final class _Lab1SpellInputScope extends StatefulWidget {
  const _Lab1SpellInputScope({required this.title});

  final String title;

  @override
  State<_Lab1SpellInputScope> createState() => _Lab1SpellInputScopeState();
}

final class _Lab1SpellInputScopeState extends State<_Lab1SpellInputScope> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<SpellCounterCubit, SpellState>(
              builder: (ctx, spell) => Text(
                'Counter: ${spell.counter}',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            BlocBuilder<SpellCounterCubit, SpellState>(
              builder: (ctx, spell) => SpellInputCard(
                controller: _controller,
                onChanged: (value) =>
                    ctx.read<SpellCounterCubit>().previewDraft(value),
                energy: spell.energy,
                backgroundColor: spell.cardTint(scheme),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            BlocBuilder<SpellCounterCubit, SpellState>(
              builder: (ctx, spell) => Column(
                children: [
                  Text(spell.message, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    spell.modeBadge,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<SpellCounterCubit, SpellState>(
        builder: (ctx, spell) => FloatingActionButton.extended(
          onPressed: spell.castEnabled
              ? () => ctx.read<SpellCounterCubit>().cast()
              : null,
          icon: const Icon(Icons.auto_fix_high),
          label: const Text('Cast'),
        ),
      ),
    );
  }
}
