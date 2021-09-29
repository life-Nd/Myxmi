import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main.dart';

class SettingsScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'settings'.tr(),
          style: const TextStyle(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _Theme(),
          const SizedBox(
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
          children: [
            const SizedBox(
              width: 4,
            ),
            Text('${'theme'.tr()}: '),
            Text(
              Theme.of(context).brightness == Brightness.light
                  ? 'light'.tr()
                  : 'dark'.tr(),
              style: const TextStyle(
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
                if (Theme.of(context).brightness == Brightness.light)
                  Icon(
                    Icons.wb_sunny,
                    size: 20,
                    color: Colors.yellow.shade800,
                  )
                else
                  const Text(''),
                RawMaterialButton(
                  elevation:
                      Theme.of(context).brightness == Brightness.light ? 20 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.transparent,
                  onPressed: _prefs.theme != 'Light'
                      ? () {
                          _prefs.changeTheme(newTheme: 'Light');
                        }
                      : () {},
                  child: Text(
                    'light'.tr(),
                    style: const TextStyle(),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                if (Theme.of(context).brightness == Brightness.dark)
                  const Icon(Icons.nights_stay,
                      size: 20, color: Colors.blueAccent)
                else
                  const Text(''),
                RawMaterialButton(
                  elevation:
                      Theme.of(context).brightness == Brightness.dark ? 20 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.transparent,
                  onPressed: _prefs.theme != 'Dark'
                      ? () {
                          _prefs.changeTheme(newTheme: 'Dark');
                          debugPrint('THEME:${_prefs.theme}');
                        }
                      : () {
                          debugPrint('THEME is ?DARK?:${_prefs.theme}');
                        },
                  child: Text(
                    'dark'.tr(),
                    style: const TextStyle(),
                  ),
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
          children: [
            const SizedBox(
              width: 4,
            ),
            Text('${'language'.tr()}: '),
            Text(
              context.locale.toLanguageTag(),
              style: const TextStyle(fontWeight: FontWeight.w700),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: _prefs.language != 'English'
                  ? () {
                      context.setLocale(const Locale('en', 'US'));
                      _prefs.changeLanguage(newLanguage: 'English');
                    }
                  : () {},
              child: Column(
                children: [
                  if (_prefs.language == 'English' ||
                      context.locale.languageCode == 'en')
                    Icon(
                      Icons.radio_button_checked,
                      color: Theme.of(context).backgroundColor,
                    )
                  else
                    Icon(Icons.radio_button_unchecked,
                        color: Theme.of(context).cardColor),
                  Text('english'.tr()),
                ],
              ),
            ),
            GestureDetector(
              onTap: _prefs.language != 'French'
                  ? () {
                      context.setLocale(const Locale('fr', 'FR'));

                      _prefs.changeLanguage(newLanguage: 'French');
                    }
                  : () {},
              child: Column(
                children: [
                  if (_prefs.language == 'French' ||
                      context.locale.languageCode == 'fr')
                    Icon(
                      Icons.radio_button_checked,
                      color: Theme.of(context).backgroundColor,
                    )
                  else
                    Icon(Icons.radio_button_unchecked,
                        color: Theme.of(context).cardColor),
                  const SizedBox(
                    height: 2,
                  ),
                  Text('french'.tr()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
