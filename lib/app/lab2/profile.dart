import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/navigation/lab2_navigation.dart';
import 'package:unik_mobile/domain/user/registered_user.dart';
import 'package:unik_mobile/screens/lab2/profile/profile_edit_sheet.dart';
import 'package:unik_mobile/screens/lab2/profile/profile_scroll_body.dart';
import 'package:unik_mobile/state/profile_pin/profile_pin_cubit.dart';
import 'package:unik_mobile/state/session/session_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account'),
        content: const Text(
          'This removes your locally saved profile and signs you out.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    await context.read<SessionCubit>().deleteAccountClearSession();
    if (!context.mounted) {
      return;
    }
    Lab2Navigation.restartAuthFlow(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfilePinCubit(AppScope.devicePinVault)..reload(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        floatingActionButton: BlocBuilder<SessionCubit, RegisteredUser?>(
          builder: (context, user) => FloatingActionButton(
            onPressed: user == null
                ? null
                : () => ProfileEditSheet.open(context, user),
            child: const Icon(Icons.add),
          ),
        ),
        body: BlocBuilder<SessionCubit, RegisteredUser?>(
          builder: (context, user) {
            return user == null
                ? const Center(child: Text('No profile'))
                : ProfileScrollBody(
                    user: user,
                    onDeleteAccount: () => _confirmDelete(context),
                  );
          },
        ),
      ),
    );
  }
}
