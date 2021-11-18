import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'retry_button.dart';

Future<dynamic> dialogUnknownError({@required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.only(top: 40, bottom: 40),
        title: Center(
          child: Text(
            'error'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
        content: ListTile(
          subtitle: Text('unknownErrorOccured'.tr()),
          title: Text(
            'unknownError'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
        ),
        actions: const [
          RetryButton(),
        ],
      );
    },
  );
}
