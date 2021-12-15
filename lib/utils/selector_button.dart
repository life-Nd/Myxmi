import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/recipe_entries.dart';

class SelectorButton extends StatelessWidget {
  final String? value;
  final String type;
  const SelectorButton({Key? key, required this.type, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _recipe = ref.watch(recipeEntriesProvider);
        String? _key;
        if (type == 'category') {
          _key = _recipe.category;
        } else if (type == 'subcategory') {
          _key = _recipe.subCategory;
        } else {
          _key = _recipe.diet;
        }
        final bool _selected = _key == value;
        return RawMaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          fillColor: _selected ? Colors.green : Theme.of(context).cardColor,
          onPressed: () {
            debugPrint('$type: $value');
            if (type == 'category') {
              _recipe.setCategory(newCategory: value);
            } else if (type == 'subcategory') {
              _recipe.setSubCategory(newSubCategory: value);
            } else {
              _recipe.setDiet(newDiet: value);
            }
          },
          child: Text(value!.tr()),
        );
      },
    );
  }
}
