import 'package:flutter/material.dart';
import 'package:unik_mobile/screens/lab2/login_page.dart';
import 'package:unik_mobile/screens/lab2/register_page.dart';
import 'package:unik_mobile/theme/app_theme.dart';
import 'package:unik_mobile/widgets/app_button.dart';
import 'package:unik_mobile/widgets/app_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundColor: AppTheme.secondary,
                  child: Text(
                    'AJ',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Alex Johnson', style: tt.headlineMedium),
                const SizedBox(height: 4),
                const Text(
                  'alex@unik.io',
                  style: TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: 32),
                _StatsRow(tt: tt),
                const SizedBox(height: 32),
                const AppButton(
                  label: 'Edit Profile',
                  variant: AppButtonVariant.secondary,
                  onPressed: null,
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Go to Login',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LoginPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Go to Register',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const RegisterPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Sign Out',
                  variant: AppButtonVariant.ghost,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.tt});

  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    const stats = [
      ('12', 'Devices'),
      ('4', 'Rooms'),
      ('7', 'Routines'),
    ];
    return Row(
      children: [
        for (final (value, label) in stats) ...[
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                children: [
                  Text(value, style: tt.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: tt.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          if (label != 'Routines') const SizedBox(width: 8),
        ],
      ],
    );
  }
}
