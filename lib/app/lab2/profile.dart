import 'package:flutter/material.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/navigation/lab2_navigation.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/screens/lab2/profile/action_buttons.dart';
import 'package:unik_mobile/screens/lab2/profile/identity_header.dart';
import 'package:unik_mobile/screens/lab2/profile/profile_edit_sheet.dart';
import 'package:unik_mobile/screens/lab2/profile/profile_pin_card.dart';
import 'package:unik_mobile/screens/lab2/profile/stats_row.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _openEditor() {
    final user = AppScope.authService.sessionUser;
    if (user == null) {
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ProfileEditSheet(
        initialFullName: user.fullName,
        initialEmail: user.email,
        initialNickname: user.nickname,
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _confirmDelete() async {
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
    if (confirmed != true || !mounted) {
      return;
    }
    await AppScope.authService.deleteAccount();
    if (!mounted) {
      return;
    }
    Lab2Navigation.restartAuthFlow(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = AppScope.authService.sessionUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      floatingActionButton: FloatingActionButton(
        onPressed: user == null ? null : _openEditor,
        child: const Icon(Icons.add),
      ),
      body: user == null
          ? const Center(child: Text('No profile'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    children: [
                      IdentityHeader(
                        fullName: user.fullName,
                        email: user.email,
                        nickname: user.nickname,
                      ),
                      const SizedBox(height: AppSpacing.s24),
                      const ProfilePinCard(),
                      const SizedBox(height: AppSpacing.s32),
                      const StatsRow(),
                      const SizedBox(height: AppSpacing.s32),
                      ActionButtons(
                        onEditProfile: _openEditor,
                        onDeleteAccount: _confirmDelete,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
