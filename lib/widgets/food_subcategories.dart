import 'package:flutter/material.dart';
import 'selectable_row.dart';

class FoodSubCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SelectableRow(
      textList: [
        'appetizer',
        'salad',
        'soup',
        'dinner',
        'dessert',
        'other',
      ],
      type: 'subCategory',
    );
  }
}
