import 'package:flutter/material.dart';

ThemeData light({Color color = const Color(0xFFEF6937)}) => ThemeData(
  fontFamily: 'Roboto',
  primaryColor: color,
  secondaryHeaderColor: const Color(0xFFEF6937),
  disabledColor: const Color(0xFFBABFC4),
  backgroundColor: const Color(0xFFF3F3F3),
  errorColor: const Color(0xFFE84D4F),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  colorScheme: ColorScheme.light(primary: color, secondary: color),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
);