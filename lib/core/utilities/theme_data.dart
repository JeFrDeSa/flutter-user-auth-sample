// coverage:ignore-file
import 'package:u_auth/core/utilities/ui_properties.dart' as ui_properties;
import 'package:flutter/material.dart';

const _primaryDarkThemeColor = Color.fromARGB(0xff, 0x45, 0x5a, 0x64);
const _primaryDarkThemeColorLight = Color.fromARGB(0xff, 0x71, 0x87, 0x92);
const _primaryDarkThemeColorDark = Color.fromARGB(0xff, 0x78, 0x00, 0x2e);
const _disabledColorDarkTheme = Color.fromARGB(0xff, 0x88, 0x88, 0x88);
const _backgroundColorDarkTheme = Color.fromARGB(0xff, 0x12, 0x12, 0x12);
const _cardColorDarkTheme = Color.fromARGB(0xff, 0x42, 0x42, 0x42);
const _foregroundColorDarkTheme = Color.fromARGB(0xff, 0xf2, 0xf2, 0xf2);

const _primaryLightThemeColor = Color.fromARGB(0xff, 0xff, 0xec, 0xb3);
const _primaryLightThemeColorLight = Color.fromARGB(0xff, 0xff, 0xff, 0xe5);
const _primaryLightThemeColorDark = Color.fromARGB(0xff, 0xcb, 0xba, 0x83);
const _disabledColorLightTheme = Color.fromARGB(0xff, 0x99, 0x99, 0x99);
const _backgroundColorLightTheme = Color.fromARGB(0xff, 0xe9, 0xe9, 0xe9);
const _cardColorLightTheme = Color.fromARGB(0xff, 0xf9, 0xf9, 0xf9);
const _foregroundColorLightTheme = Colors.black;

IconThemeData _iconTheme({required Color iconColor}) => IconThemeData(color: iconColor);

TextTheme _textTheme({required Color textColor}) {
  return TextTheme(
    bodyText1: TextStyle(color: textColor, fontWeight: FontWeight.normal, fontSize: 16),
    bodyText2: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
    headline1: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 32),
    headline2: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 24),
    headline3: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
  );
}

const RoundedRectangleBorder _defaultRoundedBoarders = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(ui_properties.widgetBoarderRadius),
);

ButtonStyle _defaultButtonStyle(Color foregroundColor, Color backgroundColor) {
  double overlayOpacity = 0.3;
  return ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(foregroundColor),
    backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
    shape: MaterialStateProperty.all<OutlinedBorder>(_defaultRoundedBoarders),
    overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(overlayOpacity)),
  );
}

TextButtonThemeData _textButtonTheme(Color foregroundColor, Color backgroundColor) {
  return TextButtonThemeData(style: _defaultButtonStyle(foregroundColor, backgroundColor));
}

ElevatedButtonThemeData _elevatedButtonTheme(Color foregroundColor, Color backgroundColor) {
  return ElevatedButtonThemeData(
    style: _defaultButtonStyle(foregroundColor, backgroundColor).copyWith(
      elevation: MaterialStateProperty.all<double>(ui_properties.widgetElevationMedium),
    ),
  );
}

CardTheme _cardTheme(Color cardColor) {
  return CardTheme(
    color: cardColor,
    shape: _defaultRoundedBoarders,
    elevation: ui_properties.widgetElevationMedium,
  );
}

/// The [ThemeData] configuration for a dark theme
final darkTheme = ThemeData(
  fontFamily: 'LocalAssetFont',
  brightness: Brightness.dark,
  primaryColor: _primaryDarkThemeColor,
  primaryColorLight: _primaryDarkThemeColorLight,
  primaryColorDark: _primaryDarkThemeColorDark,
  disabledColor: _disabledColorDarkTheme,
  backgroundColor: _backgroundColorDarkTheme,
  iconTheme: _iconTheme(iconColor: _foregroundColorDarkTheme),
  textTheme: _textTheme(textColor: _foregroundColorDarkTheme),
  textButtonTheme: _textButtonTheme(_foregroundColorDarkTheme, Colors.transparent),
  elevatedButtonTheme: _elevatedButtonTheme(_foregroundColorDarkTheme, _primaryDarkThemeColorDark),
  cardTheme: _cardTheme(_cardColorDarkTheme),
);

/// The [ThemeData] configuration for a light theme
final lightTheme = ThemeData(
  fontFamily: 'LocalAssetFont',
  brightness: Brightness.light,
  primaryColor: _primaryLightThemeColor,
  primaryColorLight: _primaryLightThemeColorLight,
  primaryColorDark: _primaryLightThemeColorDark,
  disabledColor: _disabledColorLightTheme,
  backgroundColor: _backgroundColorLightTheme,
  iconTheme: _iconTheme(iconColor: _foregroundColorLightTheme),
  textTheme: _textTheme(textColor: _foregroundColorLightTheme),
  textButtonTheme: _textButtonTheme(_foregroundColorLightTheme, Colors.transparent),
  elevatedButtonTheme: _elevatedButtonTheme(_foregroundColorLightTheme, _primaryLightThemeColorDark),
  cardTheme: _cardTheme(_cardColorLightTheme),
);
