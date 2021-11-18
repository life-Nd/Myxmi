import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myxmi/views/settings/widgets/language.dart';
import 'package:myxmi/views/settings/widgets/theme.dart';

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
          ThemeSelector(),
          const SizedBox(
            height: 10,
          ),
          LanguageSelector(),
        ],
      ),
    );
  }
}
