import 'package:flutter/material.dart';

ThemeData appTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
  );
  return base.copyWith(
    appBarTheme: const AppBarTheme(centerTitle: true),
    cardTheme: const CardThemeData(
      margin: EdgeInsets.all(12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  );
}
