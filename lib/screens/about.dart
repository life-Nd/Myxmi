import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:package_info/package_info.dart';

class AboutView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('aboutMyxmi'.tr()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _Version(),
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
      title: Row(
        children: [
          Text('appVersion'.tr()),
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (_, AsyncSnapshot<PackageInfo> data) {
              if (data != null) {
                return Text(data.data.version);
              }
              return const Text('-');
            },
          ),
        ],
      ),
    );
  }
}
