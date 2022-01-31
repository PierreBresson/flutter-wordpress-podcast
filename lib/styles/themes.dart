import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './fonts.dart';

const backgroundColor = Color(0xFFFAFAFA);

final ligthThemeDataThinkerview = ThemeData(
  primarySwatch: Colors.teal,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: backgroundColor,
  secondaryHeaderColor: Colors.black,
  dividerColor: Colors.white54,
  scaffoldBackgroundColor: Colors.white,
  textTheme: Fonts.textLightTheme,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
);

final darkThemeDataThinkerview = ThemeData(
  primarySwatch: Colors.teal,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: Colors.black,
  secondaryHeaderColor: Colors.white,
  dividerColor: Colors.black12,
  scaffoldBackgroundColor: Colors.black87,
  textTheme: Fonts.textDarkTheme,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
);

/* generated thanks to http://mcg.mbitson.com */
const MaterialColor primaryCauseCommune =
    MaterialColor(_primaryPrimaryValueCauseCommune, <int, Color>{
  50: Color(0xFFFCE6EB),
  100: Color(0xFFF8C1CD),
  200: Color(0xFFF398AC),
  300: Color(0xFFEE6E8B),
  400: Color(0xFFEA4F72),
  500: Color(_primaryPrimaryValueCauseCommune),
  600: Color(0xFFE32B51),
  700: Color(0xFFDF2448),
  800: Color(0xFFDB1E3E),
  900: Color(0xFFD5132E),
});
const int _primaryPrimaryValueCauseCommune = 0xFFE63059;

final ligthThemeDataCauseCommune = ThemeData(
  primarySwatch: primaryCauseCommune,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: backgroundColor,
  secondaryHeaderColor: Colors.black,
  dividerColor: Colors.white54,
  scaffoldBackgroundColor: Colors.white,
  textTheme: Fonts.textLightTheme,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
);

final darkThemeDataCauseCommune = ThemeData(
  primarySwatch: primaryCauseCommune,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: Colors.black,
  secondaryHeaderColor: Colors.white,
  dividerColor: Colors.black12,
  scaffoldBackgroundColor: Colors.black87,
  textTheme: Fonts.textDarkTheme,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
);
