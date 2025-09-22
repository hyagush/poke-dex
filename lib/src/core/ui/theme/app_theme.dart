import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFFdc0a2d);
  static const _secondary = Color(0xFF35aad6);
  static const _tertiary = Color(0xFF232323);
  static const _background = Color.fromARGB(255, 240, 240, 240);

  ThemeData lightTheme() {
    return ThemeData(
      fontFamily: 'Lato',
      scaffoldBackgroundColor: _background,
      primarySwatch: generateMaterialColor(_primary),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: _primary,
        onPrimary: getContrastingColor(_primary),
        secondary: _secondary,
        onSecondary: getContrastingColor(_secondary),
        tertiary: _tertiary,
        onTertiary: getContrastingColor(_tertiary),
        error: Colors.red,
        onError: Colors.white,
        surface: _background,
        onSurface: getContrastingColor(_background),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          disabledBackgroundColor: Colors.grey[500],
          disabledForegroundColor: Colors.grey[300],
          disabledIconColor: Colors.grey[300],
          elevation: 3,
          backgroundColor: _tertiary,
          foregroundColor: getContrastingColor(_tertiary),
          iconColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          visualDensity: VisualDensity.compact,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        hintStyle: TextStyle(color: Color.fromARGB(255, 50, 107, 58)),
        contentPadding: const EdgeInsets.all(10),
        isCollapsed: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: _tertiary,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: _tertiary,
          ),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF212026),
          fontWeight: FontWeight.normal,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: _tertiary),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide.none,
        ),
        fillColor: const Color(0xFF52ae5f),
      ),
      iconTheme: IconThemeData(color: getContrastingColor(_primary)),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(
            getContrastingColor(_primary),
          ),
        ),
      ),
      checkboxTheme: const CheckboxThemeData(
        side: BorderSide(width: 1.5, color: Color(0xFF272626)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        visualDensity: VisualDensity.compact,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: Color(0xFF272626),
          overflow: TextOverflow.ellipsis,
        ),
        headlineMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          color: Color(0xFF272626),
          overflow: TextOverflow.ellipsis,
        ),
        headlineSmall: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: Color(0xFF272626),
          overflow: TextOverflow.ellipsis,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: Color(0xFF272626),
          overflow: TextOverflow.ellipsis,
        ),
        bodySmall: TextStyle(
          fontSize: 8.0,
          fontWeight: FontWeight.w400,
          color: Color(0xFF646464),
          overflow: TextOverflow.ellipsis,
        ),
        displayLarge: TextStyle(
          fontSize: 36.0,
          fontWeight: FontWeight.w900,
          color: Color(0xFF272626),
          overflow: TextOverflow.ellipsis,
        ),
        labelLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Color(0xFF272626),
          overflow: TextOverflow.ellipsis,
        ),
        labelMedium: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: Color(0xFF272626),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

int getColorValue(Color color) {
  return (color.a.round() << 24) |
      (color.r.round() << 16) |
      (color.g.round() << 8) |
      color.b.round();
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(getColorValue(color), <int, Color>{
    50: _tintColor(color, 0.9),
    100: _tintColor(color, 0.8),
    200: _tintColor(color, 0.6),
    300: _tintColor(color, 0.4),
    400: _tintColor(color, 0.2),
    500: color,
    600: _shadeColor(color, 0.1),
    700: _shadeColor(color, 0.2),
    800: _shadeColor(color, 0.3),
    900: _shadeColor(color, 0.4),
  });
}

Color _tintColor(Color color, double factor) => Color.fromRGBO(
  color.r.round() + ((255 - color.r.round()) * factor).round(),
  color.g.round() + ((255 - color.g.round()) * factor).round(),
  color.b.round() + ((255 - color.b.round()) * factor).round(),
  1,
);

Color _shadeColor(Color color, double factor) => Color.fromRGBO(
  (color.r.round() * (1 - factor)).round(),
  (color.g.round() * (1 - factor)).round(),
  (color.b.round() * (1 - factor)).round(),
  1,
);

Color getContrastingColor(Color color) {
  double luminance =
      (0.299 * color.r.round() + 0.587 * color.g.round() + 0.114 * color.b.round()) / 255;

  return luminance > 0.5 ? AppTheme._tertiary : AppTheme._background;
}
