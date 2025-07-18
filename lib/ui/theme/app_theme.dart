import 'package:flutter/material.dart';

Color lighten(Color color, [double amount = .25]) {
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return hslLight.toColor();
}

class AppTheme {
  static ThemeData light(Color mainColor) {
    final lightPrimary = lighten(mainColor, 0.25);

    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: mainColor,
        secondary: lightPrimary, 
        background: Colors.white,
        onPrimary: Colors.black,
        onBackground: Colors.black,
      ),
      primaryColor: mainColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: mainColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: mainColor.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.all(
          const IconThemeData(color: Colors.black87),
        ),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(color: Colors.black87),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(mainColor),
        trackColor: WidgetStateProperty.all(mainColor.withValues(alpha: 0.5)),
      ),
    );
  }

  static ThemeData dark(Color mainColor) {
    final lightPrimary = lighten(mainColor, 0.25);

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: mainColor,
        secondary: lightPrimary, 
        background: Colors.black,
        onPrimary: Colors.white,
        onBackground: Colors.white,
      ),
      primaryColor: mainColor,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.grey[900],
        indicatorColor: mainColor.withValues(alpha: 0.18),
        iconTheme: WidgetStateProperty.all(
          const IconThemeData(color: Colors.white),
        ),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(color: Colors.white),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(mainColor),
        trackColor: WidgetStateProperty.all(mainColor.withValues(alpha: 0.5)),
      ),
    );
  }
}
