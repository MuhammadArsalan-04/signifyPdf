import 'package:flutter/material.dart';
import 'package:signature_app/configs/app_colors.dart';

class AppTheme {
  static ThemeData getCustomTheme() {
    return ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.kPrimaryColors,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
            titleMedium: TextStyle(color: Colors.white, fontSize: 20)),
        colorSchemeSeed: const Color.fromRGBO(124, 77, 255, 1),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.kPrimaryColors,
          splashColor: AppColors.kFloatingActionSplashColor,
        )
        // colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kSecondaryColor),
        );
  }
}
