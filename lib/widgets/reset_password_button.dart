import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/services/auth.dart';

class ResetPasswordButton extends StatelessWidget {
  final String email;

  const ResetPasswordButton({Key key, @required this.email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        AuthServices().resetPassword(emailCtrl: email);
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.only(top: 40, bottom: 40),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'checkEmail'.tr(),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    backgroundColor: Colors.green,
                  ),
                ],
              ),
              actions: [
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
      },
      child: Text('send'.tr()),
    );
  }
}