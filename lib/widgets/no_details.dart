import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NoDetails extends StatelessWidget {
  final String text;
  const NoDetails(this.text);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: 100.w,
      child: Center(
        child: Text(
          text.tr(),
        ),
      ),
    );
  }
}
