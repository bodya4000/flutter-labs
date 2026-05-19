import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/app/lab2/home_dashboard_view.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/state/dashboard/dashboard_cubit.dart';
import 'package:unik_mobile/state/movies/movies_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({this.warnOfflineOnOpen = false, super.key});

  final bool warnOfflineOnOpen;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => DashboardCubit(
            mqtt: AppScope.mqtt,
            connectivity: AppScope.connectivity,
            onToast: (m, v) => AppToast.show(ctx, m, variant: v),
          )..start(warnOfflineOnOpen: warnOfflineOnOpen),
        ),
        BlocProvider(
          create: (_) => MoviesCubit(AppScope.moviesCatalog)..load(),
        ),
      ],
      child: const HomeDashboardView(),
    );
  }
}
