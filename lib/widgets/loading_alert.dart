import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

void loadingAlertDialog({@required BuildContext context}) {
  Size _size = MediaQuery.of(context).size;
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              (20),
            ),
          ),
        ),
        insetPadding: EdgeInsets.all(1),
        contentPadding: EdgeInsets.all(1),
        title: Center(child: Text("${'loading'.tr()}...")),
        content: Container(
          height: _size.height / 3,
          width: _size.width / 1.2,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    },
  );
}
