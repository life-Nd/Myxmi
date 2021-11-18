import 'package:flutter/material.dart';
import '../selectable_row.dart';

class VapeSubCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SelectableRow(textList: [
      'nicotine',
      'thc',
      'cbd',
      'other',
    ], type: 'subcategory');
  }
}
