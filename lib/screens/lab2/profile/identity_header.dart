import 'package:flutter/material.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';

class IdentityHeader extends StatelessWidget {
  const IdentityHeader({
    required this.fullName,
    required this.email,
    this.nickname = '',
    this.onAvatarLongPress,
    super.key,
  });

  final String fullName;
  final String email;
  final String nickname;
  final VoidCallback? onAvatarLongPress;

  static String initialsFor(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      final s = parts.single;
      if (s.length >= 2) {
        return s.substring(0, 2).toUpperCase();
      }
      return s.toUpperCase();
    }
    final first = parts.first;
    final last = parts.last;
    return '${first[0]}${last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final nick = nickname.trim();
    final display = nick.isNotEmpty ? nick : fullName;
    final initials = initialsFor(display);
    final avatar = CircleAvatar(
      radius: 48,
      backgroundColor: AppTheme.secondary,
      child: Text(
        initials,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return Column(
      children: [
        if (onAvatarLongPress == null)
          avatar
        else
          GestureDetector(onLongPress: onAvatarLongPress, child: avatar),
        const SizedBox(height: AppSpacing.s16),
        Text(fullName, style: tt.headlineMedium),
        if (nick.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s4),
          Text(
            '@$nick',
            style: const TextStyle(color: AppTheme.muted, fontSize: 16),
          ),
        ],
        const SizedBox(height: AppSpacing.s4),
        Text(email, style: const TextStyle(color: AppTheme.muted)),
      ],
    );
  }
}
