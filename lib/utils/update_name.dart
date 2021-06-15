import 'package:myxmi/widgets/name_field.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

updateName({@required BuildContext context, @required String displayName}) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            '${'displayName'.tr()}',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NameField(
                name: '$displayName',
              ),
            ],
          ),
          actions: [
            RawMaterialButton(
              child: Text(
                '${'done'.tr()}',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
