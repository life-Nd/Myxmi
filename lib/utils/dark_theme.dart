import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
  primaryColor: Colors.black,
  primaryColorBrightness: Brightness.dark,
  primaryColorLight: Colors.grey.shade200,
  primaryColorDark: Colors.grey.shade800,
  canvasColor: Colors.black,
  fontFamily: 'Georgia',
  scaffoldBackgroundColor: Colors.black,
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(
    bodyText1: TextStyle(color: Colors.white),
  ),
  appBarTheme: const AppBarTheme(
    shadowColor: Colors.black,
    color: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    systemOverlayStyle: SystemUiOverlayStyle.light,
    titleTextStyle: TextStyle(color: Colors.white),
    elevation: 1,
  ),
  bottomAppBarColor: const Color(0xff6D42CE),
  timePickerTheme: const TimePickerThemeData(
    entryModeIconColor: Colors.orange,
    backgroundColor: Colors.black,
    dayPeriodColor: Colors.red,
    dayPeriodTextColor: Colors.blue,
    dialBackgroundColor: Colors.yellow,
  ),
  cardColor: const Color(0xFF303030),
  dividerColor: const Color(0x1f6D42CE),
  focusColor: Colors.grey.shade800,
  highlightColor: Colors.black,
  cardTheme: const CardTheme(margin: EdgeInsets.all(2)),
  colorScheme: const ColorScheme.dark(),
);
