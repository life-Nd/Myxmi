import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

class DrinksSubCategories extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RawMaterialButton(
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'cocktail');
            },
            fillColor: _recipe.recipeModel.subCategory == 'cocktail'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('cocktail'.tr()),
          ),
          const SizedBox(
            width: 7,
          ),
          RawMaterialButton(
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'smoothie');
            },
            fillColor: _recipe.recipeModel.subCategory == 'smoothie'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('smoothie'.tr()),
          ),
          const SizedBox(
            width: 7,
          ),
          RawMaterialButton(
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'shake');
            },
            fillColor: _recipe.recipeModel.subCategory == 'shake'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('shake'.tr()),
          ),
          const SizedBox(
            width: 7,
          ),
          RawMaterialButton(
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'other');
            },
            fillColor: _recipe.recipeModel.subCategory == 'other'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('other'.tr()),
          )
        ],
      ),
    );
  }
}
