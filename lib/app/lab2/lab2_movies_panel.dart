import 'package:flutter/material.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/domain/catalog/movie.dart';
import 'package:unik_mobile/domain/catalog/movies_catalog_repository.dart';

class Lab2MoviesPanel extends StatefulWidget {
  const Lab2MoviesPanel({required this.catalog, super.key});

  final MoviesCatalogRepository catalog;

  @override
  State<Lab2MoviesPanel> createState() => _Lab2MoviesPanelState();
}

class _Lab2MoviesPanelState extends State<Lab2MoviesPanel> {
  late final Future<List<Movie>> _load;

  @override
  void initState() {
    super.initState();
    _load = widget.catalog.loadPreferRemote();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Catalog (API)', style: tt.titleLarge),
        const SizedBox(height: AppSpacing.s8),
        FutureBuilder<List<Movie>>(
          future: _load,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.s16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snap.hasError) {
              return Text(
                'Could not load catalog',
                style: tt.bodyMedium?.copyWith(color: AppTheme.error),
              );
            }
            final list = snap.data ?? <Movie>[];
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
              itemBuilder: (ctx, i) {
                final m = list[i];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(m.title),
                  subtitle: Text('Year ${m.year}'),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
