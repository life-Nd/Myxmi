import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'reset_password_button.dart';

Future<dynamic> dialogResetPassword({BuildContext context, String email}) {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding:
            const EdgeInsets.only(top: 40, bottom: 40, left: 1, right: 1.0),
        title: Text('sendResetLink'.tr()),
        content: ListTile(
          title: email.isNotEmpty
              ? Row(
                  children: [
                    Text('${'emailLabel'.tr()}: '),
                    Expanded(
                      child: Text(
                        ' $email',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              : Text(
                  'invalidEmailEmpty'.tr(),
                  style: const TextStyle(fontSize: 17, color: Colors.red),
                ),
          subtitle: Text(
            email.isNotEmpty
                ? '1.${'sendResetLink'.tr()} \n 2.${'checkEmail'.tr()}'
                : '${'please'.tr()} ${'enterEmail'.tr().toLowerCase()}',
          ),
        ),
        actions: [
          if (email.isNotEmpty)
            ResetPasswordButton(email: email)
          else
            RawMaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'close'.tr(),
              ),
            ),
        ],
      );
    },
  );
}
