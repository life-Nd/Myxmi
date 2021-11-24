import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../main.dart';

class ThemeSelector extends HookWidget {
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
                        }
                      : () {},
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
