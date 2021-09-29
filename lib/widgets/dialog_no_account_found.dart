import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/utils/auth.dart';

import 'retry_button.dart';

Future<dynamic> dialogNoAccountFound(
    {@required BuildContext context,
    @required String email,
    @required String password,
    @required FirebaseAuthException error}) {
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
          subtitle: Text(error.message.toString()),
          title: Text(
            'noAccountFound'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
        ),
        actions: [
          const RetryButton(),
          SignUpButton(
            email: email,
            password: password,
          ),
        ],
      );
    },
  );
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    Key key,
    @required this.email,
    @required this.password,
  }) : super(key: key);
  final String email;
  final String password;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: const EdgeInsets.all(4),
      elevation: 20,
      fillColor: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: () {
        AuthServices().newUserEmailPassword(
            email: email, password: password, context: context);
      },
      child: Text(
        'signUp'.tr(),
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
