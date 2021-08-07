import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String language = 'en';
const String constLanguageCode = 'languageCode';
const String constEnglish = 'en';
const String constFrench = 'fr';

class PreferencesProvider extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String theme = 'Light';
  String language = 'English';
  List<String> cart = [];
  List<String> checkedItem = [];
  bool opaque = false;
  List<String> products = [];
  // TODO change

  Future changeOpaque({bool newOpaque}) async {
    final SharedPreferences prefs = await _prefs;
    opaque = newOpaque;
    prefs.setBool('Opaque', opaque).then((bool success) {
      return opaque;
    });

    notifyListeners();
  }

  Future changeLanguage({String newLanguage}) async {
    final SharedPreferences prefs = await _prefs;
    language = newLanguage;
    prefs.setString('Language', language).then((bool success) {
      return language;
    });

    notifyListeners();
  }


  Future editCart({@required String name}) async {
    final SharedPreferences prefs = await _prefs;
    cart ??= [];
    if (cart.contains(name)) {
      cart.remove(name);
    } else {
      cart.add(name);
    }
    prefs.setStringList('Cart', cart).then((bool success) {
      debugPrint('cart: $cart');
      return cart;
    });
    notifyListeners();
  }

  Future editItems({@required String item}) async {
    final SharedPreferences prefs = await _prefs;
    checkedItem ??= [];
    checkedItem.contains(item)
        ? checkedItem.remove(item)
        : checkedItem.add(item);
    prefs.setStringList('Items', checkedItem).then((bool success) {
      debugPrint('Item: $checkedItem');
      return checkedItem;
    });
    notifyListeners();
  }

  Future readCart() async {
    final SharedPreferences prefs = await _prefs;

    return cart = prefs.getStringList('Cart');
  }

  Future readItem() async {
    final SharedPreferences prefs = await _prefs;
    return cart = prefs.getStringList('Items');
  }

  Future changeTheme({String newTheme}) async {
    final SharedPreferences prefs = await _prefs;
    theme = newTheme;
    prefs.setString('Theme', theme).then((bool success) {
      return theme;
    });
    notifyListeners();
  }

  Future readTheme() async {
    final SharedPreferences prefs = await _prefs;
    await _readLanguage();
    return theme = prefs.getString('Theme');
  }

  Future _readLanguage() async {
    final SharedPreferences prefs = await _prefs;
    return language = prefs.getString('Language');
  }

  Future readPrefs() {
    final Future _data = Future.wait([
      readTheme(),
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

  String getTranslated(BuildContext context, String key) {
    return translate(key);
  }

  String translate(String key) {
    Map<String, String> _localizedValues;
    return _localizedValues[key];
  }
}
