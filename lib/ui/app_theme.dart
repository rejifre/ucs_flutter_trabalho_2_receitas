import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData appTheme = ThemeData.dark().copyWith(
    elevatedButtonTheme: ElevatedButtonThemeData(
      // Suggested code may be subject to a license. Learn more: ~LicenseLog:2697152554.
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Colors.black),
        backgroundColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey;
          } else if (states.contains(WidgetState.pressed)) {
            return AppColors.mainColor;
          }
          return const Color.fromARGB(255, 241, 237, 233);
        }),
      ),
    ),
  );
}
