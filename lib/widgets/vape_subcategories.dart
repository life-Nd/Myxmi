import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

class VapeSubCategories extends HookWidget {
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RawMaterialButton(
            child: Text('base'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Base');
            },
            fillColor: _recipe.recipe.subCategory == 'Base'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('flavour'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Flavour');
            },
            fillColor: _recipe.recipe.subCategory == 'Flavour'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('other'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Other');
            },
            fillColor: _recipe.recipe.subCategory == 'Other'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          )
        ],
      ),
    );
  }
}
