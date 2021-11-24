import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../app.dart';
import '../../../main.dart';

class DeleteAccount extends HookWidget {
  const DeleteAccount({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RawMaterialButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  insetPadding: const EdgeInsets.all(1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Center(
                    child: Text(
                      'confirm'.tr(),
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          '${'sureYouWant'.tr()} ${'deleteYourAccount'.tr()}?'),
                      Text('everythingWillBeLost'.tr()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RawMaterialButton(
                            onPressed: () async {
                              await _user.deleteAccount();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const App(),
                                  ),
                                  (route) => false);
                            },
                            fillColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${'yes'.tr()} ${'deleteMyAccount'.tr()}',
                              ),
                            ),
                          ),
                          RawMaterialButton(
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'no'.tr(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Text(
            'deleteYourAccount'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
