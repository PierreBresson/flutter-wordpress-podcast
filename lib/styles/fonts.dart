import 'package:flutter/material.dart';

abstract class Fonts {
  static const textLightTheme = TextTheme(
    headline1: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      fontWeight: FontWeight.w500,
    ),
    headline4: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    bodyText1: TextStyle(
      fontWeight: FontWeight.normal,
    ),
    bodyText2: TextStyle(
      fontWeight: FontWeight.normal,
    ),
    caption: TextStyle(
      fontWeight: FontWeight.w500,
    ),
    overline: TextStyle(
      fontWeight: FontWeight.w500,
    ),
  );

  static const textDarkTheme = TextTheme(
    headline1: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline3: TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    headline4: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline5: TextStyle(
      color: Colors.white,
    ),
    headline6: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyText1: TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodyText2: TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    caption: TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    overline: TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  );
}
