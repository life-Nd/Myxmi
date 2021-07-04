import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../app.dart';

class SettingsScreen extends HookWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'settings'.tr(),
          style: TextStyle(),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          _Theme(),
          SizedBox(
            height: 10,
          ),
          _Language(),
        ],
      ),
    );
  }
}

class _Theme extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _prefs = useProvider(prefProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 4,
            ),
            Text('${'theme'.tr()}: '),
            Text(
              Theme.of(context).brightness == Brightness.light
                  ? '${'light'.tr()}'
                  : '${'dark'.tr()}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Theme.of(context).brightness == Brightness.light
                    ? Icon(
                        Icons.wb_sunny,
                        size: 20,
                        color: Colors.yellow.shade800,
                      )
                    : Text(''),
                RawMaterialButton(
                  elevation:
                      Theme.of(context).brightness == Brightness.light ? 20 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.transparent,
                  child: Text(
                    '${'light'.tr()}',
                    style: TextStyle(),
                  ),
                  onPressed: _prefs.theme != 'Light'
                      ? () {    
                          _prefs.changeTheme(newTheme: 'Light');
                        }
                      : () {},
                ),
              ],
            ),
            Column(
              children: [
                Theme.of(context).brightness == Brightness.dark
                    ? Icon(Icons.nights_stay,
                        size: 20, color: Colors.blueAccent)
                    : Text(''),
                RawMaterialButton(
                  elevation:
                      Theme.of(context).brightness == Brightness.dark ? 20 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.transparent,
                  child: Text(
                    '${'dark'.tr()}',
                    style: TextStyle(),
                  ),
                  onPressed: _prefs.theme != 'Dark'
                      ? () {
                          _prefs.changeTheme(newTheme: 'Dark');
                        }
                      : () {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Language extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _prefs = useProvider(prefProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 4,
            ),
            Text('${'language'.tr()}: '),
            Text(
              '${context.locale.toLanguageTag()}',
              style: TextStyle(fontWeight: FontWeight.w700),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              child: Column(
                children: [
                  _prefs.language == 'English' ||
                          context.locale.languageCode == 'en'
                      ? Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).accentColor,
                        )
                      : Icon(Icons.radio_button_unchecked,
                          color: Theme.of(context).cardColor),
                  Text('english'.tr()),
                ],
              ),
              onTap: _prefs.language != 'English'
                  ? () {
                      context.setLocale(Locale('en', 'US'));
                      _prefs.changeLanguage(newLanguage: 'English');
                    }
                  : () {},
            ),
            GestureDetector(
              child: Column(
                children: [
                  _prefs.language == 'French' ||
                          context.locale.languageCode == 'fr'
                      ? Icon(Icons.radio_button_checked,
                          color: Theme.of(context).accentColor)
                      : Icon(Icons.radio_button_unchecked,
                          color: Theme.of(context).cardColor),
                  SizedBox(
                    height: 2,
                  ),
                  Text('french'.tr()),
                ],
              ),
              onTap: _prefs.language != 'French'
                  ? () {
                      context.setLocale(Locale('fr', 'FR'));

                      _prefs.changeLanguage(newLanguage: 'French');
                    }
                  : () {},
            ),
          ],
        ),
      ],
    );
  }
}
