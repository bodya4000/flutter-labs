import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double s40 = 40;

  static const EdgeInsets pageHorizontal =
      EdgeInsets.symmetric(horizontal: s24);
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}

abstract final class AppTheme {
  static const Color primary = Color(0xFF00CFFD);
  static const Color onPrimary = Color(0xFF000000);
  static const Color secondary = Color(0xFF7B61FF);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color background = Color(0xFF0D0D14);
  static const Color onSurface = Color(0xFFF0F0FF);
  static const Color muted = Color(0xFF8888AA);
  static const Color error = Color(0xFFFF4D6D);

  static ThemeData get data => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: primary,
          secondary: secondary,
          onSecondary: Color(0xFFFFFFFF),
          surface: surface,
          onSurface: onSurface,
          error: error,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          foregroundColor: onSurface,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          labelStyle: const TextStyle(color: muted),
          hintStyle: const TextStyle(color: muted),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
        ),
      );
}
