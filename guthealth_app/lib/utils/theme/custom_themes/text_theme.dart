import 'package:flutter/material.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(

      displayLarge: const TextStyle().copyWith(
        color: Color(0xFF1B9FAE),
        fontSize: 50,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: const TextStyle().copyWith(
        color: Color(0xFF1B9FAE),
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: const TextStyle().copyWith(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: const TextStyle().copyWith(
        color: Colors.black,
        fontSize: 18,
      ),
      bodySmall: const TextStyle().copyWith(
        color: Colors.black,
        fontSize: 12,
      ),
      labelSmall: const TextStyle().copyWith(
        color: Colors.black,
        fontSize: 11,
      )


  );
  static TextTheme darkTextTheme = TextTheme(
      displayLarge: const TextStyle().copyWith(
        color: Color(0xFFE0868D),
        fontSize: 50,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: const TextStyle().copyWith(
        color: Color(0xFFE0868D),
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: const TextStyle().copyWith(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: const TextStyle().copyWith(
        color: Colors.white,
        fontSize: 15,
      ),

      bodySmall: const TextStyle().copyWith(
        color: Colors.white,
        fontSize: 12,
      ),
      labelSmall: const TextStyle().copyWith(
        color: Colors.white,
        fontSize: 11,
      )
  );



}