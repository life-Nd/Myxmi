import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'selectable_row.dart';

class DietSelector extends StatelessWidget {
  const DietSelector({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 7.h,
      child: const Center(
        child: SelectableRow(
          textList: [
            'vegan',
            'vegetarian',
            'keto',
            'other',
          ],
          type: 'diet',
        ),
      ),
    );
  }
}
