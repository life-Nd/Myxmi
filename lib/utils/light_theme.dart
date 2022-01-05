import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
  primaryColor: Colors.grey.shade100,
  primaryColorBrightness: Brightness.light,
  primaryColorLight: Colors.grey.shade100,
  primaryColorDark: Colors.grey.shade800,
  canvasColor: Colors.grey.shade400,
  fontFamily: 'Georgia',
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyText1: TextStyle(color: Colors.black),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  appBarTheme: const AppBarTheme(
    shadowColor: Colors.white,
    color: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    elevation: 1,
    titleTextStyle: TextStyle(color: Colors.black),
  ),
  cardColor: const Color(0xFFD6D6D6),
  dividerColor: const Color(0x1f6D42CE),
  highlightColor: Colors.white,
  focusColor: Colors.grey.shade800,
  cardTheme: const CardTheme(margin: EdgeInsets.all(2)),
  colorScheme: const ColorScheme.light(),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blueAccent,
    shape: RoundedRectangleBorder(),
    textTheme: ButtonTextTheme.accent,
  ),
);
