import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

class FoodSubCategories extends HookWidget {
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
              _recipe.changeSubCategory(newSubCategory: 'breakfast');
            },
            fillColor: _recipe.recipeModel.subCategory == 'breakfast'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('breakfast'.tr()),
          ),
          const SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'appetizer');
            },
            fillColor: _recipe.recipeModel.subCategory == 'appetizer'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('appetizer'.tr()),
          ),
          const SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'salad');
            },
            fillColor: _recipe.recipeModel.subCategory == 'salad'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('salad'.tr()),
          ),
          const SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'soup');
            },
            fillColor: _recipe.recipeModel.subCategory == 'soup'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('soup'.tr()),
          ),
          const SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'dinner');
            },
            fillColor: _recipe.recipeModel.subCategory == 'dinner'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('dinner'.tr()),
          ),
          const SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            fillColor: _recipe.recipeModel.subCategory == 'dessert'
                ? Colors.green
                : Theme.of(context).cardColor,
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'dessert');
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('dessert'.tr()),
          ),
          const SizedBox(
            width: 4,
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
