import 'package:flutter/material.dart';

class DfColors {
  static const bg = Color(0xFF090B14);
  static const surface = Color(0xFF121627);
  static const raise = Color(0xFF1A1F35);
  static const ink = Color(0xFFECEEF8);
  static const muted = Color(0xFF8F96B3);
  static const line = Color(0xFF262C47);
  static const accent = Color(0xFF8B5CF6);
  static const secondary = Color(0xFF22D3EE);
  static const pink = Color(0xFFEC4899);
  static const onAccent = Color(0xFF12082A);
  static const ok = Color(0xFF3DDC84);
  static const warn = Color(0xFFFF9F43);
  static const danger = Color(0xFFFF8A80);
}

/// Used when the bundled Burmese font is not installed (see pubspec.yaml).
const List<String> burmeseFallback = [
  'Noto Sans Myanmar',
  'Padauk',
  'Myanmar Text',
];

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: DfColors.accent,
    brightness: Brightness.dark,
  ).copyWith(
    primary: DfColors.accent,
    onPrimary: DfColors.onAccent,
    secondary: DfColors.secondary,
    surface: DfColors.surface,
    onSurface: DfColors.ink,
    error: DfColors.danger,
  );
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: DfColors.bg,
  );

  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    side: const BorderSide(color: DfColors.line, width: 1),
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: DfColors.ink,
      displayColor: DfColors.ink,
      fontFamilyFallback: burmeseFallback,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DfColors.bg,
      foregroundColor: DfColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: DfColors.ink,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: .2,
        fontFamilyFallback: burmeseFallback,
      ),
    ),
    cardTheme: CardThemeData(
      color: DfColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: shape,
    ),
    dividerTheme: const DividerThemeData(
      color: DfColors.line,
      thickness: 1,
      space: 1,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: DfColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      titleTextStyle: const TextStyle(
        color: DfColors.ink,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        fontFamilyFallback: burmeseFallback,
      ),
      contentTextStyle: const TextStyle(
        color: DfColors.muted,
        fontSize: 14,
        height: 1.5,
        fontFamilyFallback: burmeseFallback,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: DfColors.raise,
      contentTextStyle: const TextStyle(
        color: DfColors.ink,
        fontSize: 13,
        fontFamilyFallback: burmeseFallback,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: DfColors.bg,
      indicatorColor: DfColors.accent.withValues(alpha: 0.25),
      elevation: 0,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          fontFamilyFallback: burmeseFallback,
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: DfColors.surface,
      indicatorColor: DfColors.accent.withValues(alpha: 0.22),
      selectedIconTheme: const IconThemeData(color: DfColors.secondary),
      unselectedIconTheme: const IconThemeData(color: DfColors.muted),
      selectedLabelTextStyle: const TextStyle(
        color: DfColors.ink,
        fontWeight: FontWeight.w800,
        fontFamilyFallback: burmeseFallback,
      ),
      unselectedLabelTextStyle: const TextStyle(
        color: DfColors.muted,
        fontFamilyFallback: burmeseFallback,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DfColors.raise,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      hintStyle: const TextStyle(color: DfColors.muted, fontSize: 13),
      labelStyle: const TextStyle(color: DfColors.muted, fontSize: 13),
      floatingLabelStyle: const TextStyle(
        color: DfColors.secondary,
        fontWeight: FontWeight.w700,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: DfColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: DfColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: DfColors.accent, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: DfColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: DfColors.danger, width: 1.6),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DfColors.accent,
        foregroundColor: DfColors.onAccent,
        disabledBackgroundColor: DfColors.raise,
        disabledForegroundColor: DfColors.muted,
        elevation: 0,
        minimumSize: const Size(44, 46),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontFamilyFallback: burmeseFallback,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DfColors.ink,
        minimumSize: const Size(44, 46),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: const BorderSide(color: DfColors.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontFamilyFallback: burmeseFallback,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DfColors.secondary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontFamilyFallback: burmeseFallback,
        ),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: DfColors.raise,
      selectedColor: DfColors.accent.withValues(alpha: .22),
      side: const BorderSide(color: DfColors.line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      labelStyle: const TextStyle(
        color: DfColors.ink,
        fontSize: 12,
        fontFamilyFallback: burmeseFallback,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: DfColors.secondary,
      linearTrackColor: DfColors.line,
      circularTrackColor: DfColors.line,
      refreshBackgroundColor: DfColors.surface,
    ),
  );
}
