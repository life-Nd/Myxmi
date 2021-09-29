import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  const RetryButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: RawMaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('retry'.tr()),
      ),
    );
  }
}
