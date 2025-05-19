import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    color: Color(0xff1f004a),
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    isDense: true,
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
  ),
  useMaterial3: true,
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.green,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.green,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.green,
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xff1f004a),
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xff101418),
  inputDecorationTheme: const InputDecorationTheme(
    suffixIconColor: Colors.greenAccent,
    isDense: true,
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
    labelStyle: TextStyle(color: Colors.white54),
    hintStyle: TextStyle(color: Colors.white54),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Color(0xFF1e112b),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 24.0,
    ),
    contentTextStyle: TextStyle(
      color: Colors.white,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
  ),
  iconTheme: const IconThemeData(
    color: Colors.green,
  ),
);