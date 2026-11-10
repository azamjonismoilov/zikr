import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text.dart';

abstract final class AppTheme {
  static ThemeData get yorug => _qur(AppColors.yorug, Brightness.light);
  static ThemeData get tun => _qur(AppColors.tun, Brightness.dark);

  static ThemeData _qur(AppColors c, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: c.kok,
      brightness: brightness,
    ).copyWith(
      primary: c.kok,
      surface: c.fon,
      onSurface: c.matn,
      error: c.qizil,
      outline: c.chiziq,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.fon,
      fontFamily: 'Inter',
      textTheme: TextTheme(
        headlineMedium: AppText.h1,
        titleLarge: AppText.h2,
        titleMedium: AppText.h3,
        bodyMedium: AppText.matn,
        bodySmall: AppText.kichik,
        labelMedium: AppText.teg,
        labelLarge: AppText.tugma,
      ).apply(bodyColor: c.matn, displayColor: c.matn),
      splashFactory: NoSplash.splashFactory,
      extensions: [c],
    );
  }
}
