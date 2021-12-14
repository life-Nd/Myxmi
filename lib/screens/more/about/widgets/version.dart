import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:package_info/package_info.dart';

class Version extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.layers),
      title: Text('${'appVersion'.tr()} '),
      subtitle: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (_, AsyncSnapshot<PackageInfo> data) {
          if (data.data != null) {
            return Text(data.data!.version);
          }
          return const Text('-');
        },
      ),
    );
  }
}
