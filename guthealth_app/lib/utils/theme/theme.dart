import 'package:flutter/material.dart';
import 'package:guthealth_app/utils/theme/custom_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();


  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(backgroundColor: const Color(0xFF1B9FAE), centerTitle: true,),
    textTheme: TTextTheme.lightTextTheme,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1B9FAE),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withValues(alpha: 0.7),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ))
  );
  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF191919),
    appBarTheme: AppBarTheme(backgroundColor: const Color(0xFF090808), centerTitle: true,),
    textTheme: TTextTheme.darkTextTheme,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(
            0xFF090808),
        selectedItemColor: const Color(0xFFE0868D), //const Color(0xFFE0868D),
        unselectedItemColor: Colors.white.withValues(alpha: 0.7),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ))
  );




}