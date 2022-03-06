import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fwp/styles/fonts.dart';
import 'package:macos_ui/macos_ui.dart';

bool isAppInDarkMode(BuildContext context) {
  final brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.dark;
}

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

// CAUSE COMMUNE

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
  primaryColor: Colors.white,
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

final darkThemeDataMacOSCauseCommune = MacosThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryCauseCommune,
  canvasColor: CupertinoColors.systemBackground.darkElevatedColor,
  pushButtonTheme: const PushButtonThemeData(
    color: primaryCauseCommune,
    disabledColor: Colors.grey,
    secondaryColor: Colors.amber,
  ),
  dividerColor: Colors.black,
  macosIconButtonThemeData: const MacosIconButtonThemeData(
    backgroundColor: primaryCauseCommune,
    disabledColor: Colors.grey,
  ),
  iconTheme: const MacosIconThemeData(
    color: Colors.white,
  ),
);

final lightThemeDataMacOSCauseCommune = MacosThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryCauseCommune,
  canvasColor: CupertinoColors.systemBackground,
  pushButtonTheme: const PushButtonThemeData(
    color: primaryCauseCommune,
    disabledColor: Colors.grey,
    secondaryColor: Colors.amber,
  ),
  dividerColor: Colors.white,
  macosIconButtonThemeData: const MacosIconButtonThemeData(
    backgroundColor: primaryCauseCommune,
    disabledColor: Colors.grey,
  ),
  iconTheme: const MacosIconThemeData(
    color: Colors.white,
  ),
);

// THINKERVIEW

final lightThemeDataMacOSThinkerview = MacosThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.teal,
  canvasColor: CupertinoColors.systemBackground,
  pushButtonTheme: const PushButtonThemeData(
    color: Colors.teal,
    disabledColor: Colors.grey,
    secondaryColor: Colors.amber,
  ),
  dividerColor: Colors.white,
  macosIconButtonThemeData: const MacosIconButtonThemeData(
    backgroundColor: Colors.teal,
    disabledColor: Colors.grey,
  ),
);

final darkThemeDataMacOSThinkerview = MacosThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.teal,
  canvasColor: CupertinoColors.systemBackground.darkElevatedColor,
  pushButtonTheme: const PushButtonThemeData(
    color: Colors.teal,
    disabledColor: Colors.grey,
    secondaryColor: Colors.amber,
  ),
  dividerColor: Colors.black,
  macosIconButtonThemeData: const MacosIconButtonThemeData(
    backgroundColor: Colors.teal,
    disabledColor: Colors.grey,
  ),
);

class AppTheme extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  set mode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }
}

class FWPTypography {
  final BuildContext context;
  FWPTypography(this.context);

  TextStyle h1() {
    if (Platform.isMacOS) {
      return MacosTheme.of(context).typography.title1;
    }
    return Theme.of(context).textTheme.headline1!;
  }

  TextStyle h2() {
    if (Platform.isMacOS) {
      return MacosTheme.of(context).typography.title1;
    }
    return Theme.of(context).textTheme.headline2!;
  }

  TextStyle h3() {
    if (Platform.isMacOS) {
      return MacosTheme.of(context).typography.title2;
    }
    return Theme.of(context).textTheme.headline3!;
  }

  TextStyle h4() {
    if (Platform.isMacOS) {
      return MacosTheme.of(context).typography.title2;
    }
    return Theme.of(context).textTheme.headline4!;
  }

  TextStyle h5() {
    if (Platform.isMacOS) {
      return MacosTheme.of(context).typography.title3;
    }
    return Theme.of(context).textTheme.headline5!;
  }

  TextStyle h6() {
    if (Platform.isMacOS) {
      return MacosTheme.of(context).typography.title1;
    }
    return Theme.of(context).textTheme.headline6!;
  }

  TextStyle body1() {
    if (Platform.isMacOS) {
      return MacosTheme.of(context).typography.body;
    }
    return Theme.of(context).textTheme.bodyText1!;
  }

  TextStyle body2() {
    if (Platform.isMacOS) {
      return MacosTheme.of(context).typography.body;
    }
    return Theme.of(context).textTheme.bodyText2!;
  }
}
