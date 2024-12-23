import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  
  appBarTheme: AppBarTheme(
    backgroundColor:  Colors.blueGrey[900]!,
    elevation: 0,
    toolbarHeight: 80,   
    iconTheme: const IconThemeData(color: Colors.blue),
  ),
  colorScheme: ColorScheme.dark(
    primary: Colors.blueGrey[900]!,
    secondary: const Color.fromARGB(255, 8, 112, 197),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    
    surface: Colors.grey[850]!,
    onSurface: Colors.white,
  ),
  textTheme: TextTheme(
    headlineLarge : const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium
    : const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    bodyLarge: const TextStyle(color: Colors.white, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.grey[400], fontSize: 14),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blue, // Apply secondary color to buttons
    textTheme: ButtonTextTheme.primary,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor : Colors.blue,
      foregroundColor: Colors.white,

    ),
  ),
  iconTheme: const IconThemeData(color: Colors.blue),
  dividerColor: Colors.grey[700],
);