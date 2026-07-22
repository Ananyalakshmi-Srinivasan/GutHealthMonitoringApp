import 'package:flutter/material.dart';

class TAppTheme {
  TAppTheme._();


  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(backgroundColor: const Color(0xFF1B9FAE),
      centerTitle: true,),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1B9FAE),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withValues(alpha: 0.7),
        selectedLabelStyle: const TextStyle(
          //fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        )),


  );
  static ThemeData darkTheme = ThemeData();




}