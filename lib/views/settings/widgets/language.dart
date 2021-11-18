import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../main.dart';

class LanguageSelector extends HookWidget {
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
