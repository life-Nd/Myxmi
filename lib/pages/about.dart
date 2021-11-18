import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myxmi/providers/app_sources.dart';
import 'package:package_info/package_info.dart';

class AboutView extends HookWidget {
  final AppSourcesProvider _appSources = AppSourcesProvider();
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
              _appSources.launchURL(url: _privacyUrl);
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
                   _appSources.launchURL(url: _termsUrl);
            },
            title: Text(
              'terms'.tr(),
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: const Text(_termsUrl),
          ),
          if (!kIsWeb) _Version(),
        ],
      ),
    );
  }
}

class _Version extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.layers),
      title: Text('${'appVersion'.tr()} '),
      subtitle: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (_, AsyncSnapshot<PackageInfo> data) {
          if (data != null && data?.data != null) {
            return Text(data?.data?.version);
          }
          return const Text('-');
        },
      ),
    );
  }
}
