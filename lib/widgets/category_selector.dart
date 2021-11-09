import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'selectable_row.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SelectableRow(
      textList: [
        'food',
        'drink',
        // 'vapes',
        'other',
      ],
      type: 'category',
    );
  }
}
