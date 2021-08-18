import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:sizer/sizer.dart';
import 'selectable_row.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
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
            'food',
            'drink',
            // 'vapes',
            'other',
          ],
          type: 'category',
        ),
      ),
    );
  }
}

class SelectorButton extends StatelessWidget {
  final String value;
  final String type;
  const SelectorButton({Key key, @required this.type, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _recipe = watch(recipeProvider);
      final String _key = type == 'category'
          ? _recipe.recipeModel.category
          : _recipe.recipeModel.subCategory;
      final bool _selected = _key == value;
      return RawMaterialButton(
        padding: const EdgeInsets.only(left: 8, right: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        fillColor: _selected ? Colors.green : Theme.of(context).cardColor,
        onPressed: () {
          type == 'category'
              ? _recipe.changeCategory(newCategory: value)
              : _recipe.changeSubCategory(newSubCategory: value);
        },
        child: Text(value.tr()),

      );
    });
  }
}
