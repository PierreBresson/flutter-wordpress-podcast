import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './fonts.dart';

final ligthThemeData = ThemeData(
  primarySwatch: Colors.teal,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  secondaryHeaderColor: Colors.black,
  dividerColor: Colors.white54,
  scaffoldBackgroundColor: Colors.white,
  textTheme: Fonts.textLightTheme,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
);

final darkThemeData = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  secondaryHeaderColor: Colors.white,
  dividerColor: Colors.black12,
  scaffoldBackgroundColor: Colors.black87,
  textTheme: Fonts.textDarkTheme,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
);
