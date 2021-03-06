import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myxmi/screens/more/about/widgets/version.dart';
import 'package:myxmi/utils/launch_url.dart';

class AboutScreen extends HookWidget {
  const AboutScreen({Key? key}) : super(key: key);
  static const String _privacyUrl = 'https://myxmi.flycricket.io/privacy.html';
  static const String _termsUrl = 'https://myxmi.flycricket.io/terms.html';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('aboutMyxmi'.tr()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            onTap: () {
              launchURL(url: _privacyUrl);
            },
            title: Text(
              'privacy'.tr(),
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: const Text(_privacyUrl),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            onTap: () {
              launchURL(url: _termsUrl);
            },
            title: Text(
              'terms'.tr(),
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: const Text(_termsUrl),
          ),
          if (!kIsWeb) Version(),
        ],
      ),
    );
  }
}
