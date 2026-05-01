import 'package:flutter/material.dart';
import 'package:unik_mobile/components/lab2/profile/action_buttons.dart';
import 'package:unik_mobile/components/lab2/profile/identity_header.dart';
import 'package:unik_mobile/components/lab2/profile/stats_row.dart';
import 'package:unik_mobile/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const IdentityHeader(),
                const SizedBox(height: AppSpacing.s32),
                const StatsRow(),
                const SizedBox(height: AppSpacing.s32),
                const ActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
