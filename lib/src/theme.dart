import 'package:flutter/material.dart';

const ink = Color(0xFF16120E);
const paper = Color(0xFFF4EBDD);
const amber = Color(0xFFE09A3E);
const felt = Color(0xFF14352A);
const stage = Color(0xFF0C0A08);
const cardFace = Color(0xFFF7F1E6);
const muted = Color(0xFFC9BBA8);

ThemeData lanternTheme() {
  const scheme = ColorScheme.dark(
    primary: amber,
    onPrimary: Color(0xFF2A1B0C),
    secondary: felt,
    onSecondary: paper,
    surface: Color(0xFF241C16),
    onSurface: paper,
    error: Color(0xFFE07A68),
  );
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: ink,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
        color: paper,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: paper,
      ),
      bodyMedium: TextStyle(fontSize: 15, height: 1.35, color: paper),
      bodySmall: TextStyle(fontSize: 13, height: 1.35, color: muted),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ink,
      foregroundColor: paper,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: amber,
      foregroundColor: Color(0xFF2A1B0C),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2A221B),
      labelStyle: TextStyle(color: muted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1C1713),
      indicatorColor: const Color(0xFF3A2A18),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
