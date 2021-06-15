import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String language = 'en';
const String LAGUAGE_CODE = 'languageCode';
const String ENGLISH = 'en';
const String FRENCH = 'fr';

class PreferencesProvider extends ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String theme = 'Light';
  String language = 'English';
  bool opaque = false;
  changeTheme({String newTheme}) async {
    final SharedPreferences prefs = await _prefs;
    theme = newTheme;
    prefs.setString('Theme', theme).then((bool success) {
      return theme;
    });
    notifyListeners();
  }

  changeOpaque({bool newOpaque}) async {
    final SharedPreferences prefs = await _prefs;
    opaque = newOpaque;
    prefs.setBool('Opaque', opaque).then((bool success) {
      return opaque;
    });

    notifyListeners();
  }

  changeLanguage({String newLanguage}) async {
    final SharedPreferences prefs = await _prefs;
    language = newLanguage;
    prefs.setString('Language', language).then((bool success) {
      return language;
    });

    notifyListeners();
  }

  readTheme() async {
    final SharedPreferences prefs = await _prefs;
    theme = prefs.getString('Theme');
    return theme;
  }

  readLanguage() async {
    final SharedPreferences prefs = await _prefs;
    language = prefs.getString('Language');
    return language;
  }

  Locale _locale(String languageCode) {
    switch (languageCode) {
      case ENGLISH:
        return Locale(ENGLISH, 'US');
      case FRENCH:
        return Locale(FRENCH, 'FR');
      default:
        return Locale(ENGLISH, 'US');
    }
  }

  Future<Locale> setLocale(String languageCode) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(LAGUAGE_CODE, languageCode);
    return _locale(languageCode);
  }

  Future<Locale> getLocale() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(LAGUAGE_CODE) ?? 'en';
    return _locale(languageCode);
  }

  String getTranslated(BuildContext context, String key) {
    return translate(key);
  }

  String translate(String key) {
    Map<String, String> _localizedValues;
    return _localizedValues[key];
  }
}
