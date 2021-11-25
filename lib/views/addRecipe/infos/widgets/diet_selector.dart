import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/utils/selectable_row.dart';

class DietSelector extends StatelessWidget {
  const DietSelector({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SelectableRow(
      textList: [
        'vegan',
        'vegetarian',
        'keto',
        'other',
      ],
      type: 'diet',
    );
  }
}
