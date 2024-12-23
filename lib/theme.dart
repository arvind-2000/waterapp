import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  
  appBarTheme: const AppBarTheme(
    backgroundColor:  Colors.white,
    foregroundColor: Colors.white,
    elevation: 0,
    toolbarHeight: 80,   
    iconTheme: IconThemeData(color: Colors.blue),
  ),
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme(
    error: Colors.red,
    onError: Colors.white,
  brightness: Brightness.dark,
    primary: Colors.grey[100]!,
    secondary: const Color.fromARGB(255, 2, 44, 105),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    
    surface: Colors.grey[850]!,
    onSurface: Colors.grey[900]!,
  ),
  textTheme: TextTheme(
  
    headlineLarge :TextStyle(color: Colors.grey[900]!, fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium
    :  TextStyle(color:Colors.grey[900]!, fontSize: 24, fontWeight: FontWeight.bold),
    bodyLarge:  TextStyle(color: Colors.grey[900]!, fontSize: 16),
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