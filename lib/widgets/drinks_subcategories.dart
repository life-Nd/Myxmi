import 'package:flutter/material.dart';
import 'selectable_row.dart';

class DrinksSubCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SelectableRow(
      textList: [
        'cocktail',
        'smoothie',
        'shake',
        'other',
      ],
      type: 'subcategory',
    );
  }
}
