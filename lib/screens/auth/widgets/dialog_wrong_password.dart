import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/screens/auth/widgets/dialog_reset_password.dart';
import 'package:myxmi/screens/auth/widgets/retry_button.dart';

Future<dynamic> dialogWrongPassword({
  required BuildContext context,
  required String email,
  FirebaseAuthException? error,
}) {
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
          title: Text(error?.message! ?? 'error'.tr()),
          subtitle: RawMaterialButton(
            onPressed: () {
              dialogResetPassword(context: context, email: email);
            },
            child: Text(
              'forgotPass'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        actions: const [RetryButton()],
      );
    },
  );
}
