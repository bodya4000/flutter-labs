import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/state/movies/movies_cubit.dart';
import 'package:unik_mobile/state/movies/movies_state.dart';

class Lab2MoviesPanel extends StatelessWidget {
  const Lab2MoviesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Catalog (API)', style: tt.titleLarge),
        const SizedBox(height: AppSpacing.s8),
        BlocBuilder<MoviesCubit, MoviesCatalogState>(
          builder: (ctx, catalog) {
            final phase = catalog.phase;
            if (phase == MoviesPhase.loading || phase == MoviesPhase.idle) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.s16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (phase == MoviesPhase.error) {
              return Text(
                'Could not load catalog',
                style: tt.bodyMedium?.copyWith(color: AppTheme.error),
              );
            }
            final list = catalog.items;
            if (list.isEmpty) {
              return Text(
                'No cached items yet — go online once to sync.',
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = list[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.title),
                  subtitle: Text('Year ${item.year}'),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
