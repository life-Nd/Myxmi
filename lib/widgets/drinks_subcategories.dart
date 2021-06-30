import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

class DrinksSubCategories extends HookWidget {
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RawMaterialButton(
            child: Text('cocktail'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'cocktail');
            },
            fillColor: _recipe.details.subCategory == 'cocktail'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 7,
          ),
          RawMaterialButton(
            child: Text('smoothie'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'smoothie');
            },
            fillColor: _recipe.details.subCategory == 'smoothie'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 7,
          ),
          RawMaterialButton(
            child: Text('shake'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'shake');
            },
            fillColor: _recipe.details.subCategory == 'shake'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 7,
          ),
          RawMaterialButton(
            child: Text('other'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'other');
            },
            fillColor: _recipe.details.subCategory == 'other'
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
