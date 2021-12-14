import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

String language = 'en';
const String constLanguageCode = 'languageCode';
const String constEnglish = 'en';
const String constFrench = 'fr';

final prefProvider =
    ChangeNotifierProvider<PreferencesProvider>((ref) => PreferencesProvider());

class PreferencesProvider extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? theme = 'Light';
  String? language = 'English';
  bool? opaque = false;

  Future changeOpaque({bool? newOpaque}) async {
    final SharedPreferences prefs = await _prefs;
    opaque = newOpaque;
    prefs.setBool('Opaque', opaque!).then(
      (bool success) {
        return opaque;
      },
    );

    notifyListeners();
  }

  Future changeLanguage({String? newLanguage}) async {
    final SharedPreferences prefs = await _prefs;
    language = newLanguage;
    prefs.setString('Language', language!).then(
      (bool success) {
        return language;
      },
    );

    notifyListeners();
  }

  Future changeTheme({String? newTheme}) async {
    final SharedPreferences prefs = await _prefs;
    theme = newTheme;
    prefs.setString('Theme', theme!).then(
      (bool success) {
        return theme;
      },
    );
    notifyListeners();
  }

  Future _readTheme() async {
    final SharedPreferences prefs = await _prefs;
    return theme = prefs.getString('Theme');
  }

  Future _readLanguage() async {
    final SharedPreferences prefs = await _prefs;
    return language = prefs.getString('Language');
  }

  Future<List> readPrefs() {
    final Future<List> _data = Future.wait([
      _readTheme(),
      _readLanguage(),
    ]);
    return _data;
  }

  Locale _locale(String languageCode) {
    switch (languageCode) {
      case constEnglish:
        return const Locale(constEnglish, 'US');
      case constFrench:
        return const Locale(constFrench, 'FR');
      default:
        return const Locale(constEnglish, 'US');
    }
  }

  Future<Locale> setLocale(String languageCode) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(constLanguageCode, languageCode);
    return _locale(languageCode);
  }

  Future<Locale> getLocale() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String languageCode = _prefs.getString(constLanguageCode) ?? 'en';
    return _locale(languageCode);
  }

  // String? getTranslated(BuildContext context, String key) {
  //   return translate(key);
  // }

  // String? translate(String key) {
  //   late Map<String, String> _localizedValues;
  //   return _localizedValues[key];
  // }
}
