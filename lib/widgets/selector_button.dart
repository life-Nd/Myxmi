import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_infos_to_recipe.dart';

class SelectorButton extends StatelessWidget {
  final String value;
  final String type;
  const SelectorButton({Key key, @required this.type, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _recipe = watch(recipeEntriesProvider);
      final String _key = type == 'category'
          ? _recipe.recipe.category
          : type == 'subcategory'
              ? _recipe.recipe.subCategory
              : _recipe.recipe.diet;
      final bool _selected = _key == value;
      return RawMaterialButton(
        // padding: const EdgeInsets.only(left: 8, right: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        fillColor: _selected ? Colors.green : Theme.of(context).cardColor,
        onPressed: () {
          type == 'category'
              ? _recipe.changeCategory(newCategory: value)
              : type == 'subcategory'
                  ? _recipe.changeSubCategory(newSubCategory: value)
                  : _recipe.changeDiet(newDiet: value);
        },
        child: Text(value.tr()),
      );
    });
  }
}
